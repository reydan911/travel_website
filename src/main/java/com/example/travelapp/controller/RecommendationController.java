package com.example.travelapp.controller;

import com.example.travelapp.model.User;
import com.example.travelapp.model.UserPreference;
import com.example.travelapp.model.AddOn;
import com.example.travelapp.model.AddOnScope;
import com.example.travelapp.repo.UserPreferenceRepository;
import com.example.travelapp.repo.AddOnRepository;
import com.example.travelapp.repo.UserRepository;
import com.example.travelapp.service.RecommendationService;
import com.example.travelapp.service.RecommendationService.RecommendationResult;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class RecommendationController {

    @Autowired private UserRepository userRepository;
    @Autowired private RecommendationService recommendationService;
    @Autowired private AddOnRepository addOnRepository;
    @Autowired private UserPreferenceRepository userPreferenceRepository;

    @GetMapping("/recommendations")
    public String recommendationsPage(
            HttpSession session,
            Model model,
            @RequestParam(required = false) String preferredDestinations,
            @RequestParam(required = false) String destination,
            @RequestParam(required = false) String budgetRange,
            @RequestParam(required = false) String travelStyle,
            @RequestParam(required = false) String accommodationType,
            @RequestParam(required = false) String interests
    ) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            session.invalidate();
            return "redirect:/login";
        }
        model.addAttribute("user", user);

        UserPreference preference = buildPreferenceFromRequest(
                preferredDestinations,
                budgetRange,
                travelStyle,
                accommodationType,
                interests
        );
        savePreferenceIfProvided(userId, preference, destination);
        model.addAttribute("preference", preference);
        model.addAttribute("destinationAnchor", trimToNull(destination));

        RecommendationResult result = recommendationService.recommendForUser(userId, preference, destination);
        model.addAttribute("recommendedFlights", result.getFlights());
        model.addAttribute("recommendedHotels", result.getHotels());
        model.addAttribute("recommendations", result.getExplanation());
        model.addAttribute("flightReasonsById", result.getFlightReasonsById());
        model.addAttribute("hotelReasonsById", result.getHotelReasonsById());
        model.addAttribute("chosenDestination", result.getChosenDestination());
        model.addAttribute("hotelFallbackUsed", result.isHotelFallbackUsed());
        model.addAttribute("hotelFallbackRegion", result.getHotelFallbackRegion());
        model.addAttribute("bundles", result.getBundles());
        model.addAttribute("aiItinerary", result.getItinerary());
        model.addAttribute("flightAddOns", getFlightAddOns());
        model.addAttribute("hotelAddOns", getHotelAddOns());

        return "recommendations";
    }

    private UserPreference buildPreferenceFromRequest(
            String preferredDestinations,
            String budgetRange,
            String travelStyle,
            String accommodationType,
            String interests
    ) {
        if (isBlank(preferredDestinations)
                && isBlank(budgetRange)
                && isBlank(travelStyle)
                && isBlank(accommodationType)
                && isBlank(interests)) {
            return null;
        }

        UserPreference preference = new UserPreference();
        preference.setPreferredDestinations(trimToNull(preferredDestinations));
        preference.setBudgetRange(trimToNull(budgetRange));
        preference.setTravelStyle(trimToNull(travelStyle));
        preference.setAccommodationType(trimToNull(accommodationType));
        preference.setInterests(trimToNull(interests));
        return preference;
    }

    private void savePreferenceIfProvided(Long userId, UserPreference preference, String destinationAnchor) {
        if (userId == null || preference == null) {
            if (userId == null) {
                return;
            }
        }
        String destination = trimToNull(destinationAnchor);
        if (preference == null && destination == null) {
            return;
        }
        UserPreference existing = userPreferenceRepository.findByUserId(userId);
        UserPreference target = existing == null ? new UserPreference() : existing;
        target.setUserId(userId);
        if (preference != null) {
            target.setPreferredDestinations(preference.getPreferredDestinations());
            target.setBudgetRange(preference.getBudgetRange());
            target.setTravelStyle(preference.getTravelStyle());
            target.setAccommodationType(preference.getAccommodationType());
            target.setInterests(preference.getInterests());
        }
        if (destination != null
                && (target.getPreferredDestinations() == null || target.getPreferredDestinations().isBlank())) {
            target.setPreferredDestinations(destination);
        }
        userPreferenceRepository.save(target);
    }

    private static String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private List<AddOn> getFlightAddOns() {
        return addOnRepository.findByActiveTrueOrderByCategoryAscNameAsc().stream()
                .filter(addOn -> addOn.getScope() == AddOnScope.FLIGHT || addOn.getScope() == AddOnScope.BOTH)
                .toList();
    }

    private List<AddOn> getHotelAddOns() {
        return addOnRepository.findByActiveTrueOrderByCategoryAscNameAsc().stream()
                .filter(this::isHotelAddOn)
                .toList();
    }

    private boolean isHotelAddOn(AddOn addOn) {
        if (addOn == null || !addOn.isActive() || addOn.getName() == null) {
            return false;
        }
        String name = addOn.getName().trim().toLowerCase();
        return name.equals("room view upgrade") || name.equals("late check-out")
                || name.equals("breakfast upgrade") || name.equals("flexi change");
    }
}
