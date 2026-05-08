package com.example.travelapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "destination_highlights")
public class DestinationHighlight {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "destination_id")
    private Destination destination;

    @Column(name = "highlight", length = 255)
    private String text;

    @Column(name = "sort_order")
    private Integer sortOrder;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Destination getDestination() { return destination; }
    public void setDestination(Destination destination) { this.destination = destination; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }
}
