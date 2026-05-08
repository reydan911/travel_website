package com.example.travelapp.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record FlightSearchRequest(
        @Size(max = 80) String origin,
        @Size(max = 80) String destination,
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
        @DecimalMin("0.0") BigDecimal maxPrice,
        @Pattern(regexp = "^$|priceAsc|priceDesc", message = "must be priceAsc or priceDesc")
        String sort,
        @Min(0) Integer page,
        @Min(1) @Max(50) Integer size
) {
}
