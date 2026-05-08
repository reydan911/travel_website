package com.example.travelapp.model;

import java.math.BigDecimal;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Column;
import jakarta.persistence.Table;

@Entity
@Table(name = "booking_add_ons")
public class BookingAddOn {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "add_on_id")
    private AddOn addOn;

    private Integer quantity;

    @Column(name = "unit_price")
    private BigDecimal unitPrice;

    public Long getId() {
        return id;
    }

    public Booking getBooking() {
        return booking;
    }

    public AddOn getAddOn() {
        return addOn;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public BigDecimal getLineTotal() {
        if (unitPrice == null || quantity == null) {
            return null;
        }
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public void setAddOn(AddOn addOn) {
        this.addOn = addOn;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
}
