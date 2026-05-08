package com.example.travelapp.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.service.RecommendationService.RecommendationResult;

@Service
public class ChatService {

    @Autowired
    private RecommendationService recommendationService;

    public String getRecommendations(Long userId, String userMessage) {
        if (userId == null) {
            return "Please sign in to see personalized matches.";
        }

        RecommendationResult result = recommendationService.recommendForUser(userId);
        List<Flight> flights = result == null ? List.of() : safeFlights(result.getFlights());
        List<Hotel> hotels = result == null ? List.of() : safeHotels(result.getHotels());

        boolean wantsFlights = containsAny(userMessage, "flight", "flights", "air", "airline", "plane");
        boolean wantsHotels = containsAny(userMessage, "hotel", "hotels", "stay", "room", "resort");
        if (!wantsFlights && !wantsHotels) {
            wantsFlights = true;
            wantsHotels = true;
        }

        StringBuilder reply = new StringBuilder();
        reply.append("Personalized matches from your profile and booking history.");

        if (wantsFlights) {
            reply.append(" ");
            if (flights.isEmpty()) {
                reply.append("No flight matches yet.");
            } else {
                reply.append("Top flights: ").append(formatFlights(flights)).append(".");
            }
        }

        if (wantsHotels) {
            reply.append(" ");
            if (hotels.isEmpty()) {
                reply.append("No hotel matches yet.");
            } else {
                reply.append("Top hotels: ").append(formatHotels(hotels)).append(".");
            }
        }

        if (flights.isEmpty() && hotels.isEmpty()) {
            reply.append(" Update your preferences on the AI Suggestions page to improve matching.");
        }

        return reply.toString().trim();
    }

    private static boolean containsAny(String message, String... needles) {
        if (message == null || message.isBlank()) return false;
        String hay = message.toLowerCase(Locale.ROOT);
        for (String needle : needles) {
            if (hay.contains(needle)) return true;
        }
        return false;
    }

    private static List<Flight> safeFlights(List<Flight> flights) {
        return flights == null ? List.of() : flights;
    }

    private static List<Hotel> safeHotels(List<Hotel> hotels) {
        return hotels == null ? List.of() : hotels;
    }

    private static String formatFlights(List<Flight> flights) {
        return flights.stream()
                .limit(3)
                .map(ChatService::formatFlight)
                .collect(Collectors.joining("; "));
    }

    private static String formatHotels(List<Hotel> hotels) {
        return hotels.stream()
                .limit(3)
                .map(ChatService::formatHotel)
                .collect(Collectors.joining("; "));
    }

    private static String formatFlight(Flight flight) {
        StringBuilder sb = new StringBuilder();
        if (flight.getAirline() != null && !flight.getAirline().isBlank()) {
            sb.append(flight.getAirline().trim());
        }
        String route = buildRoute(flight.getOrigin(), flight.getDestination());
        if (!route.isBlank()) {
            if (sb.length() > 0) sb.append(" ");
            sb.append(route);
        }
        String price = formatMoney(flight.getPrice());
        if (!price.isBlank()) {
            sb.append(" (").append(price).append(")");
        }
        return sb.length() > 0 ? sb.toString() : "Flight option";
    }

    private static String formatHotel(Hotel hotel) {
        StringBuilder sb = new StringBuilder();
        if (hotel.getName() != null && !hotel.getName().isBlank()) {
            sb.append(hotel.getName().trim());
        }
        if (hotel.getLocation() != null && !hotel.getLocation().isBlank()) {
            if (sb.length() > 0) sb.append(" in ");
            sb.append(hotel.getLocation().trim());
        }
        String price = formatMoney(hotel.getPricePerNight());
        if (!price.isBlank()) {
            sb.append(" (").append(price).append(" per night)");
        }
        return sb.length() > 0 ? sb.toString() : "Hotel option";
    }

    private static String buildRoute(String origin, String destination) {
        String o = origin == null ? "" : origin.trim();
        String d = destination == null ? "" : destination.trim();
        if (o.isBlank() && d.isBlank()) return "";
        if (o.isBlank()) return "to " + d;
        if (d.isBlank()) return "from " + o;
        return o + " to " + d;
    }

    private static String formatMoney(BigDecimal amount) {
        if (amount == null) return "";
        BigDecimal normalized = amount.stripTrailingZeros();
        String value = normalized.scale() < 0 ? normalized.setScale(0).toPlainString() : normalized.toPlainString();
        return "RM " + value;
    }
}
