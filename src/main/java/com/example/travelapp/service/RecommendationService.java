package com.example.travelapp.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.travelapp.model.Booking;
import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.model.UserPreference;
import com.example.travelapp.dto.TripBundleDTO;
import com.example.travelapp.repo.BookingRepository;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import com.example.travelapp.repo.UserPreferenceRepository;

/**
 * Rule-based recommender that stays deterministic and explainable.
 */
@Service
public class RecommendationService {

    private static final int MAX_RESULTS = 4;
    private static final Set<String> REGION_LABELS = Set.of(
            "asia",
            "europe",
            "america",
            "australia/new zealand",
            "australia",
            "new zealand"
    );

    @Autowired private FlightRepository flightRepository;
    @Autowired private HotelRepository hotelRepository;
    @Autowired private UserPreferenceRepository userPreferenceRepository;
    @Autowired private BookingRepository bookingRepository;
    @Autowired private GroqService groqService;

    /** Controller should call this */
    public RecommendationResult recommendForUser(Long userId) {
        UserPreference pref = userPreferenceRepository.findByUserId(userId); // may be null
        List<Booking> history = bookingRepository.findByUserId(userId);
        return recommend(pref, history, null);
    }

    /** Uses provided preferences for matching without saving them. */
    public RecommendationResult recommendForUser(Long userId, UserPreference prefOverride) {
        UserPreference pref = prefOverride != null ? prefOverride : userPreferenceRepository.findByUserId(userId);
        List<Booking> history = bookingRepository.findByUserId(userId);
        return recommend(pref, history, null);
    }

    /** Uses provided preferences + destination anchor without saving them. */
    public RecommendationResult recommendForUser(Long userId, UserPreference prefOverride, String destinationAnchor) {
        UserPreference pref = prefOverride != null ? prefOverride : userPreferenceRepository.findByUserId(userId);
        List<Booking> history = bookingRepository.findByUserId(userId);
        return recommend(pref, history, destinationAnchor);
    }

    public RecommendationResult recommend(UserPreference pref, List<Booking> history, String destinationAnchor) {
        RecommendationInputs inputs = RecommendationInputs.from(pref, history, destinationAnchor);

        List<ScoredItem<Flight>> scoredFlights = new ArrayList<>();
        for (Flight f : flightRepository.findAll()) {
            ScoredItem<Flight> scored = scoreFlight(f, inputs);
            if (scored != null) {
                scoredFlights.add(scored);
            }
        }
        scoredFlights.sort(Comparator.comparingDouble(ScoredItem<Flight>::score).reversed()
                .thenComparingDouble(ScoredItem::priceValue));

        List<ScoredItem<Hotel>> scoredHotels = new ArrayList<>();
        for (Hotel h : hotelRepository.findAll()) {
            ScoredItem<Hotel> scored = scoreHotel(h, inputs);
            if (scored != null) {
                scoredHotels.add(scored);
            }
        }
        scoredHotels.sort(Comparator.comparingDouble(ScoredItem<Hotel>::score).reversed()
                .thenComparingDouble(ScoredItem::priceValue));

        List<Flight> baseTopFlights = selectTopFlights(scoredFlights, (Map<Long, List<String>>) null);
        String chosenDestination = chooseDestination(inputs, baseTopFlights, scoredFlights, scoredHotels);

        List<ScoredItem<Flight>> finalFlightScores = scoredFlights;
        if (!isBlank(chosenDestination)) {
            List<ScoredItem<Flight>> filtered = filterFlightsByDestination(scoredFlights, chosenDestination);
            if (!filtered.isEmpty()) {
                finalFlightScores = filtered;
            }
        }

        Map<Long, List<String>> flightReasonsById = new LinkedHashMap<>();
        List<Flight> topFlights = selectTopFlights(finalFlightScores, flightReasonsById);

        Map<Long, List<String>> hotelReasonsById = new LinkedHashMap<>();
        List<ScoredItem<Hotel>> scoredHotelsForDestination = scoreHotelsForDestination(scoredHotels, chosenDestination);
        boolean hotelFallbackUsed = false;
        String hotelFallbackRegion = "";
        List<ScoredItem<Hotel>> finalHotelScores = scoredHotelsForDestination;

        if (finalHotelScores.isEmpty() && !isBlank(chosenDestination)) {
            hotelFallbackUsed = true;
            hotelFallbackRegion = fallbackRegionLabel(inputs, baseTopFlights);
            finalHotelScores = scoreHotelsWithFallback(scoredHotels, chosenDestination, hotelFallbackRegion);
        }

        List<Hotel> topHotels = selectTopHotels(finalHotelScores, hotelReasonsById);
        List<TripBundleDTO> bundles = buildBundles(topFlights, topHotels, chosenDestination, inputs);

        String summary = buildBookingSummary(pref, inputs, topFlights, topHotels);
        List<String> aiReasons = collectTopReasons(flightReasonsById, hotelReasonsById);
        String aiSummary = buildAiSummary(pref, inputs, topFlights, topHotels, chosenDestination, aiReasons);
        if (aiSummary != null) {
            summary = aiSummary;
        }
        String itinerary = buildAiItinerary(pref, inputs, topFlights, topHotels, chosenDestination);

        return new RecommendationResult(
                topFlights,
                topHotels,
                summary,
                flightReasonsById,
                hotelReasonsById,
                chosenDestination,
                hotelFallbackUsed,
                hotelFallbackRegion,
                bundles,
                itinerary
        );
    }

