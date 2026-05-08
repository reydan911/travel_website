package com.example.travelapp.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import com.example.travelapp.model.Booking;
import com.example.travelapp.model.BookingStatus;
import com.example.travelapp.model.BookingType;

public record BookingResponse(
        Long id,
        Long userId,
        BookingType type,
        BookingStatus status,
        String bookingReference,
        LocalDateTime createdAt,
        Long flightId,
        Long hotelId,
        LocalDate flightDate,
        LocalDate checkIn,
        LocalDate checkOut,
        Integer nights,
        Integer pax,
        BigDecimal totalPrice
) {
    public static BookingResponse from(Booking booking) {
        if (booking == null) {
            return null;
        }
        LocalDate checkOutDate = null;
        if (booking.getCheckInDate() != null && booking.getHotelNights() != null) {
            checkOutDate = booking.getCheckInDate().plusDays(booking.getHotelNights());
        }
        return new BookingResponse(
                booking.getId(),
                booking.getUser() == null ? null : booking.getUser().getId(),
                booking.getBookingType(),
                booking.getStatus(),
                booking.getBookingReference(),
                booking.getBookingDate(),
                booking.getFlight() == null ? null : booking.getFlight().getId(),
                booking.getHotel() == null ? null : booking.getHotel().getId(),
                booking.getFlightDate(),
                booking.getCheckInDate(),
                checkOutDate,
                booking.getHotelNights(),
                booking.getPassengerCount(),
                booking.getTotalPrice()
        );
    }
}
