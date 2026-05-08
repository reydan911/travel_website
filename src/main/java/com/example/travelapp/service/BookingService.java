package com.example.travelapp.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.time.Year;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.travelapp.dto.BookingRequest;
import com.example.travelapp.exception.NotFoundException;
import com.example.travelapp.model.Booking;
import com.example.travelapp.model.BookingStatus;
import com.example.travelapp.model.BookingType;
import com.example.travelapp.model.AddOn;
import com.example.travelapp.model.AddOnScope;
import com.example.travelapp.model.BookingAddOn;
import com.example.travelapp.model.Flight;
import com.example.travelapp.model.Hotel;
import com.example.travelapp.model.User;
import com.example.travelapp.model.UserPreference;
import com.example.travelapp.repo.AddOnRepository;
import com.example.travelapp.repo.BookingRepository;
import com.example.travelapp.repo.FlightRepository;
import com.example.travelapp.repo.HotelRepository;
import com.example.travelapp.repo.UserPreferenceRepository;
import com.example.travelapp.repo.UserRepository;

@Service
public class BookingService {

    @Autowired private BookingRepository bookingRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private FlightRepository flightRepository;
    @Autowired private HotelRepository hotelRepository;
    @Autowired private AddOnRepository addOnRepository;
    @Autowired private UserPreferenceRepository userPreferenceRepository;

    public List<Booking> getBookingsForUser(User user) {
        return bookingRepository.findByUserOrderByBookingDateDesc(user);
    }

