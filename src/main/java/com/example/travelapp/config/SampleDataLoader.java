package com.example.travelapp.config;

import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Component
public class SampleDataLoader implements CommandLineRunner {

    @Autowired
    private FlightRepository flightRepository;

    @Autowired
    private HotelRepository hotelRepository;

    @Override
    public void run(String... args) {
        if (flightRepository.count() == 0) {
            loadFlights();
        }
        if (hotelRepository.count() == 0) {
            loadHotels();
        }
    }

    private void loadFlights() {
        Flight f1 = new Flight();
        f1.setAirline("Malaysia Airlines");
        f1.setFlightNumber("MH001");
        f1.setOrigin("Kuala Lumpur");
        f1.setDestination("Singapore");
        f1.setPrice(new BigDecimal("250.00"));
        f1.setAvailableSeats(150);
        f1.setDepartureTime(LocalDateTime.now().plusDays(5));
        f1.setArrivalTime(LocalDateTime.now().plusDays(5).plusHours(1));

        Flight f2 = new Flight();
        f2.setAirline("AirAsia");
        f2.setFlightNumber("AK200");
        f2.setOrigin("Kuala Lumpur");
        f2.setDestination("Bangkok");
        f2.setPrice(new BigDecimal("180.00"));
        f2.setAvailableSeats(180);
        f2.setDepartureTime(LocalDateTime.now().plusDays(7));
        f2.setArrivalTime(LocalDateTime.now().plusDays(7).plusHours(2));

        Flight f3 = new Flight();
        f3.setAirline("Singapore Airlines");
        f3.setFlightNumber("SQ300");
        f3.setOrigin("Singapore");
        f3.setDestination("Tokyo");
        f3.setPrice(new BigDecimal("650.00"));
        f3.setAvailableSeats(200);
        f3.setDepartureTime(LocalDateTime.now().plusDays(10));
        f3.setArrivalTime(LocalDateTime.now().plusDays(10).plusHours(7));

        Flight f4 = new Flight();
        f4.setAirline("Cathay Pacific");
        f4.setFlightNumber("CX400");
        f4.setOrigin("Hong Kong");
        f4.setDestination("London");
        f4.setPrice(new BigDecimal("1200.00"));
        f4.setAvailableSeats(250);
        f4.setDepartureTime(LocalDateTime.now().plusDays(15));
        f4.setArrivalTime(LocalDateTime.now().plusDays(15).plusHours(13));

        Flight f5 = new Flight();
        f5.setAirline("Emirates");
        f5.setFlightNumber("EK500");
        f5.setOrigin("Dubai");
        f5.setDestination("New York");
        f5.setPrice(new BigDecimal("1500.00"));
        f5.setAvailableSeats(300);
        f5.setDepartureTime(LocalDateTime.now().plusDays(20));
        f5.setArrivalTime(LocalDateTime.now().plusDays(20).plusHours(14));

        flightRepository.save(f1);
        flightRepository.save(f2);
        flightRepository.save(f3);
        flightRepository.save(f4);
        flightRepository.save(f5);

        System.out.println("Sample flights loaded!");
    }

    private void loadHotels() {
        Hotel h1 = new Hotel();
        h1.setName("Grand Hyatt Kuala Lumpur");
        h1.setLocation("Kuala Lumpur");
        h1.setAddress("12 Jalan Pinang");
        h1.setStars(5);
        h1.setPricePerNight(new BigDecimal("250.00"));
        h1.setAvailableRooms(100);

        Hotel h2 = new Hotel();
        h2.setName("Mandarin Oriental");
        h2.setLocation("Singapore");
        h2.setAddress("5 Raffles Avenue");
        h2.setStars(5);
        h2.setPricePerNight(new BigDecimal("400.00"));
        h2.setAvailableRooms(80);

        Hotel h3 = new Hotel();
        h3.setName("Shangri-La Hotel Bangkok");
        h3.setLocation("Bangkok");
        h3.setAddress("89 Soi Wat Suan Plu");
        h3.setStars(5);
        h3.setPricePerNight(new BigDecimal("200.00"));
        h3.setAvailableRooms(120);

        Hotel h4 = new Hotel();
        h4.setName("The Peninsula Tokyo");
        h4.setLocation("Tokyo");
        h4.setAddress("1-8-1 Yurakucho");
        h4.setStars(5);
        h4.setPricePerNight(new BigDecimal("500.00"));
        h4.setAvailableRooms(90);

        Hotel h5 = new Hotel();
        h5.setName("The Ritz-Carlton Hong Kong");
        h5.setLocation("Hong Kong");
        h5.setAddress("1 Austin Road West");
        h5.setStars(5);
        h5.setPricePerNight(new BigDecimal("450.00"));
        h5.setAvailableRooms(70);

        hotelRepository.save(h1);
        hotelRepository.save(h2);
        hotelRepository.save(h3);
        hotelRepository.save(h4);
        hotelRepository.save(h5);

        System.out.println("Sample hotels loaded!");
    }
}