package com.example.travelapp.dto;

import java.math.BigDecimal;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record HotelSearchRequest(
        @Size(max = 80) String location,
        @Min(1) @Max(5) Integer minStars,
        @DecimalMin("0.0") BigDecimal maxPrice,
        @Pattern(regexp = "^$|priceAsc|priceDesc", message = "must be priceAsc or priceDesc")
        String sort,
        @Min(0) Integer page,
        @Min(1) @Max(50) Integer size
) {
}
