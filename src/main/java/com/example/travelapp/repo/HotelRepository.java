package com.example.travelapp.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import com.example.travelapp.model.Hotel;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, Long>, JpaSpecificationExecutor<Hotel> {

    List<Hotel> findByLocationContainingIgnoreCase(String location);
    List<Hotel> findByLocationContainingIgnoreCaseOrNameContainingIgnoreCase(String location, String name);
}
