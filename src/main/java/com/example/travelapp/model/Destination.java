package com.example.travelapp.model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;

@Entity
@Table(name = "destinations")
public class Destination {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String slug;

    private String name;
    private String subtitle;

    @Column(name = "image_url", length = 1000)
    private String imageUrl;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "map_embed_url", columnDefinition = "TEXT")
    private String mapEmbedUrl;

    @OneToMany(mappedBy = "destination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    @OrderBy("sortOrder ASC")
    private List<DestinationHighlight> highlights = new ArrayList<>();

    @OneToMany(mappedBy = "destination", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    @OrderBy("sortOrder ASC")
    private List<DestinationActivity> activities = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getMapEmbedUrl() { return mapEmbedUrl; }
    public void setMapEmbedUrl(String mapEmbedUrl) { this.mapEmbedUrl = mapEmbedUrl; }

    public List<DestinationHighlight> getHighlights() { return highlights; }
    public void setHighlights(List<DestinationHighlight> highlights) { this.highlights = highlights; }

    public List<DestinationActivity> getActivities() { return activities; }
    public void setActivities(List<DestinationActivity> activities) { this.activities = activities; }
}