    private ScoredItem<Flight> scoreFlight(Flight flight, RecommendationInputs inputs) {
        if (flight == null) return null;
        int seatsLeft = safeInt(flight.getAvailableSeats());
        if (seatsLeft <= 0) return null;

        if (!isBlank(inputs.destinationAnchor)
                && !matchesDestinationAnchor(inputs.destinationAnchor, flight.getDestination())) {
            return null;
        }

        if (!matchesPreferredRegion(inputs.preferredRegion, flight.getRegion(), flight.getDestination())) {
            return null;
        }

        double score = 0.0;
        List<String> reasons = new ArrayList<>();

        if (!isBlank(inputs.preferredRegion)) {
            score += 3.0;
            reasons.add("Matches your preferred region: " + inputs.preferredRegion);
        }

        if (!isBlank(inputs.destinationAnchor)
                && matchesDestinationAnchor(inputs.destinationAnchor, flight.getDestination())) {
            score += 2.0;
            reasons.add("Destination matches selected: " + inputs.destinationAnchor);
        }

        BigDecimal price = flight.getPrice();
        if (inputs.budgetBand != BudgetBand.UNKNOWN && price != null) {
            if (isFlightPriceInBand(price, inputs.budgetBand)) {
                score += 2.0;
                reasons.add("Fits your budget preference (" + inputs.budgetLabel() + ")");
            } else {
                score -= 1.0;
            }
        }

        String style = safeLower(inputs.travelStyle);
        CabinClass cabin = classifyCabin(flight.getCabinClass());
        if (style.contains("backpack") || style.contains("budget")) {
            if (cabin == CabinClass.ECONOMY) {
                score += 2.0;
                reasons.add("Suitable for backpacking: Economy cabin");
            } else if (cabin == CabinClass.BUSINESS || cabin == CabinClass.FIRST) {
                score -= 2.0;
            }
        } else if (style.contains("lux")) {
            if (cabin == CabinClass.BUSINESS || cabin == CabinClass.FIRST || cabin == CabinClass.PREMIUM_ECONOMY) {
                score += 2.0;
                reasons.add("Luxury-friendly cabin class");
            } else if (cabin == CabinClass.ECONOMY) {
                score -= 1.0;
            }
        } else if (style.contains("business")) {
            if (cabin == CabinClass.BUSINESS) {
                score += 2.0;
                reasons.add("Business travel fit: Business class");
            }
        } else if (style.contains("family")) {
            if (cabin == CabinClass.ECONOMY || cabin == CabinClass.PREMIUM_ECONOMY) {
                score += 1.0;
                reasons.add("Family-friendly cabin option");
            }
        }

        score += 1.0;
        reasons.add("Seats available for booking");

        List<String> finalReasons = finalizeReasons(reasons, "Available flight option");
        double priceValue = price == null ? Double.MAX_VALUE : price.doubleValue();
        return new ScoredItem<>(flight, score, priceValue, finalReasons);
    }

