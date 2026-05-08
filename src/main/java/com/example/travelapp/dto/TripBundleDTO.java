package com.example.travelapp.dto;

import java.math.BigDecimal;
import java.util.List;

import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;

public class TripBundleDTO {
    private final Flight flight;
    private final Hotel hotel;
    private final BigDecimal totalCost;
    private final List<String> reasons;

    public TripBundleDTO(Flight flight, Hotel hotel, BigDecimal totalCost, List<String> reasons) {
        this.flight = flight;
        this.hotel = hotel;
        this.totalCost = totalCost;
        this.reasons = reasons;
    }

    public Flight getFlight() { return flight; }
    public Hotel getHotel() { return hotel; }
    public BigDecimal getTotalCost() { return totalCost; }
    public List<String> getReasons() { return reasons; }
}