    public List<Booking> getBookingsForUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found."));
        return bookingRepository.findByUserIdOrderByBookingDateDesc(user.getId());
    }

    public User getLoggedInUser(Long userId) {
        if (userId == null) return null;
        return userRepository.findById(userId).orElse(null);
    }

    @Transactional
    public Booking createBooking(BookingRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("Booking request is required.");
        }
        User user = userRepository.findById(request.userId())
                .orElseThrow(() -> new NotFoundException("User not found."));

        if (request.pax() == null || request.pax() < 1) {
            throw new IllegalArgumentException("pax must be at least 1.");
        }

        BookingType type = request.type();
        if (type == null) {
            throw new IllegalArgumentException("Booking type is required.");
        }

        if (type == BookingType.FLIGHT) {
            return createFlightBooking(user, request.flightId(), request.pax(), null);
        }
        if (type == BookingType.HOTEL) {
            return createHotelBooking(user, request.hotelId(), request.checkIn(), request.checkOut(), request.pax());
        }
        throw new IllegalArgumentException("Unsupported booking type.");
    }

    @Transactional
    public Booking createFlightBooking(User user, Long flightId, Integer pax, LocalDate flightDateOverride) {
        return createFlightBooking(user, flightId, pax, flightDateOverride, null);
    }

    @Transactional
    public Booking createFlightBooking(User user, Long flightId, Integer pax, LocalDate flightDateOverride, List<Long> addOnIds) {
        if (user == null) {
            throw new IllegalArgumentException("User is required.");
        }
        if (flightId == null) {
            throw new IllegalArgumentException("flightId is required.");
        }
        if (pax == null || pax < 1) {
            throw new IllegalArgumentException("pax must be at least 1.");
        }

        Flight flight = flightRepository.findById(flightId)
                .orElseThrow(() -> new NotFoundException("Flight not found."));

        int seatsLeft = flight.getAvailableSeats() == null ? 0 : flight.getAvailableSeats();
        if (seatsLeft < pax) {
            throw new IllegalArgumentException("Not enough seats available.");
        }
        flight.setAvailableSeats(seatsLeft - pax);
        flightRepository.save(flight);

        BigDecimal basePrice = flight.getPrice();
        if (basePrice == null) {
            throw new IllegalArgumentException("Flight price is unavailable.");
        }

        List<AddOn> selectedAddOns = resolveAddOns(addOnIds);
        if (flightDateOverride != null && !hasFlexChange(selectedAddOns)) {
            throw new IllegalArgumentException("Flexi Change is required to change the flight date.");
        }

        Booking booking = baseBooking(user);
        booking.setFlight(flight);
        booking.setBookingType(BookingType.FLIGHT);
        booking.setPassengerCount(pax);
        LocalDate flightDate = flightDateOverride;
        if (flightDate == null && flight.getDepartureTime() != null) {
            flightDate = flight.getDepartureTime().toLocalDate();
        }
        booking.setFlightDate(flightDate);
        if (flightDateOverride != null && hasFlexChange(selectedAddOns)) {
            booking.setFlexiChangeUsed(true);
        }
        BigDecimal total = basePrice.multiply(BigDecimal.valueOf(pax));
        booking.setTotalPrice(total);

        Booking savedBooking = bookingRepository.save(booking);
        total = total.add(applyFlightAddOns(savedBooking, selectedAddOns));
        savedBooking.setTotalPrice(total);

        Booking finalBooking = bookingRepository.save(savedBooking);
        updatePreferredDestination(user, flight.getDestination());
        return finalBooking;
    }


    @Transactional
    public Booking createHotelBooking(User user, Long hotelId, LocalDate checkIn, LocalDate checkOut, Integer pax) {
        return createHotelBooking(user, hotelId, checkIn, checkOut, pax, null);
    }

    @Transactional
    public Booking createHotelBooking(User user, Long hotelId, LocalDate checkIn, LocalDate checkOut, Integer pax, List<Long> addOnIds) {
        if (user == null) {
            throw new IllegalArgumentException("User is required.");
        }
        if (hotelId == null) {
            throw new IllegalArgumentException("hotelId is required.");
        }
        if (pax == null || pax < 1) {
            throw new IllegalArgumentException("pax must be at least 1.");
        }
        if (checkIn == null || checkOut == null) {
            throw new IllegalArgumentException("checkIn and checkOut are required.");
        }
        if (!checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException("checkOut must be after checkIn.");
        }

        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new NotFoundException("Hotel not found."));

        int nights = Math.toIntExact(ChronoUnit.DAYS.between(checkIn, checkOut));
        if (nights < 1) {
            throw new IllegalArgumentException("Stay must be at least one night.");
        }

        int roomsLeft = hotel.getAvailableRooms() == null ? 0 : hotel.getAvailableRooms();
        if (roomsLeft < 1) {
            throw new IllegalArgumentException("No rooms available.");
        }
        hotel.setAvailableRooms(roomsLeft - 1);
        hotelRepository.save(hotel);

        BigDecimal pricePerNight = hotel.getPricePerNight();
        if (pricePerNight == null) {
            throw new IllegalArgumentException("Hotel price is unavailable.");
        }

        List<AddOn> selectedAddOns = resolveAddOns(addOnIds);

        Booking booking = baseBooking(user);
        booking.setHotel(hotel);
        booking.setBookingType(BookingType.HOTEL);
        booking.setCheckInDate(checkIn);
        booking.setHotelNights(nights);
        booking.setPassengerCount(pax);
        booking.setTotalPrice(pricePerNight.multiply(BigDecimal.valueOf(nights)));

        Booking savedBooking = bookingRepository.save(booking);
        BigDecimal total = savedBooking.getTotalPrice() == null ? BigDecimal.ZERO : savedBooking.getTotalPrice();
        total = total.add(applyHotelAddOns(savedBooking, selectedAddOns));
        savedBooking.setTotalPrice(total);

        Booking finalBooking = bookingRepository.save(savedBooking);
        updatePreferredDestination(user, hotel.getLocation());
        return finalBooking;
    }

    @Transactional
    public Booking cancelBooking(Long bookingId) {
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking id is required.");
        }

        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new NotFoundException("Booking not found."));

        if (booking.getStatus() == BookingStatus.CANCELLED) {
            return booking;
        }
        if (booking.getStatus() != BookingStatus.CONFIRMED) {
            throw new IllegalArgumentException("Only confirmed bookings can be cancelled.");
        }

        BookingType type = booking.getBookingType();
        if (type == BookingType.FLIGHT && booking.getFlight() != null) {
            Flight flight = booking.getFlight();
            int pax = booking.getPassengerCount() == null ? 1 : booking.getPassengerCount();
            int seatsLeft = flight.getAvailableSeats() == null ? 0 : flight.getAvailableSeats();
            flight.setAvailableSeats(seatsLeft + pax);
            flightRepository.save(flight);
        } else if (type == BookingType.HOTEL && booking.getHotel() != null) {
            Hotel hotel = booking.getHotel();
            int roomsLeft = hotel.getAvailableRooms() == null ? 0 : hotel.getAvailableRooms();
            hotel.setAvailableRooms(roomsLeft + 1);
            hotelRepository.save(hotel);
        }

        booking.setStatus(BookingStatus.CANCELLED);
        return bookingRepository.save(booking);
    }

    @Transactional
    public Booking changeFlightDate(User user, Long bookingId, LocalDate newDate) {
        if (user == null) {
            throw new IllegalArgumentException("User is required.");
        }
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking id is required.");
        }
        if (newDate == null) {
            throw new IllegalArgumentException("New flight date is required.");
        }
        if (newDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("New flight date cannot be in the past.");
        }

        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new NotFoundException("Booking not found."));
        if (booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            throw new NotFoundException("Booking not found.");
        }
        if (booking.getBookingType() != BookingType.FLIGHT || booking.getFlight() == null) {
            throw new IllegalArgumentException("Only flight bookings can change dates.");
        }
        if (booking.getStatus() != BookingStatus.CONFIRMED) {
            throw new IllegalArgumentException("Only confirmed bookings can be changed.");
        }
        if (!hasFlexChangeBooking(booking)) {
            throw new IllegalArgumentException("Flexi Change add-on is required to change the flight date.");
        }
        if (booking.isFlexiChangeUsed()) {
            throw new IllegalArgumentException("Flexi Change can only be used once.");
        }
        if (booking.getFlightDate() != null && booking.getFlightDate().equals(newDate)) {
            throw new IllegalArgumentException("New flight date must be different from the current date.");
        }

        booking.setFlightDate(newDate);
        booking.setFlexiChangeUsed(true);
        return bookingRepository.save(booking);
    }

    @Transactional
    public Booking changeHotelDates(User user, Long bookingId, LocalDate newCheckIn, LocalDate newCheckOut) {
        if (user == null) {
            throw new IllegalArgumentException("User is required.");
        }
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking id is required.");
        }
        if (newCheckIn == null || newCheckOut == null) {
            throw new IllegalArgumentException("New check-in and check-out dates are required.");
        }
        if (!newCheckOut.isAfter(newCheckIn)) {
            throw new IllegalArgumentException("Check-out must be after check-in.");
        }
        LocalDate today = LocalDate.now();
        if (newCheckIn.isBefore(today) || newCheckOut.isBefore(today)) {
            throw new IllegalArgumentException("Hotel dates cannot be in the past.");
        }

        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new NotFoundException("Booking not found."));
        if (booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            throw new NotFoundException("Booking not found.");
        }
        if (booking.getBookingType() != BookingType.HOTEL || booking.getHotel() == null) {
            throw new IllegalArgumentException("Only hotel bookings can change dates.");
        }
        if (booking.getStatus() != BookingStatus.CONFIRMED) {
            throw new IllegalArgumentException("Only confirmed bookings can be changed.");
        }
        if (!hasFlexChangeBooking(booking)) {
            throw new IllegalArgumentException("Flexi Change add-on is required to change hotel dates.");
        }
        if (booking.isFlexiChangeUsed()) {
            throw new IllegalArgumentException("Flexi Change can only be used once.");
        }
        if (booking.getCheckInDate() != null && booking.getHotelNights() != null) {
            LocalDate currentCheckIn = booking.getCheckInDate();
            LocalDate currentCheckOut = currentCheckIn.plusDays(booking.getHotelNights());
            if (currentCheckIn.equals(newCheckIn) && currentCheckOut.equals(newCheckOut)) {
                throw new IllegalArgumentException("New hotel dates must be different from the current dates.");
            }
        }

        int nights = Math.toIntExact(ChronoUnit.DAYS.between(newCheckIn, newCheckOut));
        if (nights < 1) {
            throw new IllegalArgumentException("Stay must be at least one night.");
        }
        if (booking.getHotelNights() != null && nights != booking.getHotelNights()) {
            throw new IllegalArgumentException("Flexi Change keeps the same number of nights as your original booking.");
        }

        booking.setCheckInDate(newCheckIn);
        booking.setHotelNights(booking.getHotelNights() != null ? booking.getHotelNights() : nights);
        booking.setFlexiChangeUsed(true);
        return bookingRepository.save(booking);
    }

    private Booking baseBooking(User user) {
        Booking booking = new Booking();
        booking.setUser(user);
        booking.setBookingDate(LocalDateTime.now());
        booking.setStatus(BookingStatus.CONFIRMED);
        booking.setBookingReference(generateBookingReference());
        return booking;
    }


    private BigDecimal applyFlightAddOns(Booking booking, List<AddOn> addOns) {
        if (booking == null || addOns == null || addOns.isEmpty()) {
            return BigDecimal.ZERO;
        }
        String cabinClass = booking.getFlight() != null ? safeLower(booking.getFlight().getCabinClass()) : "";
        int pax = booking.getPassengerCount() == null ? 1 : booking.getPassengerCount();
        BigDecimal total = BigDecimal.ZERO;
        for (AddOn addOn : addOns) {
            if (addOn == null || !addOn.isActive()) {
                continue;
            }
            AddOnScope scope = addOn.getScope();
            if (scope != AddOnScope.FLIGHT && scope != AddOnScope.BOTH) {
                continue;
            }
            if (isPremiumMeal(addOn) && !cabinClass.contains("economy")) {
                throw new IllegalArgumentException("Premium Meal is only available for Economy class.");
            }
            BookingAddOn bookingAddOn = new BookingAddOn();
            int quantity = resolveAddOnQuantity(addOn, pax);
            bookingAddOn.setAddOn(addOn);
            bookingAddOn.setQuantity(quantity);
            bookingAddOn.setUnitPrice(addOn.getPrice());
            booking.addAddOn(bookingAddOn);
            if (addOn.getPrice() != null) {
                total = total.add(addOn.getPrice().multiply(BigDecimal.valueOf(quantity)));
            }
        }
        return total;
    }

    private BigDecimal applyHotelAddOns(Booking booking, List<AddOn> addOns) {
        if (booking == null || addOns == null || addOns.isEmpty()) {
            return BigDecimal.ZERO;
        }
        Hotel hotel = booking.getHotel();
        boolean hasBreakfast = hotelProvidesBreakfast(hotel);
        int pax = booking.getPassengerCount() == null ? 1 : booking.getPassengerCount();
        BigDecimal total = BigDecimal.ZERO;
        for (AddOn addOn : addOns) {
            if (addOn == null || !addOn.isActive() || !isAllowedHotelAddOn(addOn)) {
                continue;
            }
            if (isBreakfastUpgrade(addOn) && hasBreakfast) {
                throw new IllegalArgumentException("Breakfast upgrade is not available because this hotel already provides breakfast.");
            }
            BookingAddOn bookingAddOn = new BookingAddOn();
            int quantity = resolveAddOnQuantity(addOn, pax);
            bookingAddOn.setAddOn(addOn);
            bookingAddOn.setQuantity(quantity);
            bookingAddOn.setUnitPrice(addOn.getPrice());
            booking.addAddOn(bookingAddOn);
            if (addOn.getPrice() != null) {
                total = total.add(addOn.getPrice().multiply(BigDecimal.valueOf(quantity)));
            }
        }
        return total;
    }

    private boolean isPremiumMeal(AddOn addOn) {
        if (addOn == null || addOn.getName() == null) {
            return false;
        }
        return "premium meal".equalsIgnoreCase(addOn.getName().trim());
    }

    private boolean hasFlexChange(List<AddOn> addOns) {
        if (addOns == null) {
            return false;
        }
        for (AddOn addOn : addOns) {
            if (addOn == null || addOn.getName() == null) {
                continue;
            }
            if ("flexi change".equalsIgnoreCase(addOn.getName().trim())) {
                return true;
            }
        }
        return false;
    }

    private boolean hasFlexChangeBooking(Booking booking) {
        if (booking == null || booking.getAddOns() == null || booking.getAddOns().isEmpty()) {
            return false;
        }
        for (BookingAddOn bookingAddOn : booking.getAddOns()) {
            if (bookingAddOn == null) {
                continue;
            }
            AddOn addOn = bookingAddOn.getAddOn();
            if (addOn != null && addOn.getName() != null
                    && "flexi change".equalsIgnoreCase(addOn.getName().trim())) {
                return true;
            }
        }
        return false;
    }

    private boolean isAllowedHotelAddOn(AddOn addOn) {
        if (addOn == null || addOn.getName() == null) {
            return false;
        }
        String name = addOn.getName().trim().toLowerCase();
        return name.equals("room view upgrade") || name.equals("late check-out")
                || name.equals("breakfast upgrade") || name.equals("flexi change");
    }

    private int resolveAddOnQuantity(AddOn addOn, int pax) {
        if (addOn == null || addOn.getName() == null) {
            return 1;
        }
        String name = addOn.getName().trim().toLowerCase();
        if ("flexi change".equals(name)) {
            return 1;
        }
        if (isPerPassengerAddOn(name)) {
            return Math.max(1, pax);
        }
        return 1;
    }

    private boolean isPerPassengerAddOn(String name) {
        if (name == null) return false;
        String n = name.trim().toLowerCase();
        if (n.contains("flexi change")) {
            return false;
        }
        return n.contains("extra baggage")
                || n.contains("travel insurance")
                || n.contains("premium meal")
                || n.contains("priority boarding")
                || n.contains("airport transfer");
    }

    private boolean isBreakfastUpgrade(AddOn addOn) {
        return addOn != null && addOn.getName() != null
                && "breakfast upgrade".equalsIgnoreCase(addOn.getName().trim());
    }

    private boolean hotelProvidesBreakfast(Hotel hotel) {
        if (hotel == null || hotel.getAmenities() == null) {
            return false;
        }
        return hotel.getAmenities().toLowerCase().contains("breakfast");
    }

    private List<AddOn> resolveAddOns(List<Long> addOnIds) {
        if (addOnIds == null || addOnIds.isEmpty()) {
            return java.util.Collections.emptyList();
        }
        return addOnRepository.findAllById(addOnIds);
    }

    private String safeLower(String value) {
        return value == null ? "" : value.trim().toLowerCase();
    }

    private String generateBookingReference() {
        String year = String.valueOf(Year.now().getValue());
        for (int attempt = 0; attempt < 10; attempt++) {
            String suffix = randomAlphaNumeric(5);
            String reference = "TRV-" + year + "-" + suffix;
            if (!bookingRepository.existsByBookingReference(reference)) {
                return reference;
            }
        }
        throw new IllegalStateException("Unable to generate booking reference.");
    }

    private String randomAlphaNumeric(int length) {
        String alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder builder = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int index = ThreadLocalRandom.current().nextInt(alphabet.length());
            builder.append(alphabet.charAt(index));
        }
        return builder.toString();
    }

    private void updatePreferredDestination(User user, String destination) {
        if (user == null || destination == null || destination.trim().isEmpty()) {
            return;
        }
        UserPreference existing = userPreferenceRepository.findByUserId(user.getId());
        UserPreference target = existing == null ? new UserPreference() : existing;
        target.setUserId(user.getId());
        target.setPreferredDestinations(destination.trim());
        userPreferenceRepository.save(target);
    }
}