    private ScoredItem<Hotel> scoreHotel(Hotel hotel, RecommendationInputs inputs) {
        if (hotel == null) return null;
        int roomsLeft = safeInt(hotel.getAvailableRooms());
        if (roomsLeft <= 0) return null;

        if (!matchesPreferredRegion(inputs.preferredRegion, hotel.getRegion(), hotel.getLocation())) {
            return null;
        }

        double score = 0.0;
        List<String> reasons = new ArrayList<>();

        if (!isBlank(inputs.preferredRegion)) {
            score += 3.0;
            reasons.add("Matches your preferred region: " + inputs.preferredRegion);
        }

        BigDecimal price = hotel.getPricePerNight();
        if (inputs.budgetBand != BudgetBand.UNKNOWN && price != null) {
            if (isHotelPriceInBand(price, inputs.budgetBand)) {
                score += 2.0;
                reasons.add("Fits your budget preference (" + inputs.budgetLabel() + ")");
            } else {
                score -= 1.0;
            }
        }

        String style = safeLower(inputs.travelStyle);
        Integer stars = hotel.getStars();
        int starVal = stars == null ? 0 : stars;
        if (style.contains("backpack") || style.contains("budget")) {
            if (starVal >= 2 && starVal <= 3) {
                score += 2.0;
                reasons.add("Star rating suits backpacking style");
            } else if (starVal >= 5) {
                score -= 1.0;
            }
        } else if (style.contains("lux")) {
            if (starVal >= 4) {
                score += 2.0;
                reasons.add("Higher star rating fits luxury travel");
            }
        } else if (style.contains("family")) {
            if (starVal >= 3 && starVal <= 4) {
                score += 2.0;
                reasons.add("Comfortable star rating for families");
            }
            if (containsAmenity(hotel, "pool") || containsAmenity(hotel, "family")) {
                score += 1.0;
                reasons.add("Amenities include family-friendly options");
            }
        } else if (style.contains("business")) {
            if (starVal >= 3 && starVal <= 4) {
                score += 1.0;
                reasons.add("Good mid-range business stay");
            }
            if (containsAmenity(hotel, "wifi") || containsAmenity(hotel, "business")
                    || containsAmenity(hotel, "conference")) {
                score += 1.0;
                reasons.add("Amenities support business travel");
            }
        }

        if (!isBlank(inputs.accommodationType)) {
            String acc = safeLower(inputs.accommodationType);
            if (containsText(hotel.getName(), acc) || containsText(hotel.getDescription(), acc)
                    || containsText(hotel.getAmenities(), acc)) {
                score += 1.0;
                reasons.add("Accommodation type match: " + inputs.accommodationType);
            }
        }

        List<String> interestMatches = findInterestMatches(hotel, inputs.interests);
        if (!interestMatches.isEmpty()) {
            score += 1.0;
            reasons.add("Amenities match your interests: " + String.join(", ", interestMatches));
        }

        score += 1.0;
        reasons.add("Rooms available for booking");

        List<String> finalReasons = finalizeReasons(reasons, "Available hotel option");
        double priceValue = price == null ? Double.MAX_VALUE : price.doubleValue();
        return new ScoredItem<>(hotel, score, priceValue, finalReasons);
    }

    private List<ScoredItem<Hotel>> scoreHotelsForDestination(List<ScoredItem<Hotel>> scoredHotels,
                                                              String chosenDestination) {
        if (isBlank(chosenDestination)) return scoredHotels;
        List<ScoredItem<Hotel>> filtered = new ArrayList<>();
        for (ScoredItem<Hotel> scored : scoredHotels) {
            if (scored == null || scored.item() == null) continue;
            Hotel hotel = scored.item();
            if (!matchesDestinationAnchor(chosenDestination, hotel.getLocation())) continue;
            List<String> reasons = new ArrayList<>(scored.reasons());
            reasons.add(0, "Located in " + chosenDestination + " to match your flight");
            List<String> finalReasons = finalizeReasons(reasons, "Available hotel option");
            filtered.add(new ScoredItem<>(hotel, scored.score(), scored.priceValue(), finalReasons));
        }
        return filtered;
    }

    private List<ScoredItem<Hotel>> scoreHotelsWithFallback(List<ScoredItem<Hotel>> scoredHotels,
                                                            String chosenDestination,
                                                            String fallbackRegion) {
        List<ScoredItem<Hotel>> fallback = new ArrayList<>();
        for (ScoredItem<Hotel> scored : scoredHotels) {
            if (scored == null || scored.item() == null) continue;
            if (!isBlank(fallbackRegion)
                    && !matchesPreferredRegion(fallbackRegion, scored.item().getRegion(), scored.item().getLocation())) {
                continue;
            }
            List<String> reasons = new ArrayList<>(scored.reasons());
            if (!isBlank(chosenDestination)) {
                String regionLabel = fallbackRegion.isBlank() ? "the selected region" : fallbackRegion;
                reasons.add(0, "No hotels found in " + chosenDestination + "; showing closest matches in " + regionLabel);
            }
            List<String> finalReasons = finalizeReasons(reasons, "Available hotel option");
            fallback.add(new ScoredItem<>(scored.item(), scored.score(), scored.priceValue(), finalReasons));
        }
        return fallback;
    }

    private String buildBookingSummary(UserPreference pref, RecommendationInputs inputs,
                                       List<Flight> flights, List<Hotel> hotels) {
        String travelStyle = displayValue(pref == null ? null : pref.getTravelStyle());
        String destination = displayValue(pref == null ? null : pref.getPreferredDestinations());
        String budget = displayValue(pref == null ? null : pref.getBudgetRange());
        StringBuilder summary = new StringBuilder();

        if (!travelStyle.equals("Any") || !destination.equals("Any") || !budget.equals("Any")) {
            summary.append("Tailored recommendations based on your trip inputs.");
        } else {
            summary.append("Recommendations based on available flights and hotels.");
        }

        if ((flights == null || flights.isEmpty()) && (hotels == null || hotels.isEmpty())) {
            summary.append(" No matches yet. Try adjusting your region, budget, or travel style.");
        }

        return summary.toString();
    }

