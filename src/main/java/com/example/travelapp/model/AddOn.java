package com.example.travelapp.model;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "add_ons")
public class AddOn {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(length = 500)
    private String description;

    private BigDecimal price;

    @Enumerated(EnumType.STRING)
    private AddOnCategory category;

    @Enumerated(EnumType.STRING)
    private AddOnScope scope;

    private boolean active = true;

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public AddOnCategory getCategory() {
        return category;
    }

    public AddOnScope getScope() {
        return scope;
    }

    public boolean isActive() {
        return active;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public void setCategory(AddOnCategory category) {
        this.category = category;
    }

    public void setScope(AddOnScope scope) {
        this.scope = scope;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
