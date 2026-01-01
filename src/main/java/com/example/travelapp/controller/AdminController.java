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

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        long userCount = userRepository.count();
        long flightCount = flightRepository.count();
        long hotelCount = hotelRepository.count();
        long bookingCount = bookingRepository.count();

        model.addAttribute("userCount", userCount);
        model.addAttribute("flightCount", flightCount);
        model.addAttribute("hotelCount", hotelCount);
        model.addAttribute("bookingCount", bookingCount);

        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String users(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("/flights")
    public String flights(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        List<Flight> flights = flightRepository.findAll();
        model.addAttribute("flights", flights);
        return "admin/flights";
    }

    @PostMapping("/flights/add")
    public String addFlight(
            @RequestParam String airline,
            @RequestParam String flightNumber,
            @RequestParam String origin,
            @RequestParam String destination,
            @RequestParam BigDecimal price,
            @RequestParam Integer availableSeats,
            HttpSession session) {

        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        Flight flight = new Flight();
        flight.setAirline(airline);
        flight.setFlightNumber(flightNumber);
        flight.setOrigin(origin);
        flight.setDestination(destination);
        flight.setPrice(price);
        flight.setAvailableSeats(availableSeats);
        flight.setDepartureTime(LocalDateTime.now().plusDays(7));
        flight.setArrivalTime(LocalDateTime.now().plusDays(7).plusHours(3));

        flightRepository.save(flight);

        return "redirect:/admin/flights";
    }

    @GetMapping("/hotels")
    public String hotels(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        List<Hotel> hotels = hotelRepository.findAll();
        model.addAttribute("hotels", hotels);
        return "admin/hotels";
    }

    @PostMapping("/hotels/add")
    public String addHotel(
            @RequestParam String name,
            @RequestParam String location,
            @RequestParam String address,
            @RequestParam Integer stars,
            @RequestParam BigDecimal pricePerNight,
            @RequestParam Integer availableRooms,
            HttpSession session) {

        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        Hotel hotel = new Hotel();
        hotel.setName(name);
        hotel.setLocation(location);
        hotel.setAddress(address);
        hotel.setStars(stars);
        hotel.setPricePerNight(pricePerNight);
        hotel.setAvailableRooms(availableRooms);

        hotelRepository.save(hotel);

        return "redirect:/admin/hotels";
    }

    @GetMapping("/bookings")
    public String bookings(HttpSession session, Model model) {
        String role = (String) session.getAttribute("role");
        
        if (role == null || !role.equals("ADMIN")) {
            return "redirect:/";
        }

        List<Booking> bookings = bookingRepository.findAll();
        model.addAttribute("bookings", bookings);
        return "admin/bookings";
    }
}