    private String buildAiSummary(UserPreference pref, RecommendationInputs inputs,
                                  List<Flight> flights, List<Hotel> hotels,
                                  String chosenDestination, List<String> reasons) {
        if (groqService == null) return null;
        String travelStyle = displayValue(pref == null ? null : pref.getTravelStyle());
        String destination = displayValue(pref == null ? null : pref.getPreferredDestinations());
        String budget = displayValue(pref == null ? null : pref.getBudgetRange());
        String accommodation = displayValue(pref == null ? null : pref.getAccommodationType());
        String interests = displayValue(pref == null ? null : pref.getInterests());
        int flightCount = flights == null ? 0 : flights.size();
        int hotelCount = hotels == null ? 0 : hotels.size();
        String anchor = displayValue(chosenDestination);
        String reasonSummary = reasons == null || reasons.isEmpty()
                ? "None"
                : String.join("; ", reasons);

        StringBuilder prompt = new StringBuilder();
        prompt.append("Write 1-2 sentences explaining why these recommendations were chosen.\n");
        prompt.append("Do not mention specific flight or hotel names, airlines, or prices.\n");
        prompt.append("Use only the provided inputs and reason summary.\n");
        prompt.append("Inputs: style=").append(travelStyle);
        prompt.append(", region=").append(destination);
        prompt.append(", destination=").append(anchor);
        prompt.append(", budget=").append(budget);
        prompt.append(", accommodation=").append(accommodation);
        prompt.append(", interests=").append(interests);
        prompt.append(", flights=").append(flightCount);
        prompt.append(", hotels=").append(hotelCount).append(".");
        prompt.append(" Reasons: ").append(reasonSummary).append(".");

        String response = groqService.generate(prompt.toString());
        return cleanAiResponse(response);
    }

    private String buildAiItinerary(UserPreference pref, RecommendationInputs inputs,
                                    List<Flight> flights, List<Hotel> hotels,
                                    String chosenDestination) {
        if (groqService == null || inputs == null) return null;
        String destination = safeTrim(chosenDestination);
        if (destination.isBlank()) {
            destination = safeTrim(inputs.destinationAnchor);
        }
        if (destination.isBlank()) {
            return null;
        }

        String travelStyle = displayValue(pref == null ? null : pref.getTravelStyle());
        String budget = displayValue(pref == null ? null : pref.getBudgetRange());
        String interests = displayValue(pref == null ? null : pref.getInterests());
        String accommodation = displayValue(pref == null ? null : pref.getAccommodationType());
        int flightCount = flights == null ? 0 : flights.size();
        int hotelCount = hotels == null ? 0 : hotels.size();

        StringBuilder prompt = new StringBuilder();
        prompt.append("Create a concise 3-day travel itinerary for ").append(destination).append(".\n");
        prompt.append("Format as Day 1/Day 2/Day 3 with Morning/Afternoon/Evening items.\n");
        prompt.append("Use plain text only (no HTML), and keep each item short.\n");
        prompt.append("Consider these preferences: style=").append(travelStyle);
        prompt.append(", budget=").append(budget);
        prompt.append(", interests=").append(interests);
        prompt.append(", accommodation=").append(accommodation).append(".\n");
        prompt.append("Do not mention specific flight or hotel names, airlines, or prices.\n");
        prompt.append("Available options: flights=").append(flightCount);
        prompt.append(", hotels=").append(hotelCount).append(".");

        String response = groqService.generate(prompt.toString());
        return cleanAiResponse(response);
    }

    private static String cleanAiResponse(String response) {
        if (response == null) return null;
        String trimmed = response.trim();
        if (trimmed.isEmpty()) return null;
        String lower = trimmed.toLowerCase(Locale.ROOT);
        if (lower.startsWith("groq error") || lower.startsWith("groq returned no content")) {
            return null;
        }
        return trimmed;
    }

    private static List<String> collectTopReasons(Map<Long, List<String>> flightReasons,
                                                  Map<Long, List<String>> hotelReasons) {
        List<String> combined = new ArrayList<>();
        if (flightReasons != null) {
            for (List<String> reasons : flightReasons.values()) {
                if (reasons == null) continue;
                for (String reason : reasons) {
                    if (reason == null || reason.isBlank()) continue;
                    if (!combined.contains(reason)) {
                        combined.add(reason);
                    }
                    if (combined.size() >= 6) return combined;
                }
            }
        }
        if (hotelReasons != null) {
            for (List<String> reasons : hotelReasons.values()) {
                if (reasons == null) continue;
                for (String reason : reasons) {
                    if (reason == null || reason.isBlank()) continue;
                    if (!combined.contains(reason)) {
                        combined.add(reason);
                    }
                    if (combined.size() >= 6) return combined;
                }
            }
        }
        return combined;
    }

