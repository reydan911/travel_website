package com.example.travelapp.controller.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.travelapp.dto.BookingRequest;
import com.example.travelapp.dto.BookingResponse;
import com.example.travelapp.service.BookingService;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;

@RestController
@RequestMapping("/api/bookings")
@Validated
public class BookingApiController {

    @Autowired
    private BookingService bookingService;

    @PostMapping
    public BookingResponse create(@Valid @RequestBody BookingRequest request) {
        return BookingResponse.from(bookingService.createBooking(request));
    }

    @GetMapping
    public List<BookingResponse> list(@RequestParam @Positive Long userId) {
        return bookingService.getBookingsForUserId(userId).stream()
                .map(BookingResponse::from)
                .toList();
    }

    @PostMapping("/{id}/cancel")
    public BookingResponse cancel(@PathVariable("id") @Positive Long bookingId) {
        return BookingResponse.from(bookingService.cancelBooking(bookingId));
    }
}
