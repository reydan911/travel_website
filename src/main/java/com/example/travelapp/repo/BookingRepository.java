package com.example.travelapp.repo;

import java.util.List;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.example.travelapp.model.Booking;
import com.example.travelapp.model.User;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    @EntityGraph(attributePaths = {"flight", "hotel", "passengers", "addOns", "addOns.addOn"})
    List<Booking> findByUser(User user);

    @EntityGraph(attributePaths = {"flight", "hotel", "passengers", "addOns", "addOns.addOn"})
    List<Booking> findByUserOrderByBookingDateDesc(User user);

    List<Booking> findByUserId(Long userId);

    @EntityGraph(attributePaths = {"flight", "hotel", "passengers", "addOns", "addOns.addOn"})
    List<Booking> findByUserIdOrderByBookingDateDesc(Long userId);

    boolean existsByBookingReference(String bookingReference);
}
