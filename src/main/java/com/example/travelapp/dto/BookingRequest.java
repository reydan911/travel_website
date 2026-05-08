package com.example.travelapp.dto;

import java.time.LocalDate;

import com.example.travelapp.model.BookingType;
import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record BookingRequest(
        @NotNull BookingType type,
        @NotNull @Positive Long userId,
        @Positive Long flightId,
        @Positive Long hotelId,
        @NotNull @Min(1) Integer pax,
        @JsonFormat(pattern = "yyyy-MM-dd") LocalDate checkIn,
        @JsonFormat(pattern = "yyyy-MM-dd") LocalDate checkOut
) {
}
