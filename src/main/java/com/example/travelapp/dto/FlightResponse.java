package com.example.travelapp.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.example.travelapp.model.Flight;

public record FlightResponse(
        Long id,
        String airline,
        String flightNumber,
        String origin,
        String destination,
        String region,
        LocalDateTime departureTime,
        LocalDateTime arrivalTime,
        BigDecimal price,
        Integer availableSeats,
        String cabinClass
) {
    public static FlightResponse from(Flight flight) {
        if (flight == null) {
            return null;
        }
        return new FlightResponse(
                flight.getId(),
                flight.getAirline(),
                flight.getFlightNumber(),
                flight.getOrigin(),
                flight.getDestination(),
                flight.getRegion(),
                flight.getDepartureTime(),
                flight.getArrivalTime(),
                flight.getPrice(),
                flight.getAvailableSeats(),
                flight.getCabinClass()
        );
    }
}
