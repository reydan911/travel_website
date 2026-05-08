package com.example.travelapp.controller.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.travelapp.dto.FlightResponse;
import com.example.travelapp.dto.FlightSearchRequest;
import com.example.travelapp.dto.PageResponse;
import com.example.travelapp.service.FlightApiService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/flights")
@Validated
public class FlightApiController {

    @Autowired
    private FlightApiService flightApiService;

    @GetMapping
    public List<FlightResponse> listAll() {
        return flightApiService.getAll();
    }

    @GetMapping("/search")
    public PageResponse<FlightResponse> search(@Valid FlightSearchRequest request) {
        return flightApiService.search(request);
    }
}