    private static String chooseDestination(RecommendationInputs inputs,
                                            List<Flight> topFlights,
                                            List<ScoredItem<Flight>> scoredFlights,
                                            List<ScoredItem<Hotel>> scoredHotels) {
        if (!isBlank(inputs.destinationAnchor)) {
            return inputs.destinationAnchor;
        }
        if (topFlights != null && !topFlights.isEmpty()) {
            String dest = safeTrim(topFlights.get(0).getDestination());
            if (!dest.isBlank()) return dest;
        }
        return findPopularDestination(inputs.preferredRegion, scoredFlights, scoredHotels);
    }

    private static String findPopularDestination(String preferredRegion,
                                                 List<ScoredItem<Flight>> scoredFlights,
                                                 List<ScoredItem<Hotel>> scoredHotels) {
        Map<String, Integer> counts = new LinkedHashMap<>();
        if (scoredFlights != null) {
            for (ScoredItem<Flight> scored : scoredFlights) {
                if (scored == null || scored.item() == null) continue;
                Flight flight = scored.item();
                if (!matchesPreferredRegion(preferredRegion, flight.getRegion(), flight.getDestination())) {
                    continue;
                }
                String dest = safeTrim(flight.getDestination());
                if (dest.isBlank()) continue;
                counts.put(dest, counts.getOrDefault(dest, 0) + 1);
            }
        }
        if (scoredHotels != null) {
            for (ScoredItem<Hotel> scored : scoredHotels) {
                if (scored == null || scored.item() == null) continue;
                Hotel hotel = scored.item();
                if (!matchesPreferredRegion(preferredRegion, hotel.getRegion(), hotel.getLocation())) {
                    continue;
                }
                String loc = safeTrim(hotel.getLocation());
                if (loc.isBlank()) continue;
                counts.put(loc, counts.getOrDefault(loc, 0) + 1);
            }
        }
        String best = "";
        int bestCount = 0;
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            int value = entry.getValue();
            if (value > bestCount) {
                best = entry.getKey();
                bestCount = value;
            }
        }
        return best;
    }

    private static String fallbackRegionLabel(RecommendationInputs inputs, List<Flight> topFlights) {
        String region = safeTrim(inputs.preferredRegion);
        if (!region.isBlank()) return region;
        if (topFlights != null) {
            for (Flight flight : topFlights) {
                String flightRegion = safeTrim(flight == null ? null : flight.getRegion());
                if (!flightRegion.isBlank()) return flightRegion;
            }
        }
        return "";
    }

    private static List<ScoredItem<Flight>> filterFlightsByDestination(List<ScoredItem<Flight>> scoredFlights,
                                                                       String chosenDestination) {
        List<ScoredItem<Flight>> filtered = new ArrayList<>();
        for (ScoredItem<Flight> scored : scoredFlights) {
            if (scored == null || scored.item() == null) continue;
            if (matchesDestinationAnchor(chosenDestination, scored.item().getDestination())) {
                filtered.add(scored);
            }
        }
        return filtered;
    }

    private static List<Flight> selectTopFlights(List<ScoredItem<Flight>> scoredFlights,
                                                 Map<Long, List<String>> reasonsById) {
        List<Flight> flights = new ArrayList<>();
        if (scoredFlights == null) return flights;
        for (ScoredItem<Flight> scored : scoredFlights) {
            if (flights.size() >= MAX_RESULTS) break;
            Flight flight = scored.item();
            if (flight == null || flight.getId() == null) continue;
            flights.add(flight);
            if (reasonsById != null) {
                reasonsById.put(flight.getId(), scored.reasons());
            }
        }
        return flights;
    }

    private static List<Hotel> selectTopHotels(List<ScoredItem<Hotel>> scoredHotels,
                                               Map<Long, List<String>> reasonsById) {
        List<Hotel> hotels = new ArrayList<>();
        if (scoredHotels == null) return hotels;
        for (ScoredItem<Hotel> scored : scoredHotels) {
            if (hotels.size() >= MAX_RESULTS) break;
            Hotel hotel = scored.item();
            if (hotel == null || hotel.getId() == null) continue;
            hotels.add(hotel);
            if (reasonsById != null) {
                reasonsById.put(hotel.getId(), scored.reasons());
            }
        }
        return hotels;
    }

    private static List<TripBundleDTO> buildBundles(List<Flight> flights,
                                                    List<Hotel> hotels,
                                                    String chosenDestination,
                                                    RecommendationInputs inputs) {
        if (flights == null || hotels == null) return List.of();
        List<TripBundleDTO> bundles = new ArrayList<>();
        List<Long> usedHotelIds = new ArrayList<>();
        for (Flight flight : flights) {
            if (flight == null) continue;
            String flightDestination = safeTrim(flight.getDestination());
            if (!isBlank(chosenDestination)
                    && !matchesDestinationAnchor(chosenDestination, flightDestination)) {
                continue;
            }
            Hotel matchingHotel = null;
            for (Hotel hotel : hotels) {
                if (hotel == null || hotel.getId() == null) continue;
                if (usedHotelIds.contains(hotel.getId())) continue;
                if (matchesDestinationAnchor(flightDestination, hotel.getLocation())) {
                    matchingHotel = hotel;
                    break;
                }
            }
            if (matchingHotel == null) {
                continue;
            }
            usedHotelIds.add(matchingHotel.getId());
            BigDecimal total = BigDecimal.ZERO;
            if (flight != null && flight.getPrice() != null) {
                total = total.add(flight.getPrice());
            }
            if (matchingHotel.getPricePerNight() != null) {
                total = total.add(matchingHotel.getPricePerNight());
            }
            List<String> reasons = new ArrayList<>();
            if (!flightDestination.isBlank()) {
                reasons.add("Flight + hotel aligned to " + flightDestination);
            }
            if (!isBlank(inputs.preferredRegion)) {
                reasons.add("Matches region: " + inputs.preferredRegion);
            }
            if (reasons.isEmpty()) {
                reasons.add("Balanced bundle based on available options");
            }
            bundles.add(new TripBundleDTO(flight, matchingHotel, total, reasons));
            if (bundles.size() >= 3) {
                break;
            }
        }
        return bundles;
    }

    private static boolean matchesPreferredRegion(String preferredRegion, String region, String location) {
        if (isBlank(preferredRegion)) return true;
        String pref = normalizeRegion(preferredRegion);
        String regionText = normalizeRegion(region);
        String locationText = normalizeRegion(location);

        if (!isRegionLabel(pref) && !pref.contains("/")) {
            return matchesDestinationAnchor(preferredRegion, location)
                    || matchesDestinationAnchor(preferredRegion, region);
        }

        if (!pref.isBlank() && pref.contains("/")) {
            String[] parts = pref.split("/");
            for (String part : parts) {
                String p = part.trim();
                if (!p.isEmpty() && (regionText.contains(p) || locationText.contains(p))) {
                    return true;
                }
            }
        }
        return regionText.contains(pref) || locationText.contains(pref);
    }

    private static boolean matchesDestinationAnchor(String destinationAnchor, String location) {
        if (isBlank(destinationAnchor) || location == null) return false;
        List<String> anchorTokens = tokenizeLocation(destinationAnchor);
        List<String> locationTokens = tokenizeLocation(location);
        if (anchorTokens.isEmpty() || locationTokens.isEmpty()) return false;
        if (anchorTokens.size() == 1) {
            String token = anchorTokens.get(0);
            for (String locToken : locationTokens) {
                if (locToken.equals(token)) return true;
            }
            return false;
        }
        if (containsTokenSequence(locationTokens, anchorTokens)) return true;
        if (containsTokenSequence(anchorTokens, locationTokens)) return true;
        for (String token : anchorTokens) {
            if (locationTokens.contains(token)) return true;
        }
        return false;
    }

    private static List<String> tokenizeLocation(String value) {
        if (value == null) return List.of();
        String cleaned = safeLower(value).replaceAll("[^a-z0-9]+", " ").trim();
        if (cleaned.isBlank()) return List.of();
        String[] parts = cleaned.split("\\s+");
        List<String> tokens = new ArrayList<>();
        for (String part : parts) {
            if (!part.isBlank()) {
                tokens.add(part);
            }
        }
        return tokens;
    }

    private static boolean containsTokenSequence(List<String> haystack, List<String> needle) {
        if (haystack == null || needle == null || haystack.isEmpty() || needle.isEmpty()) return false;
        if (needle.size() > haystack.size()) return false;
        int limit = haystack.size() - needle.size();
        for (int i = 0; i <= limit; i++) {
            boolean match = true;
            for (int j = 0; j < needle.size(); j++) {
                if (!haystack.get(i + j).equals(needle.get(j))) {
                    match = false;
                    break;
                }
            }
            if (match) return true;
        }
        return false;
    }

    private static boolean isFlightPriceInBand(BigDecimal price, BudgetBand band) {
        if (price == null) return false;
        double val = price.doubleValue();
        return switch (band) {
            case LOW -> val <= 500;
            case MEDIUM -> val >= 501 && val <= 1200;
            case HIGH -> val > 1200;
            default -> false;
        };
    }

    private static boolean isHotelPriceInBand(BigDecimal price, BudgetBand band) {
        if (price == null) return false;
        double val = price.doubleValue();
        return switch (band) {
            case LOW -> val <= 150;
            case MEDIUM -> val >= 151 && val <= 350;
            case HIGH -> val > 350;
            default -> false;
        };
    }

    private static CabinClass classifyCabin(String cabinClass) {
        String cabin = safeLower(cabinClass);
        if (cabin.contains("first")) return CabinClass.FIRST;
        if (cabin.contains("business")) return CabinClass.BUSINESS;
        if (cabin.contains("premium") || cabin.contains("economy plus") || cabin.contains("economy+")) {
            return CabinClass.PREMIUM_ECONOMY;
        }
        if (cabin.contains("economy")) return CabinClass.ECONOMY;
        return CabinClass.UNKNOWN;
    }

    private static List<String> findInterestMatches(Hotel hotel, List<String> interests) {
        if (hotel == null || interests == null || interests.isEmpty()) return List.of();
        String amenities = safeTrim(hotel.getAmenities());
        String description = safeTrim(hotel.getDescription());
        String hay = safeLower(amenities + " " + description);
        Set<String> matches = new LinkedHashSet<>();
        for (String interest : interests) {
            if (interest.isBlank()) continue;
            if (hay.contains(interest)) {
                matches.add(interest);
            }
            if (matches.size() >= 2) break;
        }
        return new ArrayList<>(matches);
    }

    private static boolean containsAmenity(Hotel hotel, String token) {
        if (hotel == null) return false;
        return containsText(hotel.getAmenities(), token);
    }

    private static boolean containsText(String text, String token) {
        if (text == null || token == null || token.isBlank()) return false;
        return safeLower(text).contains(safeLower(token));
    }

    private static List<String> finalizeReasons(List<String> reasons, String fallback) {
        List<String> unique = new ArrayList<>();
        for (String reason : reasons) {
            if (reason == null || reason.isBlank()) continue;
            if (!unique.contains(reason)) {
                unique.add(reason);
            }
        }
        if (unique.size() < 2 && fallback != null && !fallback.isBlank()) {
            unique.add(fallback);
        }
        if (unique.size() > 3) {
            return unique.subList(0, 3);
        }
        return unique;
    }

    private static int safeInt(Integer value) {
        return value == null ? 0 : value;
    }

    private static String safeLower(String value) {
        return value == null ? "" : value.trim().toLowerCase(Locale.ROOT);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static String normalizeRegion(String value) {
        if (value == null) return "";
        return value.trim().toLowerCase(Locale.ROOT).replaceAll("\\s+", " ");
    }

    private static String displayValue(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "Any";
        }
        return value.trim();
    }

    private static boolean isRegionLabel(String value) {
        return value != null && REGION_LABELS.contains(normalizeRegion(value));
    }

    private static BudgetBand parseBudgetBand(String budgetRange) {
        if (budgetRange == null) return BudgetBand.UNKNOWN;
        String b = budgetRange.toLowerCase(Locale.ROOT);
        if (b.contains("low") || b.contains("budget")) {
            return BudgetBand.LOW;
        }
        if (b.contains("medium") || b.contains("mid") || b.contains("standard")) {
            return BudgetBand.MEDIUM;
        }
        if (b.contains("high") || b.contains("lux")) {
            return BudgetBand.HIGH;
        }
        return BudgetBand.UNKNOWN;
    }

    private static List<String> parseTokens(String raw) {
        if (raw == null) return List.of();
        String[] parts = raw.split("[,;/]");
        List<String> tokens = new ArrayList<>();
        for (String part : parts) {
            String cleaned = safeLower(part);
            if (!cleaned.isBlank()) {
                tokens.add(cleaned);
            }
        }
        return tokens;
    }

    private static String deriveRegionFromHistory(List<Booking> history) {
        if (history == null) return "";
        for (Booking booking : history) {
            if (booking == null) continue;
            if (booking.getFlight() != null) {
                String region = safeTrim(booking.getFlight().getRegion());
                if (!region.isBlank()) return region;
                String dest = safeTrim(booking.getFlight().getDestination());
                if (!dest.isBlank() && isRegionLabel(dest)) return dest;
            }
            if (booking.getHotel() != null) {
                String region = safeTrim(booking.getHotel().getRegion());
                if (!region.isBlank()) return region;
                String loc = safeTrim(booking.getHotel().getLocation());
                if (!loc.isBlank() && isRegionLabel(loc)) return loc;
            }
        }
        return "";
    }

    private static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private static class RecommendationInputs {
        final String preferredRegion;
        final String budgetRange;
        final BudgetBand budgetBand;
        final String travelStyle;
        final String accommodationType;
        final List<String> interests;
        final String destinationAnchor;

        private RecommendationInputs(String preferredRegion,
                                     String budgetRange,
                                     BudgetBand budgetBand,
                                     String travelStyle,
                                     String accommodationType,
                                     List<String> interests,
                                     String destinationAnchor) {
            this.preferredRegion = preferredRegion;
            this.budgetRange = budgetRange;
            this.budgetBand = budgetBand;
            this.travelStyle = travelStyle;
            this.accommodationType = accommodationType;
            this.interests = interests;
            this.destinationAnchor = destinationAnchor;
        }

        static RecommendationInputs from(UserPreference pref, List<Booking> history, String destinationAnchor) {
            String preferredRegion = safeTrim(pref == null ? null : pref.getPreferredDestinations());
            if (preferredRegion.isBlank()) {
                preferredRegion = deriveRegionFromHistory(history);
            }
            String budgetRange = safeTrim(pref == null ? null : pref.getBudgetRange());
            BudgetBand budgetBand = parseBudgetBand(budgetRange);
            String travelStyle = safeTrim(pref == null ? null : pref.getTravelStyle());
            String accommodationType = safeTrim(pref == null ? null : pref.getAccommodationType());
            List<String> interests = parseTokens(pref == null ? null : pref.getInterests());
            String destination = safeTrim(destinationAnchor);
            return new RecommendationInputs(preferredRegion, budgetRange, budgetBand, travelStyle,
                    accommodationType, interests, destination);
        }

        String budgetLabel() {
            if (!budgetRange.isBlank()) return budgetRange;
            return switch (budgetBand) {
                case LOW -> "Low";
                case MEDIUM -> "Medium";
                case HIGH -> "High";
                default -> "Any";
            };
        }
    }

    private enum BudgetBand {
        LOW,
        MEDIUM,
        HIGH,
        UNKNOWN
    }

    private enum CabinClass {
        ECONOMY,
        PREMIUM_ECONOMY,
        BUSINESS,
        FIRST,
        UNKNOWN
    }

    private static class ScoredItem<T> {
        private final T item;
        private final double score;
        private final double priceValue;
        private final List<String> reasons;

        ScoredItem(T item, double score, double priceValue, List<String> reasons) {
            this.item = item;
            this.score = score;
            this.priceValue = priceValue;
            this.reasons = reasons == null ? List.of() : reasons;
        }

        T item() { return item; }
        double score() { return score; }
        double priceValue() { return priceValue; }
        List<String> reasons() { return reasons; }
    }

    public static class RecommendationResult {
        private final List<Flight> flights;
        private final List<Hotel> hotels;
        private final String explanation;
        private final Map<Long, List<String>> flightReasonsById;
        private final Map<Long, List<String>> hotelReasonsById;
        private final String chosenDestination;
        private final boolean hotelFallbackUsed;
        private final String hotelFallbackRegion;
        private final List<TripBundleDTO> bundles;
        private final String itinerary;

        public RecommendationResult(List<Flight> flights,
                                    List<Hotel> hotels,
                                    String explanation,
                                    Map<Long, List<String>> flightReasonsById,
                                    Map<Long, List<String>> hotelReasonsById,
                                    String chosenDestination,
                                    boolean hotelFallbackUsed,
                                    String hotelFallbackRegion,
                                    List<TripBundleDTO> bundles,
                                    String itinerary) {
            this.flights = flights;
            this.hotels = hotels;
            this.explanation = explanation;
            this.flightReasonsById = flightReasonsById == null ? new HashMap<>() : flightReasonsById;
            this.hotelReasonsById = hotelReasonsById == null ? new HashMap<>() : hotelReasonsById;
            this.chosenDestination = chosenDestination;
            this.hotelFallbackUsed = hotelFallbackUsed;
            this.hotelFallbackRegion = hotelFallbackRegion;
            this.bundles = bundles == null ? List.of() : bundles;
            this.itinerary = itinerary;
        }

        public List<Flight> getFlights() { return flights; }
        public List<Hotel> getHotels() { return hotels; }
        public String getExplanation() { return explanation; }
        public Map<Long, List<String>> getFlightReasonsById() { return flightReasonsById; }
        public Map<Long, List<String>> getHotelReasonsById() { return hotelReasonsById; }
        public String getChosenDestination() { return chosenDestination; }
        public boolean isHotelFallbackUsed() { return hotelFallbackUsed; }
        public String getHotelFallbackRegion() { return hotelFallbackRegion; }
        public List<TripBundleDTO> getBundles() { return bundles; }
        public String getItinerary() { return itinerary; }
    }
}
