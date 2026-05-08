package com.example.travelapp.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.travelapp.model.AddOn;

public interface AddOnRepository extends JpaRepository<AddOn, Long> {
    List<AddOn> findByActiveTrueOrderByCategoryAscNameAsc();
}
