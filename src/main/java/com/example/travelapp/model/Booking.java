package com.example.travelapp.model;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "booking")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private Flight flight;

    @ManyToOne
    private Hotel hotel;

    @Enumerated(EnumType.STRING)
    private BookingType bookingType;

    @Enumerated(EnumType.STRING)
    private BookingStatus status;

    @Column(name = "booking_reference", unique = true)
    private String bookingReference;

    private LocalDateTime bookingDate;
    private LocalDate flightDate;
    private LocalDate checkInDate;
    private Integer hotelNights;
    private Integer passengerCount;
    private BigDecimal totalPrice;
    private String contactName;
    private String contactEmail;
    private String contactPhone;
    @Column(name = "flexi_change_used")
    private Boolean flexiChangeUsed;

    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Passenger> passengers = new LinkedHashSet<>();

    @OneToMany(mappedBy = "booking", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<BookingAddOn> addOns = new LinkedHashSet<>();

    public Long getId() { return id; }
    public User getUser() { return user; }
    public Flight getFlight() { return flight; }
    public Hotel getHotel() { return hotel; }
    public BookingType getBookingType() { return bookingType; }
    public BookingStatus getStatus() { return status; }
    public String getBookingReference() { return bookingReference; }
    public LocalDateTime getBookingDate() { return bookingDate; }
    public LocalDate getFlightDate() { return flightDate; }
    public LocalDate getCheckInDate() { return checkInDate; }
    public Integer getHotelNights() { return hotelNights; }
    public Integer getPassengerCount() { return passengerCount; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public String getContactName() { return contactName; }
    public String getContactEmail() { return contactEmail; }
    public String getContactPhone() { return contactPhone; }
    public boolean isFlexiChangeUsed() { return flexiChangeUsed != null && flexiChangeUsed; }
    public Set<Passenger> getPassengers() { return passengers; }
    public Set<BookingAddOn> getAddOns() { return addOns; }

    public void setUser(User user) { this.user = user; }
    public void setFlight(Flight flight) { this.flight = flight; }
    public void setHotel(Hotel hotel) { this.hotel = hotel; }
    public void setBookingType(BookingType bookingType) { this.bookingType = bookingType; }
    public void setStatus(BookingStatus status) { this.status = status; }
    public void setBookingReference(String bookingReference) { this.bookingReference = bookingReference; }
    public void setBookingDate(LocalDateTime bookingDate) { this.bookingDate = bookingDate; }
    public void setFlightDate(LocalDate flightDate) { this.flightDate = flightDate; }
    public void setCheckInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; }
    public void setHotelNights(Integer hotelNights) { this.hotelNights = hotelNights; }
    public void setPassengerCount(Integer passengerCount) { this.passengerCount = passengerCount; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public void setFlexiChangeUsed(boolean flexiChangeUsed) { this.flexiChangeUsed = flexiChangeUsed; }
    public void setPassengers(Set<Passenger> passengers) { this.passengers = passengers; }
    public void setAddOns(Set<BookingAddOn> addOns) { this.addOns = addOns; }

    @Transient
    public LocalDateTime getEffectiveDepartureTime() {
        if (flight == null || flight.getDepartureTime() == null) {
            return null;
        }
        if (flightDate == null) {
            return flight.getDepartureTime();
        }
        return LocalDateTime.of(flightDate, flight.getDepartureTime().toLocalTime());
    }

    @Transient
    public LocalDateTime getEffectiveArrivalTime() {
        if (flight == null || flight.getArrivalTime() == null) {
            return null;
        }
        if (flightDate == null) {
            return flight.getArrivalTime();
        }
        LocalDateTime originalDeparture = flight.getDepartureTime();
        LocalDateTime originalArrival = flight.getArrivalTime();
        if (originalDeparture != null) {
            Duration duration = Duration.between(originalDeparture, originalArrival);
            LocalDateTime effectiveDeparture = getEffectiveDepartureTime();
            if (effectiveDeparture != null) {
                return effectiveDeparture.plus(duration);
            }
        }
        return LocalDateTime.of(flightDate, originalArrival.toLocalTime());
    }

    public void addPassenger(Passenger passenger) {
        passengers.add(passenger);
        passenger.setBooking(this);
    }

    public void addAddOn(BookingAddOn addOn) {
        addOns.add(addOn);
        addOn.setBooking(this);
    }
}
