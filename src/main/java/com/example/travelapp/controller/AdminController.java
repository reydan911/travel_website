package com.example.travelapp.controller;

import com.example.travelapp.model.Booking;
import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.model.User;
import com.example.travelapp.repo.BookingRepository;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import com.example.travelapp.repo.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import com.example.travelapp.model.BookingStatus;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FlightRepository flightRepository;

    @Autowired
    private HotelRepository hotelRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping
    public String adminHome(HttpSession session,
                            Model model,
                            @RequestParam(required = false) String flightSort,
                            @RequestParam(required = false) String hotelSort) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        populateAdminModel(model, flightSort, hotelSort);
        return "admin";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session,
                            Model model,
                            @RequestParam(required = false) String flightSort,
                            @RequestParam(required = false) String hotelSort) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        populateAdminModel(model, flightSort, hotelSort);
        return "admin";
    }

    @GetMapping("/users")
    public String users(HttpSession session,
                        Model model,
                        @RequestParam(required = false) String flightSort,
                        @RequestParam(required = false) String hotelSort) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        populateAdminModel(model, flightSort, hotelSort);
        return "admin";
    }

    @GetMapping("/flights")
    public String flights(HttpSession session,
                          Model model,
                          @RequestParam(required = false) String flightSort,
                          @RequestParam(required = false) String hotelSort) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        populateAdminModel(model, flightSort, hotelSort);
        return "admin";
    }

    @PostMapping("/flights/add")
    public String addFlight(
            @RequestParam String airline,
            @RequestParam String flightNumber,
            @RequestParam String origin,
            @RequestParam String destination,
            @RequestParam String region,
            @RequestParam BigDecimal price,
            @RequestParam Integer availableSeats,
            @RequestParam String departureTime,
            @RequestParam String arrivalTime,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        Flight flight = new Flight();
        flight.setAirline(airline);
        flight.setFlightNumber(flightNumber);
        flight.setOrigin(origin);
        flight.setDestination(destination);
        flight.setRegion(region);
        flight.setPrice(price);
        flight.setAvailableSeats(availableSeats);
        flight.setDepartureTime(parseDateTime(departureTime));
        flight.setArrivalTime(parseDateTime(arrivalTime));

        flightRepository.save(flight);

        return "redirect:/admin";
    }

    @PostMapping("/flights/delete")
    public String deleteFlight(
            @RequestParam Long flightId,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        flightRepository.deleteById(flightId);
        return "redirect:/admin";
    }

    @PostMapping("/flights/update-price")
    public String updateFlightPrice(
            @RequestParam Long flightId,
            @RequestParam BigDecimal price,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        Flight flight = flightRepository.findById(flightId).orElse(null);
        if (flight != null) {
            flight.setPrice(price);
            flightRepository.save(flight);
        }
        return "redirect:/admin";
    }

    @GetMapping("/hotels")
    public String hotels(HttpSession session,
                         Model model,
                         @RequestParam(required = false) String flightSort,
                         @RequestParam(required = false) String hotelSort) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        populateAdminModel(model, flightSort, hotelSort);
        return "admin";
    }

    @PostMapping("/hotels/add")
    public String addHotel(
            @RequestParam String name,
            @RequestParam String location,
            @RequestParam String region,
            @RequestParam String address,
            @RequestParam Integer stars,
            @RequestParam BigDecimal pricePerNight,
            @RequestParam Integer availableRooms,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        Hotel hotel = new Hotel();
        hotel.setName(name);
        hotel.setLocation(location);
        hotel.setRegion(region);
        hotel.setAddress(address);
        hotel.setStars(stars);
        hotel.setPricePerNight(pricePerNight);
        hotel.setAvailableRooms(availableRooms);

        hotelRepository.save(hotel);

        return "redirect:/admin";
    }

    @PostMapping("/hotels/delete")
    public String deleteHotel(
            @RequestParam Long hotelId,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        hotelRepository.deleteById(hotelId);
        return "redirect:/admin";
    }

    @PostMapping("/hotels/update-price")
    public String updateHotelPrice(
            @RequestParam Long hotelId,
            @RequestParam BigDecimal pricePerNight,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        Hotel hotel = hotelRepository.findById(hotelId).orElse(null);
        if (hotel != null) {
            hotel.setPricePerNight(pricePerNight);
            hotelRepository.save(hotel);
        }
        return "redirect:/admin";
    }

    @GetMapping("/bookings")
    public String bookings(HttpSession session,
                           Model model,
                           @RequestParam(required = false) String flightSort,
                           @RequestParam(required = false) String hotelSort) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        populateAdminModel(model, flightSort, hotelSort);
        return "admin";
    }

    @PostMapping("/bookings/remove-cancelled")
    public String removeCancelledBooking(
            @RequestParam Long bookingId,
            HttpSession session) {

        if (!isAdmin(session)) {
            return "redirect:/";
        }

        Booking booking = bookingRepository.findById(bookingId).orElse(null);
        if (booking != null && booking.getStatus() == BookingStatus.CANCELLED) {
            bookingRepository.delete(booking);
        }

        return "redirect:/admin";
    }

    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("role");
        return role != null && role.equals("ADMIN");
    }

    private void populateAdminModel(Model model, String flightSort, String hotelSort) {
        long userCount = userRepository.count();
        long flightCount = flightRepository.count();
        long hotelCount = hotelRepository.count();
        long bookingCount = bookingRepository.count();

        model.addAttribute("userCount", userCount);
        model.addAttribute("flightCount", flightCount);
        model.addAttribute("hotelCount", hotelCount);
        model.addAttribute("bookingCount", bookingCount);

        List<User> users = userRepository.findAll();
        List<Flight> flights = flightRepository.findAll(parseFlightSort(flightSort));
        List<Hotel> hotels = hotelRepository.findAll(parseHotelSort(hotelSort));
        List<Booking> bookings = bookingRepository.findAll();

        model.addAttribute("users", users);
        model.addAttribute("flights", flights);
        model.addAttribute("hotels", hotels);
        model.addAttribute("bookings", bookings);
        model.addAttribute("flightSort", flightSort == null ? "" : flightSort);
        model.addAttribute("hotelSort", hotelSort == null ? "" : hotelSort);
    }

    private org.springframework.data.domain.Sort parseFlightSort(String sortKey) {
        if (sortKey == null || sortKey.trim().isEmpty()) {
            return org.springframework.data.domain.Sort.unsorted();
        }
        return switch (sortKey) {
            case "newest" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "id");
            case "oldest" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC, "id");
            case "priceHigh" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "price");
            case "priceLow" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC, "price");
            default -> org.springframework.data.domain.Sort.unsorted();
        };
    }

    private org.springframework.data.domain.Sort parseHotelSort(String sortKey) {
        if (sortKey == null || sortKey.trim().isEmpty()) {
            return org.springframework.data.domain.Sort.unsorted();
        }
        return switch (sortKey) {
            case "newest" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "id");
            case "oldest" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC, "id");
            case "priceHigh" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "pricePerNight");
            case "priceLow" -> org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.ASC, "pricePerNight");
            default -> org.springframework.data.domain.Sort.unsorted();
        };
    }

    private LocalDateTime parseDateTime(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return LocalDateTime.parse(value.trim());
    }
}
