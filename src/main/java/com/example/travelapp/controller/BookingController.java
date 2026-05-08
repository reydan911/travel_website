package com.example.travelapp.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

import java.math.BigDecimal;
import java.util.List;

import com.example.travelapp.model.Booking;
import com.example.travelapp.model.BookingAddOn;
import com.example.travelapp.model.User;
import com.example.travelapp.repo.BookingRepository;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import com.example.travelapp.repo.UserRepository;
import com.example.travelapp.service.BookingService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/bookings")
public class BookingController {

    @Autowired private BookingRepository bookingRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private FlightRepository flightRepository;
    @Autowired private HotelRepository hotelRepository;
    @Autowired private BookingService bookingService;

    @GetMapping
    public String viewBookings(HttpSession session, Model model) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        model.addAttribute("bookings", bookingService.getBookingsForUser(user));
        return "bookings";
    }

    @PostMapping("/add")
    public String addBooking(
            HttpSession session,
            @RequestParam(required = false) Long flightId,
            @RequestParam(required = false) Long hotelId,
            @RequestParam(required = false) String flightDate,
            @RequestParam(required = false) String checkInDate,
            @RequestParam(required = false) String hotelNights,
            @RequestParam(required = false) String pax,
            @RequestParam(required = false) List<String> addOnIds,
            RedirectAttributes redirectAttributes) {

        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        int paxCount = parsePositiveIntOrDefault(pax, 1, redirectAttributes);
        if (paxCount < 1) {
            return flightId != null ? "redirect:/flights" : "redirect:/hotels";
        }
        if (flightId != null) {
            try {
                LocalDate flightDateValue = parseOptionalDate(flightDate, redirectAttributes);
                List<Long> parsedAddOns = parseAddOnIds(addOnIds, redirectAttributes);
                if (parsedAddOns == null) {
                    return "redirect:/flights";
                }
                bookingService.createFlightBooking(user, flightId, paxCount, flightDateValue, parsedAddOns);
                redirectAttributes.addFlashAttribute("success", "Flight booking confirmed.");
                return "redirect:/bookings";
            } catch (RuntimeException ex) {
                redirectAttributes.addFlashAttribute("error", ex.getMessage() == null ? "Unable to book flight." : ex.getMessage());
                return "redirect:/flights";
            }
        }

        if (hotelId != null) {
            LocalDate checkIn = parseRequiredDate(checkInDate, redirectAttributes);
            Integer nights = parseRequiredPositiveInt(hotelNights, "nights", redirectAttributes);
            if (checkIn == null || nights == null) {
                redirectAttributes.addFlashAttribute("error", "Please provide check-in date and nights.");
                return "redirect:/hotels";
            }
            LocalDate checkOut = checkIn.plusDays(nights);
            try {
                List<Long> parsedAddOns = parseAddOnIds(addOnIds, redirectAttributes);
                if (parsedAddOns == null) {
                    return "redirect:/hotels";
                }
                bookingService.createHotelBooking(user, hotelId, checkIn, checkOut, paxCount, parsedAddOns);
                redirectAttributes.addFlashAttribute("success", "Hotel booking confirmed.");
                return "redirect:/bookings";
            } catch (RuntimeException ex) {
                redirectAttributes.addFlashAttribute("error", ex.getMessage() == null ? "Unable to book hotel." : ex.getMessage());
                return "redirect:/hotels";
            }
        }

        return "redirect:/bookings";
    }

    @PostMapping("/{id}/cancel")
    public String cancelBooking(@PathVariable("id") Long bookingId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        Booking booking = bookingRepository.findById(bookingId).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return "redirect:/bookings";
        }

        bookingService.cancelBooking(bookingId);
        redirectAttributes.addFlashAttribute("success", "Booking cancelled.");
        return "redirect:/bookings";
    }

    @PostMapping("/{id}/change-date")
    public String changeFlightDate(@PathVariable("id") Long bookingId,
                                   @RequestParam(required = false) String newFlightDate,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        LocalDate newDate = parseRequiredDate(newFlightDate, redirectAttributes);
        if (newDate == null) {
            redirectAttributes.addFlashAttribute("error", "Please select a valid new date.");
            return "redirect:/bookings";
        }
        try {
            bookingService.changeFlightDate(user, bookingId, newDate);
            redirectAttributes.addFlashAttribute("success", "Flight date updated.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage() == null ? "Unable to change flight date." : ex.getMessage());
        }
        return "redirect:/bookings";
    }

    @PostMapping("/{id}/change-hotel-dates")
    public String changeHotelDates(@PathVariable("id") Long bookingId,
                                   @RequestParam(required = false) String newCheckIn,
                                   @RequestParam(required = false) String newCheckOut,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        LocalDate checkIn = parseRequiredDate(newCheckIn, redirectAttributes);
        LocalDate checkOut = parseRequiredDate(newCheckOut, redirectAttributes);
        if (checkIn == null || checkOut == null) {
            redirectAttributes.addFlashAttribute("error", "Please select valid new dates.");
            return "redirect:/bookings";
        }
        try {
            bookingService.changeHotelDates(user, bookingId, checkIn, checkOut);
            redirectAttributes.addFlashAttribute("success", "Hotel dates updated.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage() == null ? "Unable to change hotel dates." : ex.getMessage());
        }
        return "redirect:/bookings";
    }

    @PostMapping("/remove-flight")
    public String removeFlightFromBooking(
            HttpSession session,
            @RequestParam Long bookingId,
            RedirectAttributes redirectAttributes) {

        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("error", "Removing flights from bookings is disabled.");
        return "redirect:/bookings";
    }

    @GetMapping("/remove-flight")
    public String removeFlightFallback() {
        return "redirect:/bookings";
    }

    @PostMapping("/remove-hotel")
    public String removeHotelFromBooking(
            HttpSession session,
            @RequestParam Long bookingId,
            RedirectAttributes redirectAttributes) {

        User user = getSessionUser(session);
        if (user == null) {
            return "redirect:/login";
        }
        redirectAttributes.addFlashAttribute("error", "Removing hotels from bookings is disabled.");
        return "redirect:/bookings";
    }

    @GetMapping("/remove-hotel")
    public String removeHotelFallback() {
        return "redirect:/bookings";
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

    private BigDecimal calculateBasePrice(Booking booking) {
        BigDecimal total = BigDecimal.ZERO;
        if (booking.getFlight() != null && booking.getFlight().getPrice() != null) {
            total = total.add(booking.getFlight().getPrice());
        }
        if (booking.getHotel() != null && booking.getHotel().getPricePerNight() != null
                && booking.getHotelNights() != null) {
            total = total.add(booking.getHotel().getPricePerNight()
                    .multiply(BigDecimal.valueOf(booking.getHotelNights())));
        }
        return total;
    }

    private BigDecimal recalculateTotal(Booking booking) {
        BigDecimal total = calculateBasePrice(booking);
        if (booking.getAddOns() == null) {
            return total;
        }
        for (BookingAddOn addOn : booking.getAddOns()) {
            if (addOn.getUnitPrice() != null && addOn.getQuantity() != null) {
                total = total.add(addOn.getUnitPrice().multiply(BigDecimal.valueOf(addOn.getQuantity())));
            }
        }
        return total;
    }

    private int parsePositiveIntOrDefault(String value, int defaultValue, RedirectAttributes redirectAttributes) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            if (parsed < 1) {
                redirectAttributes.addFlashAttribute("error", "Passengers must be at least 1.");
                return 0;
            }
            return parsed;
        } catch (NumberFormatException ex) {
            redirectAttributes.addFlashAttribute("error", "Invalid passenger count.");
            return 0;
        }
    }

    private Integer parseRequiredPositiveInt(String value, String label, RedirectAttributes redirectAttributes) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            if (parsed < 1) {
                redirectAttributes.addFlashAttribute("error", label + " must be at least 1.");
                return null;
            }
            return parsed;
        } catch (NumberFormatException ex) {
            redirectAttributes.addFlashAttribute("error", "Invalid " + label + " value.");
            return null;
        }
    }

    private LocalDate parseOptionalDate(String value, RedirectAttributes redirectAttributes) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return parseDate(value, redirectAttributes);
    }

    private LocalDate parseRequiredDate(String value, RedirectAttributes redirectAttributes) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return parseDate(value, redirectAttributes);
    }

    private LocalDate parseDate(String value, RedirectAttributes redirectAttributes) {
        String trimmed = value.trim();
        try {
            if (trimmed.contains("/")) {
                return LocalDate.parse(trimmed, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }
            return LocalDate.parse(trimmed);
        } catch (DateTimeParseException ex) {
            redirectAttributes.addFlashAttribute("error", "Invalid date format.");
            return null;
        }
    }

    private List<Long> parseAddOnIds(List<String> values, RedirectAttributes redirectAttributes) {
        List<Long> parsed = new java.util.ArrayList<>();
        if (values == null || values.isEmpty()) {
            return parsed;
        }
        for (String raw : values) {
            if (raw == null || raw.trim().isEmpty()) {
                continue;
            }
            try {
                parsed.add(Long.parseLong(raw.trim()));
            } catch (NumberFormatException ex) {
                redirectAttributes.addFlashAttribute("error", "Invalid add-on selection.");
                return null;
            }
        }
        return parsed;
    }

}
