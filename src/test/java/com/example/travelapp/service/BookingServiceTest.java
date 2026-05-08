package com.example.travelapp.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.example.travelapp.dto.BookingRequest;
import com.example.travelapp.model.Booking;
import com.example.travelapp.model.BookingStatus;
import com.example.travelapp.model.BookingType;
import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.model.User;
import com.example.travelapp.repo.BookingRepository;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import com.example.travelapp.repo.UserRepository;

@SpringBootTest
@Transactional
class BookingServiceTest {

    @Autowired private BookingService bookingService;
    @Autowired private UserRepository userRepository;
    @Autowired private FlightRepository flightRepository;
    @Autowired private HotelRepository hotelRepository;
    @Autowired private BookingRepository bookingRepository;

    @Test
    void flightBookingReducesSeats() {
        User user = createUser();
        Flight flight = createFlight(10, new BigDecimal("200.00"));

        BookingRequest request = new BookingRequest(
                BookingType.FLIGHT,
                user.getId(),
                flight.getId(),
                null,
                2,
                null,
                null
        );

        Booking booking = bookingService.createBooking(request);
        Flight updated = flightRepository.findById(flight.getId()).orElseThrow();

        assertEquals(8, updated.getAvailableSeats());
        assertEquals(BookingStatus.CONFIRMED, booking.getStatus());
        assertTrue(booking.getTotalPrice().compareTo(new BigDecimal("400.00")) == 0);
    }

    @Test
    void bookingFailsIfInsufficientSeats() {
        User user = createUser();
        Flight flight = createFlight(1, new BigDecimal("150.00"));

        BookingRequest request = new BookingRequest(
                BookingType.FLIGHT,
                user.getId(),
                flight.getId(),
                null,
                2,
                null,
                null
        );

        assertThrows(IllegalArgumentException.class, () -> bookingService.createBooking(request));
    }

    @Test
    void hotelBookingReducesRooms() {
        User user = createUser();
        Hotel hotel = createHotel(3, new BigDecimal("100.00"));

        BookingRequest request = new BookingRequest(
                BookingType.HOTEL,
                user.getId(),
                null,
                hotel.getId(),
                2,
                LocalDate.of(2026, 2, 1),
                LocalDate.of(2026, 2, 3)
        );

        Booking booking = bookingService.createBooking(request);
        Hotel updated = hotelRepository.findById(hotel.getId()).orElseThrow();

        assertEquals(2, updated.getAvailableRooms());
        assertTrue(booking.getTotalPrice().compareTo(new BigDecimal("200.00")) == 0);
    }

    @Test
    void cancelRestoresInventory() {
        User user = createUser();
        Flight flight = createFlight(6, new BigDecimal("180.00"));

        BookingRequest request = new BookingRequest(
                BookingType.FLIGHT,
                user.getId(),
                flight.getId(),
                null,
                2,
                null,
                null
        );

        Booking booking = bookingService.createBooking(request);
        bookingService.cancelBooking(booking.getId());

        Flight updated = flightRepository.findById(flight.getId()).orElseThrow();
        Booking cancelled = bookingRepository.findById(booking.getId()).orElseThrow();

        assertEquals(6, updated.getAvailableSeats());
        assertEquals(BookingStatus.CANCELLED, cancelled.getStatus());
    }

    @Test
    void invalidDatesRejected() {
        User user = createUser();
        Hotel hotel = createHotel(2, new BigDecimal("120.00"));

        BookingRequest request = new BookingRequest(
                BookingType.HOTEL,
                user.getId(),
                null,
                hotel.getId(),
                1,
                LocalDate.of(2026, 2, 3),
                LocalDate.of(2026, 2, 3)
        );

        assertThrows(IllegalArgumentException.class, () -> bookingService.createBooking(request));
    }

    private User createUser() {
        User user = new User();
        user.setUsername("user" + System.nanoTime());
        user.setEmail("user" + System.nanoTime() + "@example.com");
        user.setPasswordHash("hashed");
        user.setVerified(true);
        return userRepository.save(user);
    }

    private Flight createFlight(int seats, BigDecimal price) {
        Flight flight = new Flight();
        flight.setAirline("Test Air");
        flight.setFlightNumber("TA" + System.nanoTime());
        flight.setOrigin("KUL");
        flight.setDestination("TYO");
        flight.setRegion("Asia");
        flight.setPrice(price);
        flight.setAvailableSeats(seats);
        flight.setCabinClass("Economy");
        flight.setDepartureTime(java.time.LocalDateTime.now().plusDays(3));
        flight.setArrivalTime(java.time.LocalDateTime.now().plusDays(3).plusHours(6));
        return flightRepository.save(flight);
    }

    private Hotel createHotel(int rooms, BigDecimal price) {
        Hotel hotel = new Hotel();
        hotel.setName("Test Hotel");
        hotel.setLocation("Kuala Lumpur");
        hotel.setRegion("Asia");
        hotel.setAddress("Test Address");
        hotel.setStars(4);
        hotel.setPricePerNight(price);
        hotel.setAvailableRooms(rooms);
        return hotelRepository.save(hotel);
    }
}
