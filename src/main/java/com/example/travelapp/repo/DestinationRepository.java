package com.example.travelapp.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.travelapp.model.Destination;

public interface DestinationRepository extends JpaRepository<Destination, Long> {
    Destination findBySlug(String slug);
}
