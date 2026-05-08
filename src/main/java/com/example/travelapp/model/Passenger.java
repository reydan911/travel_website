package com.example.travelapp.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "passengers")
public class Passenger {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    private Booking booking;

    private String fullName;
    private String gender;
    private LocalDate dateOfBirth;
    private String nationality;
    private String idNumber;

    @Enumerated(EnumType.STRING)
    private PassengerType passengerType;

    public Long getId() {
        return id;
    }

    public Booking getBooking() {
        return booking;
    }

    public String getFullName() {
        return fullName;
    }

    public String getGender() {
        return gender;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public String getNationality() {
        return nationality;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public PassengerType getPassengerType() {
        return passengerType;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public void setPassengerType(PassengerType passengerType) {
        this.passengerType = passengerType;
    }
}
