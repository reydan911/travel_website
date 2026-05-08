package com.example.travelapp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import com.example.travelapp.dto.HotelResponse;
import com.example.travelapp.dto.HotelSearchRequest;
import com.example.travelapp.dto.PageResponse;
import com.example.travelapp.model.Hotel;

@Service
public class HotelApiService {

    @Autowired
    private HotelService hotelService;

    public List<HotelResponse> getAll() {
        return hotelService.searchHotels(null, null, null, null)
                .stream()
                .map(HotelResponse::from)
                .toList();
    }

    public PageResponse<HotelResponse> search(HotelSearchRequest request) {
        String location = trimToNull(request.location());
        Page<Hotel> hotels = hotelService.searchHotelsPage(
                location,
                request.minStars(),
                request.maxPrice(),
                request.sort(),
                defaultPage(request.page()),
                defaultSize(request.size())
        );
        return PageResponse.map(hotels, HotelResponse::from);
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
