package com.example.travelapp.controller.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.travelapp.model.Destination;
import com.example.travelapp.repo.DestinationRepository;

@RestController
@RequestMapping("/api/destinations")
public class DestinationApiController {

    @Autowired
    private DestinationRepository destinationRepository;

    @GetMapping
    public List<DestinationCard> list(@RequestParam(defaultValue = "6") int limit) {
        int safeLimit = clampLimit(limit);
        return destinationRepository.findAll(PageRequest.of(0, safeLimit, Sort.by("id").ascending()))
                .getContent()
                .stream()
                .map(DestinationCard::from)
                .toList();
    }

    private static int clampLimit(int limit) {
        if (limit < 1) {
            return 1;
        }
        return Math.min(limit, 12);
    }

    public record DestinationCard(Long id, String slug, String name, String subtitle, String imageUrl) {
        static DestinationCard from(Destination destination) {
            return new DestinationCard(
                    destination.getId(),
                    destination.getSlug(),
                    destination.getName(),
                    destination.getSubtitle(),
                    destination.getImageUrl()
            );
        }
    }
}
