package com.example.travelapp.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.model.User;
import com.example.travelapp.model.AddOn;
import com.example.travelapp.model.AddOnScope;
import com.example.travelapp.repo.AddOnRepository;
import com.example.travelapp.repo.UserRepository;
import com.example.travelapp.service.FlightService;
import com.example.travelapp.service.HotelService;

@Controller
public class HomeController {

    @Autowired
    private FlightService flightService;

    @Autowired
    private HotelService hotelService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AddOnRepository addOnRepository;

    @GetMapping("/")
    public String home(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            User user = userRepository.findById(userId).orElse(null);
            model.addAttribute("user", user);
            return "home";
        }
        return "landing";
    }

    @GetMapping("/flights")
    public String flights(@RequestParam(defaultValue = "0") int page,
                          @RequestParam(defaultValue = "10") int size,
                          Model model,
                          HttpSession session) {
        return renderFlights(null, null, null, null, null, page, size, model, session);
    }

    @GetMapping("/hotels")
    public String hotels(@RequestParam(defaultValue = "0") int page,
                         @RequestParam(defaultValue = "10") int size,
                         Model model,
                         HttpSession session) {
        return renderHotels(null, null, null, null, page, size, model, session);
    }

    @GetMapping("/search-flights")
    public String searchFlights(
            @RequestParam(required = false) String origin,
            @RequestParam(required = false) String destination,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String maxPrice,
            @RequestParam(required = false) String sort,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            HttpSession session) {
        return renderFlights(origin, destination, date, maxPrice, sort, page, size, model, session);
    }

    @GetMapping("/search-hotels")
    public String searchHotels(
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String minStars,
            @RequestParam(required = false) String maxPrice,
            @RequestParam(required = false) String sort,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            HttpSession session) {
        return renderHotels(location, minStars, maxPrice, sort, page, size, model, session);
    }

    private String renderFlights(String origin,
                                 String destination,
                                 String date,
                                 String maxPrice,
                                 String sort,
                                 int page,
                                 int size,
                                 Model model,
                                 HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);

        String originQuery = normalizeQuery(origin);
        String destinationQuery = normalizeQuery(destination);
        LocalDate dateFilter = parseDate(date, model);
        BigDecimal maxPriceFilter = parsePrice(maxPrice, model);

        Page<Flight> flightsPage;
        try {
            flightsPage = flightService.searchFlightsPage(
                    originQuery,
                    destinationQuery,
                    dateFilter,
                    maxPriceFilter,
                    sort,
                    page,
                    size
            );
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            flightsPage = flightService.searchFlightsPage(
                    originQuery,
                    destinationQuery,
                    dateFilter,
                    maxPriceFilter,
                    null,
                    page,
                    size
            );
        }

        model.addAttribute("flights", flightsPage.getContent());
        model.addAttribute("flightAddOns", getFlightAddOns());
        model.addAttribute("flightPage", flightsPage);
        model.addAttribute("currentPage", flightsPage.getNumber());
        model.addAttribute("totalPages", flightsPage.getTotalPages());
        model.addAttribute("pageSize", flightsPage.getSize());
        model.addAttribute("origin", originQuery);
        model.addAttribute("destination", destinationQuery);
        model.addAttribute("date", dateFilter != null ? dateFilter.toString() : (date == null ? "" : date.trim()));
        model.addAttribute("maxPrice", maxPrice == null ? "" : maxPrice.trim());
        model.addAttribute("sort", sort == null ? "" : sort);
        return "flights";
    }

    private String renderHotels(String location,
                                String minStars,
                                String maxPrice,
                                String sort,
                                int page,
                                int size,
                                Model model,
                                HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);

        String locationQuery = normalizeQuery(location);
        Integer minStarsFilter = parseInteger(minStars, model, "minStars");
        if (minStarsFilter != null && (minStarsFilter < 1 || minStarsFilter > 5)) {
            model.addAttribute("error", "minStars must be between 1 and 5.");
            minStarsFilter = null;
        }
        BigDecimal maxPriceFilter = parsePrice(maxPrice, model);

        Page<Hotel> hotelsPage;
        try {
            hotelsPage = hotelService.searchHotelsPage(
                    locationQuery,
                    minStarsFilter,
                    maxPriceFilter,
                    sort,
                    page,
                    size
            );
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            hotelsPage = hotelService.searchHotelsPage(
                    locationQuery,
                    minStarsFilter,
                    maxPriceFilter,
                    null,
                    page,
                    size
            );
        }

        model.addAttribute("hotels", hotelsPage.getContent());
        model.addAttribute("hotelAddOns", getHotelAddOns());
        model.addAttribute("hotelPage", hotelsPage);
        model.addAttribute("currentPage", hotelsPage.getNumber());
        model.addAttribute("totalPages", hotelsPage.getTotalPages());
        model.addAttribute("pageSize", hotelsPage.getSize());
        model.addAttribute("location", locationQuery);
        model.addAttribute("minStars", minStarsFilter);
        model.addAttribute("maxPrice", maxPrice == null ? "" : maxPrice.trim());
        model.addAttribute("sort", sort == null ? "" : sort);
        return "hotels";
    }

    private User getSessionUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return null;
        }

        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            session.invalidate();
        }
        return user;
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

    private LocalDate parseDate(String value, Model model) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            String trimmed = value.trim();
            if (trimmed.contains("/")) {
                return LocalDate.parse(trimmed, java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }
            return LocalDate.parse(trimmed);
        } catch (DateTimeParseException ex) {
            model.addAttribute("error", "Invalid date format. Use YYYY-MM-DD.");
            return null;
        }
    }

    private BigDecimal parsePrice(String value, Model model) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            BigDecimal parsed = new BigDecimal(value.trim());
            if (parsed.compareTo(BigDecimal.ZERO) < 0) {
                model.addAttribute("error", "maxPrice must be positive.");
                return null;
            }
            return parsed;
        } catch (NumberFormatException ex) {
            model.addAttribute("error", "Invalid max price value.");
            return null;
        }
    }

    private Integer parseInteger(String value, Model model, String field) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            model.addAttribute("error", "Invalid " + field + " value.");
            return null;
        }
    }

    private String normalizeQuery(String value) {
        if (value == null) {
            return "";
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return "";
        }
        String lower = trimmed.toLowerCase();
        if (lower.equals("null") || lower.equals("undefined")) {
            return "";
        }
        return trimmed;
    }
}
