package com.example.travelapp.dto;

import java.math.BigDecimal;

import com.example.travelapp.model.Hotel;

public record HotelResponse(
        Long id,
        String name,
        String location,
        String region,
        String address,
        Integer stars,
        BigDecimal pricePerNight,
        String description,
        String amenities,
        Integer availableRooms,
        String imageUrl
) {
    public static HotelResponse from(Hotel hotel) {
        if (hotel == null) {
            return null;
        }
        return new HotelResponse(
                hotel.getId(),
                hotel.getName(),
                hotel.getLocation(),
                hotel.getRegion(),
                hotel.getAddress(),
                hotel.getStars(),
                hotel.getPricePerNight(),
                hotel.getDescription(),
                hotel.getAmenities(),
                hotel.getAvailableRooms(),
                hotel.getImageUrl()
        );
    }
}
