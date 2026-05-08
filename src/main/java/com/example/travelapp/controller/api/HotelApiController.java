package com.example.travelapp.controller.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.travelapp.dto.HotelResponse;
import com.example.travelapp.dto.HotelSearchRequest;
import com.example.travelapp.dto.PageResponse;
import com.example.travelapp.service.HotelApiService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/hotels")
@Validated
public class HotelApiController {

    @Autowired
    private HotelApiService hotelApiService;

    @GetMapping
    public List<HotelResponse> listAll() {
        return hotelApiService.getAll();
    }

    @GetMapping("/search")
    public PageResponse<HotelResponse> search(@Valid HotelSearchRequest request) {
        return hotelApiService.search(request);
    }
}
