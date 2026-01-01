package com.example.travelapp.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.travelapp.model.Booking;
import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.model.User;
import com.example.travelapp.model.UserPreference;
import com.example.travelapp.repo.BookingRepository;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import com.example.travelapp.repo.UserPreferenceRepository;
import com.example.travelapp.repo.UserRepository;
import com.example.travelapp.service.DeepSeekService;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {

    @Autowired
    private FlightRepository flightRepository;

    @Autowired
    private HotelRepository hotelRepository;

    @Autowired
    private UserPreferenceRepository userPreferenceRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DeepSeekService deepSeekService;

    @Autowired
    private BookingRepository bookingRepository;

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
    public String flights(Model model) {
        List<Flight> flights = flightRepository.findAll();
        model.addAttribute("flights", flights);
        return "flights";
    }

    @GetMapping("/hotels")
    public String hotels(Model model) {
        List<Hotel> hotels = hotelRepository.findAll();
        model.addAttribute("hotels", hotels);
        return "hotels";
    }

    @GetMapping("/search-flights")
    public String searchFlights(
            @RequestParam(required = false) String origin,
            @RequestParam(required = false) String destination,
            Model model) {
        
        List<Flight> flights;
        if (origin != null && destination != null) {
            flights = flightRepository.findByOriginAndDestination(origin, destination);
        } else {
            flights = flightRepository.findAll();
        }
        
        model.addAttribute("flights", flights);
        return "flights";
    }

    @GetMapping("/search-hotels")
    public String searchHotels(
            @RequestParam(required = false) String location,
            Model model) {
        
        List<Hotel> hotels;
        if (location != null) {
            hotels = hotelRepository.findByLocation(location);
        } else {
            hotels = hotelRepository.findAll();
        }
        
        model.addAttribute("hotels", hotels);
        return "hotels";
    }

    @GetMapping("/recommendations")
    public String recommendations(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        UserPreference preference = userPreferenceRepository.findByUserId(userId);
        
        if (preference != null) {
            String prompt = "Based on user preferences: " + 
                        "Destinations: " + preference.getPreferredDestinations() + 
                        ", Budget: " + preference.getBudgetRange() + 
                        ", Style: " + preference.getTravelStyle() + 
                        ". Provide 3 travel recommendations.";
            
            String recommendations = deepSeekService.generateRecommendations(prompt);
            model.addAttribute("recommendations", recommendations);
        }
        
        return "recommendations";
    }

    @PostMapping("/save-preferences")
    public String savePreferences(
            @RequestParam String preferredDestinations,
            @RequestParam String budgetRange,
            @RequestParam String travelStyle,
            HttpSession session) {
        
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }

        UserPreference preference = userPreferenceRepository.findByUserId(userId);
        
        if (preference == null) {
            preference = new UserPreference();
            preference.setUserId(userId);
        }
        
        preference.setPreferredDestinations(preferredDestinations);
        preference.setBudgetRange(budgetRange);
        preference.setTravelStyle(travelStyle);
        
        userPreferenceRepository.save(preference);
        
        return "redirect:/recommendations";
    }

    // ===== BOOKING METHODS =====

    @GetMapping("/book-flight/{id}")
    public String bookFlight(@PathVariable Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }
        
        Flight flight = flightRepository.findById(id).orElse(null);
        
        if (flight == null) {
            model.addAttribute("error", "Flight not found");
            return "flights";
        }
        
        model.addAttribute("flight", flight);
        model.addAttribute("bookingType", "FLIGHT");
        return "booking-form";
    }

    @GetMapping("/book-hotel/{id}")
    public String bookHotel(@PathVariable Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }
        
        Hotel hotel = hotelRepository.findById(id).orElse(null);
        
        if (hotel == null) {
            model.addAttribute("error", "Hotel not found");
            return "hotels";
        }
        
        model.addAttribute("hotel", hotel);
        model.addAttribute("bookingType", "HOTEL");
        return "booking-form";
    }

    @PostMapping("/confirm-booking")
    public String confirmBooking(
            @RequestParam String bookingType,
            @RequestParam Long referenceId,
            @RequestParam(required = false) String passengerDetails,
            @RequestParam(required = false) Integer nights,
            HttpSession session,
            Model model) {
        
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }
        
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setBookingType(bookingType);
        booking.setReferenceId(referenceId);
        booking.setBookingDate(LocalDateTime.now());
        booking.setStatus("CONFIRMED");
        booking.setPassengerDetails(passengerDetails);
        
        // Calculate price
        BigDecimal totalPrice = BigDecimal.ZERO;
        if ("FLIGHT".equals(bookingType)) {
            Flight flight = flightRepository.findById(referenceId).orElse(null);
            if (flight != null) {
                totalPrice = flight.getPrice();
            }
        } else if ("HOTEL".equals(bookingType)) {
            Hotel hotel = hotelRepository.findById(referenceId).orElse(null);
            if (hotel != null && nights != null) {
                totalPrice = hotel.getPricePerNight().multiply(BigDecimal.valueOf(nights));
            }
        }
        
        booking.setTotalPrice(totalPrice);
        bookingRepository.save(booking);
        
        model.addAttribute("message", "Booking confirmed successfully!");
        model.addAttribute("booking", booking);
        return "booking-success";
    }

    @GetMapping("/my-bookings")
    public String myBookings(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        
        if (userId == null) {
            return "redirect:/login";
        }
        
        List<Booking> bookings = bookingRepository.findByUserId(userId);
        model.addAttribute("bookings", bookings);
        return "my-bookings";
    }
}