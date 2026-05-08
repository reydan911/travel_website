package com.example.travelapp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import com.example.travelapp.dto.FlightResponse;
import com.example.travelapp.dto.FlightSearchRequest;
import com.example.travelapp.dto.PageResponse;
import com.example.travelapp.model.Flight;

@Service
public class FlightApiService {

    @Autowired
    private FlightService flightService;

    public List<FlightResponse> getAll() {
        return flightService.searchFlights(null, null, null, null, null)
                .stream()
                .map(FlightResponse::from)
                .toList();
    }

    public PageResponse<FlightResponse> search(FlightSearchRequest request) {
        String origin = trimToNull(request.origin());
        String destination = trimToNull(request.destination());
        Page<Flight> flights = flightService.searchFlightsPage(
                origin,
                destination,
                request.date(),
                request.maxPrice(),
                request.sort(),
                defaultPage(request.page()),
                defaultSize(request.size())
        );
        return PageResponse.map(flights, FlightResponse::from);
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private int defaultPage(Integer page) {
        return page == null ? 0 : page;
    }

    private int defaultSize(Integer size) {
        return size == null ? 10 : size;
    }
}
