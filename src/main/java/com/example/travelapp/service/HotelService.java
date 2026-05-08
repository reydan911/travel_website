package com.example.travelapp.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import com.example.travelapp.model.Hotel;
import com.example.travelapp.repo.HotelRepository;

import jakarta.persistence.criteria.Predicate;

@Service
public class HotelService {

    @Autowired private HotelRepository hotelRepository;

    public Hotel getHotelById(Long id) {
        return hotelRepository.findById(id).orElse(null);
    }

    public List<Hotel> searchHotels(String location,
                                    Integer minStars,
                                    BigDecimal maxPrice,
                                    String sort) {
        Sort sortBy = parseSort(sort);
        return hotelRepository.findAll(buildSpec(location, minStars, maxPrice), sortBy);
    }

    public Page<Hotel> searchHotelsPage(String location,
                                        Integer minStars,
                                        BigDecimal maxPrice,
                                        String sort,
                                        int page,
                                        int size) {
        Pageable pageable = PageRequest.of(normalizePage(page), normalizeSize(size), parseSort(sort));
        return hotelRepository.findAll(buildSpec(location, minStars, maxPrice), pageable);
    }

    private Specification<Hotel> buildSpec(String location, Integer minStars, BigDecimal maxPrice) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (!isBlank(location)) {
                Predicate locationPredicate = buildLocationPredicate(cb, root.get("location"), location);
                if (locationPredicate != null) {
                    predicates.add(locationPredicate);
                }
            }
            if (minStars != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("stars"), minStars));
            }
            if (maxPrice != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("pricePerNight"), maxPrice));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    private Sort parseSort(String sort) {
        if (isBlank(sort)) {
            return Sort.unsorted();
        }
        if ("priceAsc".equalsIgnoreCase(sort)) {
            return Sort.by("pricePerNight").ascending();
        }
        if ("priceDesc".equalsIgnoreCase(sort)) {
            return Sort.by("pricePerNight").descending();
        }
        throw new IllegalArgumentException("Invalid sort value. Use priceAsc or priceDesc.");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private int normalizePage(int page) {
        return Math.max(page, 0);
    }

    private int normalizeSize(int size) {
        if (size <= 0) {
            return 10;
        }
        return Math.min(size, 50);
    }

    private Predicate buildLocationPredicate(jakarta.persistence.criteria.CriteriaBuilder cb,
                                             jakarta.persistence.criteria.Path<String> field,
                                             String query) {
        if (query == null || query.trim().isEmpty()) {
            return null;
        }
        String normalized = query.trim().toLowerCase();
        String cleaned = normalized.replaceAll("[^a-z0-9]+", " ").trim();
        if (cleaned.isEmpty()) {
            return cb.like(cb.lower(field), "%" + normalized + "%");
        }
        String[] tokens = cleaned.split("\\s+");
        jakarta.persistence.criteria.Expression<String> fieldLower = cb.lower(field);
        if (tokens.length == 1) {
            String token = tokens[0];
            List<Predicate> parts = new ArrayList<>();
            parts.add(cb.equal(fieldLower, token));
            parts.add(cb.like(fieldLower, token + " %"));
            parts.add(cb.like(fieldLower, token + ",%"));
            parts.add(cb.like(fieldLower, token + "-%"));
            parts.add(cb.like(fieldLower, token + "/%"));
            parts.add(cb.like(fieldLower, token + " (%"));
            parts.add(cb.like(fieldLower, "% " + token));
            parts.add(cb.like(fieldLower, "% " + token + " %"));
            parts.add(cb.like(fieldLower, "% " + token + ",%"));
            parts.add(cb.like(fieldLower, "% " + token + "-%"));
            parts.add(cb.like(fieldLower, "% " + token + "/%"));
            parts.add(cb.like(fieldLower, "% " + token + " (%"));
            return cb.or(parts.toArray(new Predicate[0]));
        }
        String phrase = String.join(" ", tokens);
        List<Predicate> parts = new ArrayList<>();
        parts.add(cb.like(fieldLower, "%" + normalized + "%"));
        if (!phrase.equals(normalized)) {
            parts.add(cb.like(fieldLower, "%" + phrase + "%"));
        }
        return cb.or(parts.toArray(new Predicate[0]));
    }
}
