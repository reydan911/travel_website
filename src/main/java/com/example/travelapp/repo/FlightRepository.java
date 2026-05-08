package com.example.travelapp.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.example.travelapp.model.Flight;

public interface FlightRepository extends JpaRepository<Flight, Long>, JpaSpecificationExecutor<Flight> {
    List<Flight> findByOriginContainingIgnoreCaseAndDestinationContainingIgnoreCase(String origin, String destination);
    List<Flight> findByOriginContainingIgnoreCase(String origin);
    List<Flight> findByDestinationContainingIgnoreCase(String destination);
}
