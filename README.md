# Travel Website (Spring Boot + Thymeleaf + MySQL)

University FYP project for a travel booking platform with flights, hotels, bookings, and AI-style recommendations.

## Features implemented
- Search + filters + sorting for flights/hotels (with pagination).
- Booking system for flights/hotels with inventory updates and status lifecycle.
- Booking reference format `TRV-YYYY-XXXXX` (unique).
- Destination pages with hero images, highlights, activities, and maps.
- AI Suggestions page (DB-driven matching + optional AI summary).
- Admin panel for managing flights, hotels, users, and bookings.
- REST API endpoints for demo/testing.

## AI recommendations (how it works)
- Core matching is deterministic and DB-driven (region, budget, style, interests, availability).
- Hotels are matched to the chosen destination (city anchor).
- Optional Groq AI is used only to generate a short explanation summary.
- Preferences are saved when the AI Suggestions form is submitted and also updated
  after a flight or hotel booking (preferred destination = booked city).

## How to run
1) Make sure MySQL is running and the database exists.
2) Update `src/main/resources/application.properties` with your MySQL credentials.
3) (Optional) Set your Groq API key as an environment variable:

```bash
set GROQ_API_KEY=your_key_here
```

4) Run:

```bash
mvn spring-boot:run
```

App starts on `http://localhost:8080`.

## Diagrams
- System overview: `SYSTEM_OVERVIEW.txt`
- Database ERD (PlantUML): `SYSTEM_DATABASE_ERD.puml`
- Booking sequence (PlantUML): `SYSTEM_SEQUENCE_BOOKING.puml`
- General sequence (PlantUML): `SYSTEM_SEQUENCE.puml`

## REST API examples

Flights search (with pagination):
```bash
curl "http://localhost:8080/api/flights/search?origin=KUL&destination=TYO&date=2026-02-01&maxPrice=2000&sort=priceAsc&page=0&size=10"
```

Hotels search (with pagination):
```bash
curl "http://localhost:8080/api/hotels/search?location=Bali&minStars=4&maxPrice=500&sort=priceDesc&page=0&size=10"
```

Create a flight booking:
```bash
curl -X POST "http://localhost:8080/api/bookings" \
  -H "Content-Type: application/json" \
  -d "{\"type\":\"FLIGHT\",\"userId\":1,\"flightId\":3,\"pax\":2}"
```

Create a hotel booking:
```bash
curl -X POST "http://localhost:8080/api/bookings" \
  -H "Content-Type: application/json" \
  -d "{\"type\":\"HOTEL\",\"userId\":1,\"hotelId\":5,\"checkIn\":\"2026-02-01\",\"checkOut\":\"2026-02-03\",\"pax\":2}"
```

List bookings for a user (newest first):
```bash
curl "http://localhost:8080/api/bookings?userId=1"
```

Cancel a booking:
```bash
curl -X POST "http://localhost:8080/api/bookings/1/cancel"
```

## Booking rules + inventory behavior
- Flight booking:
  - `pax >= 1`
  - Flight must exist and have `availableSeats >= pax`
  - Seats are reduced by `pax`
  - Total price = `flight.price * pax`
  - Booking status = `CONFIRMED`
  - Booking reference generated as `TRV-YYYY-XXXXX`
- Hotel booking:
  - `checkOut > checkIn` and nights >= 1
  - `pax >= 1`
  - Hotel must exist and have `availableRooms >= 1`
  - Rooms are reduced by 1
  - Total price = `pricePerNight * nights`
  - Booking status = `CONFIRMED`
  - Booking reference generated as `TRV-YYYY-XXXXX`
- Cancel booking:
  - Only `CONFIRMED` bookings can be cancelled
  - Flight seats restored by booking pax
  - Hotel rooms restored by 1
- Users cannot remove just the flight or hotel from a booking (only cancel).

## Tests
Run:
```bash
mvn test
```
