-- Full database reset + latest schema + seed data
DROP DATABASE IF EXISTS travel_app;
CREATE DATABASE travel_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE travel_app;

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) DEFAULT 'USER',
  verified TINYINT(1) DEFAULT 0,
  verify_token VARCHAR(255),
  reset_token VARCHAR(255)
);

CREATE TABLE flights (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  airline VARCHAR(100),
  flight_number VARCHAR(20),
  origin VARCHAR(100),
  destination VARCHAR(100),
  region VARCHAR(50),
  departure_time DATETIME,
  arrival_time DATETIME,
  price DECIMAL(10,2),
  available_seats INT,
  cabin_class VARCHAR(20)
);

CREATE TABLE hotels (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150),
  location VARCHAR(100),
  region VARCHAR(50),
  address VARCHAR(255),
  stars INT,
  price_per_night DECIMAL(10,2),
  description TEXT,
  amenities VARCHAR(500),
  available_rooms INT,
  image_url VARCHAR(1000)
);

CREATE TABLE destinations (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(120) UNIQUE NOT NULL,
  name VARCHAR(200),
  subtitle VARCHAR(200),
  image_url VARCHAR(1000),
  description TEXT,
  map_embed_url TEXT
);

CREATE TABLE destination_highlights (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  destination_id BIGINT,
  highlight VARCHAR(255),
  sort_order INT,
  CONSTRAINT fk_destination_highlight_destination
    FOREIGN KEY (destination_id) REFERENCES destinations(id)
);

CREATE TABLE destination_activities (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  destination_id BIGINT,
  title VARCHAR(255),
  image_url VARCHAR(1000),
  description VARCHAR(500),
  sort_order INT,
  CONSTRAINT fk_destination_activity_destination
    FOREIGN KEY (destination_id) REFERENCES destinations(id)
);

CREATE TABLE bookings (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT,
  flight_id BIGINT,
  hotel_id BIGINT,
  booking_reference VARCHAR(30) UNIQUE,
  booking_type VARCHAR(20),
  status VARCHAR(20),
  booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  flight_date DATE,
  check_in_date DATE,
  hotel_nights INT,
  passenger_count INT,
  total_price DECIMAL(10,2),
  contact_name VARCHAR(120),
  contact_email VARCHAR(120),
  contact_phone VARCHAR(40),
  CONSTRAINT fk_book_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_book_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
  CONSTRAINT fk_book_hotel FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);

CREATE TABLE passengers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT,
  full_name VARCHAR(120),
  gender VARCHAR(20),
  date_of_birth DATE,
  nationality VARCHAR(60),
  id_number VARCHAR(80),
  passenger_type VARCHAR(20),
  CONSTRAINT fk_passenger_booking FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

CREATE TABLE add_ons (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120),
  description VARCHAR(500),
  price DECIMAL(10,2),
  category VARCHAR(30),
  scope VARCHAR(20),
  active TINYINT(1) DEFAULT 1
);

CREATE TABLE booking_add_ons (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT,
  add_on_id BIGINT,
  quantity INT,
  unit_price DECIMAL(10,2),
  CONSTRAINT fk_booking_addon_booking FOREIGN KEY (booking_id) REFERENCES bookings(id),
  CONSTRAINT fk_booking_addon_addon FOREIGN KEY (add_on_id) REFERENCES add_ons(id)
);

CREATE TABLE user_preferences (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT,
  preferred_destinations VARCHAR(255),
  budget_range VARCHAR(50),
  travel_style VARCHAR(50),
  accommodation_type VARCHAR(50),
  interests VARCHAR(255)
);

USE travel_app;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO flights (airline, flight_number, origin, destination, region, departure_time, arrival_time, price, available_seats, cabin_class) VALUES
('AirAsia','AIA001','Kuala Lumpur','Tokyo','Asia','2026-03-01 08:00:00','2026-03-01 10:00:00',300.00,80,'Economy'),
('Singapore Airlines','SIA002','Kuala Lumpur','Seoul','Asia','2026-03-02 08:00:00','2026-03-02 11:00:00',345.00,90,'Premium Economy'),
('Malaysia Airlines','MAA003','Kuala Lumpur','Bali','Asia','2026-03-03 08:00:00','2026-03-03 12:00:00',390.00,100,'Business'),
('ANA','ANA004','Kuala Lumpur','Hong Kong','Asia','2026-03-04 08:00:00','2026-03-04 13:00:00',435.00,110,'Economy'),
('JAL','JAA005','Kuala Lumpur','Taipei','Asia','2026-03-05 08:00:00','2026-03-05 14:00:00',480.00,120,'Premium Economy'),
('AirAsia','AIA006','Kuala Lumpur','Hanoi','Asia','2026-03-06 08:00:00','2026-03-06 15:00:00',525.00,130,'Business'),
('Singapore Airlines','SIA007','Kuala Lumpur','Manila','Asia','2026-03-07 08:00:00','2026-03-07 16:00:00',300.00,140,'Economy'),
('Malaysia Airlines','MAA008','Kuala Lumpur','Kuala Lumpur','Asia','2026-03-08 08:00:00','2026-03-08 10:00:00',345.00,80,'Premium Economy'),
('ANA','ANA009','Kuala Lumpur','Bangkok','Asia','2026-03-09 08:00:00','2026-03-09 11:00:00',390.00,90,'Business'),
('JAL','JAA010','Kuala Lumpur','Singapore','Asia','2026-03-10 08:00:00','2026-03-10 12:00:00',435.00,100,'Economy'),
('AirAsia','AIA011','Kuala Lumpur','Tokyo','Asia','2026-03-11 08:00:00','2026-03-11 13:00:00',480.00,110,'Premium Economy'),
('Singapore Airlines','SIA012','Kuala Lumpur','Seoul','Asia','2026-03-12 08:00:00','2026-03-12 14:00:00',525.00,120,'Business'),
('Malaysia Airlines','MAA013','Kuala Lumpur','Bali','Asia','2026-03-13 08:00:00','2026-03-13 15:00:00',300.00,130,'Economy'),
('ANA','ANA014','Kuala Lumpur','Hong Kong','Asia','2026-03-14 08:00:00','2026-03-14 16:00:00',345.00,140,'Premium Economy'),
('JAL','JAA015','Kuala Lumpur','Taipei','Asia','2026-03-15 08:00:00','2026-03-15 10:00:00',390.00,80,'Business'),
('AirAsia','AIA016','Kuala Lumpur','Hanoi','Asia','2026-03-16 08:00:00','2026-03-16 11:00:00',435.00,90,'Economy'),
('Singapore Airlines','SIA017','Kuala Lumpur','Manila','Asia','2026-03-17 08:00:00','2026-03-17 12:00:00',480.00,100,'Premium Economy'),
('Malaysia Airlines','MAA018','Kuala Lumpur','Kuala Lumpur','Asia','2026-03-18 08:00:00','2026-03-18 13:00:00',525.00,110,'Business'),
('ANA','ANA019','Kuala Lumpur','Bangkok','Asia','2026-03-19 08:00:00','2026-03-19 14:00:00',300.00,120,'Economy'),
('JAL','JAA020','Kuala Lumpur','Singapore','Asia','2026-03-20 08:00:00','2026-03-20 15:00:00',345.00,130,'Premium Economy'),
('AirAsia','AIA021','Kuala Lumpur','Tokyo','Asia','2026-03-21 08:00:00','2026-03-21 16:00:00',390.00,140,'Business'),
('Singapore Airlines','SIA022','Kuala Lumpur','Seoul','Asia','2026-03-22 08:00:00','2026-03-22 10:00:00',435.00,80,'Economy'),
('Malaysia Airlines','MAA023','Kuala Lumpur','Bali','Asia','2026-03-23 08:00:00','2026-03-23 11:00:00',480.00,90,'Premium Economy'),
('ANA','ANA024','Kuala Lumpur','Hong Kong','Asia','2026-03-24 08:00:00','2026-03-24 12:00:00',525.00,100,'Business'),
('JAL','JAA025','Kuala Lumpur','Taipei','Asia','2026-03-25 08:00:00','2026-03-25 13:00:00',300.00,110,'Economy'),
('AirAsia','AIA026','Kuala Lumpur','Hanoi','Asia','2026-03-26 08:00:00','2026-03-26 14:00:00',345.00,120,'Premium Economy'),
('Singapore Airlines','SIA027','Kuala Lumpur','Manila','Asia','2026-03-27 08:00:00','2026-03-27 15:00:00',390.00,130,'Business'),
('Malaysia Airlines','MAA028','Kuala Lumpur','Kuala Lumpur','Asia','2026-03-28 08:00:00','2026-03-28 16:00:00',435.00,140,'Economy'),
('ANA','ANA029','Kuala Lumpur','Bangkok','Asia','2026-03-29 08:00:00','2026-03-29 10:00:00',480.00,80,'Premium Economy'),
('JAL','JAA030','Kuala Lumpur','Singapore','Asia','2026-03-30 08:00:00','2026-03-30 11:00:00',525.00,90,'Business'),
('Lufthansa','LUE001','Kuala Lumpur','Amsterdam','Europe','2026-03-01 08:00:00','2026-03-01 10:00:00',450.00,80,'Economy'),
('Air France','AIE002','Kuala Lumpur','Berlin','Europe','2026-03-02 08:00:00','2026-03-02 11:00:00',495.00,90,'Premium Economy'),
('British Airways','BRE003','Kuala Lumpur','Madrid','Europe','2026-03-03 08:00:00','2026-03-03 12:00:00',540.00,100,'Business'),
('KLM','KLE004','Kuala Lumpur','Barcelona','Europe','2026-03-04 08:00:00','2026-03-04 13:00:00',585.00,110,'Economy'),
('Iberia','IBE005','Kuala Lumpur','Lisbon','Europe','2026-03-05 08:00:00','2026-03-05 14:00:00',630.00,120,'Premium Economy'),
('Lufthansa','LUE006','Kuala Lumpur','Zurich','Europe','2026-03-06 08:00:00','2026-03-06 15:00:00',675.00,130,'Business'),
('Air France','AIE007','Kuala Lumpur','Vienna','Europe','2026-03-07 08:00:00','2026-03-07 16:00:00',450.00,140,'Economy'),
('British Airways','BRE008','Kuala Lumpur','London','Europe','2026-03-08 08:00:00','2026-03-08 10:00:00',495.00,80,'Premium Economy'),
('KLM','KLE009','Kuala Lumpur','Paris','Europe','2026-03-09 08:00:00','2026-03-09 11:00:00',540.00,90,'Business'),
('Iberia','IBE010','Kuala Lumpur','Rome','Europe','2026-03-10 08:00:00','2026-03-10 12:00:00',585.00,100,'Economy'),
('Lufthansa','LUE011','Kuala Lumpur','Amsterdam','Europe','2026-03-11 08:00:00','2026-03-11 13:00:00',630.00,110,'Premium Economy'),
('Air France','AIE012','Kuala Lumpur','Berlin','Europe','2026-03-12 08:00:00','2026-03-12 14:00:00',675.00,120,'Business'),
('British Airways','BRE013','Kuala Lumpur','Madrid','Europe','2026-03-13 08:00:00','2026-03-13 15:00:00',450.00,130,'Economy'),
('KLM','KLE014','Kuala Lumpur','Barcelona','Europe','2026-03-14 08:00:00','2026-03-14 16:00:00',495.00,140,'Premium Economy'),
('Iberia','IBE015','Kuala Lumpur','Lisbon','Europe','2026-03-15 08:00:00','2026-03-15 10:00:00',540.00,80,'Business'),
('Lufthansa','LUE016','Kuala Lumpur','Zurich','Europe','2026-03-16 08:00:00','2026-03-16 11:00:00',585.00,90,'Economy'),
('Air France','AIE017','Kuala Lumpur','Vienna','Europe','2026-03-17 08:00:00','2026-03-17 12:00:00',630.00,100,'Premium Economy'),
('British Airways','BRE018','Kuala Lumpur','London','Europe','2026-03-18 08:00:00','2026-03-18 13:00:00',675.00,110,'Business'),
('KLM','KLE019','Kuala Lumpur','Paris','Europe','2026-03-19 08:00:00','2026-03-19 14:00:00',450.00,120,'Economy'),
('Iberia','IBE020','Kuala Lumpur','Rome','Europe','2026-03-20 08:00:00','2026-03-20 15:00:00',495.00,130,'Premium Economy'),
('Lufthansa','LUE021','Kuala Lumpur','Amsterdam','Europe','2026-03-21 08:00:00','2026-03-21 16:00:00',540.00,140,'Business'),
('Air France','AIE022','Kuala Lumpur','Berlin','Europe','2026-03-22 08:00:00','2026-03-22 10:00:00',585.00,80,'Economy'),
('British Airways','BRE023','Kuala Lumpur','Madrid','Europe','2026-03-23 08:00:00','2026-03-23 11:00:00',630.00,90,'Premium Economy'),
('KLM','KLE024','Kuala Lumpur','Barcelona','Europe','2026-03-24 08:00:00','2026-03-24 12:00:00',675.00,100,'Business'),
('Iberia','IBE025','Kuala Lumpur','Lisbon','Europe','2026-03-25 08:00:00','2026-03-25 13:00:00',450.00,110,'Economy'),
('Lufthansa','LUE026','Kuala Lumpur','Zurich','Europe','2026-03-26 08:00:00','2026-03-26 14:00:00',495.00,120,'Premium Economy'),
('Air France','AIE027','Kuala Lumpur','Vienna','Europe','2026-03-27 08:00:00','2026-03-27 15:00:00',540.00,130,'Business'),
('British Airways','BRE028','Kuala Lumpur','London','Europe','2026-03-28 08:00:00','2026-03-28 16:00:00',585.00,140,'Economy'),
('KLM','KLE029','Kuala Lumpur','Paris','Europe','2026-03-29 08:00:00','2026-03-29 10:00:00',630.00,80,'Premium Economy'),
('Iberia','IBE030','Kuala Lumpur','Rome','Europe','2026-03-30 08:00:00','2026-03-30 11:00:00',675.00,90,'Business'),
('Delta','DEA001','Kuala Lumpur','San Francisco','America','2026-03-01 08:00:00','2026-03-01 10:00:00',400.00,80,'Economy'),
('United','UNA002','Kuala Lumpur','Miami','America','2026-03-02 08:00:00','2026-03-02 11:00:00',445.00,90,'Premium Economy'),
('American Airlines','AMA003','Kuala Lumpur','Toronto','America','2026-03-03 08:00:00','2026-03-03 12:00:00',490.00,100,'Business'),
('JetBlue','JEA004','Kuala Lumpur','Vancouver','America','2026-03-04 08:00:00','2026-03-04 13:00:00',535.00,110,'Economy'),
('Air Canada','AIA005','Kuala Lumpur','Mexico City','America','2026-03-05 08:00:00','2026-03-05 14:00:00',580.00,120,'Premium Economy'),
('Delta','DEA006','Kuala Lumpur','Dallas','America','2026-03-06 08:00:00','2026-03-06 15:00:00',625.00,130,'Business'),
('United','UNA007','Kuala Lumpur','Atlanta','America','2026-03-07 08:00:00','2026-03-07 16:00:00',400.00,140,'Economy'),
('American Airlines','AMA008','Kuala Lumpur','New York','America','2026-03-08 08:00:00','2026-03-08 10:00:00',445.00,80,'Premium Economy'),
('JetBlue','JEA009','Kuala Lumpur','Los Angeles','America','2026-03-09 08:00:00','2026-03-09 11:00:00',490.00,90,'Business'),
('Air Canada','AIA010','Kuala Lumpur','Chicago','America','2026-03-10 08:00:00','2026-03-10 12:00:00',535.00,100,'Economy'),
('Delta','DEA011','Kuala Lumpur','San Francisco','America','2026-03-11 08:00:00','2026-03-11 13:00:00',580.00,110,'Premium Economy'),
('United','UNA012','Kuala Lumpur','Miami','America','2026-03-12 08:00:00','2026-03-12 14:00:00',625.00,120,'Business'),
('American Airlines','AMA013','Kuala Lumpur','Toronto','America','2026-03-13 08:00:00','2026-03-13 15:00:00',400.00,130,'Economy'),
('JetBlue','JEA014','Kuala Lumpur','Vancouver','America','2026-03-14 08:00:00','2026-03-14 16:00:00',445.00,140,'Premium Economy'),
('Air Canada','AIA015','Kuala Lumpur','Mexico City','America','2026-03-15 08:00:00','2026-03-15 10:00:00',490.00,80,'Business'),
('Delta','DEA016','Kuala Lumpur','Dallas','America','2026-03-16 08:00:00','2026-03-16 11:00:00',535.00,90,'Economy'),
('United','UNA017','Kuala Lumpur','Atlanta','America','2026-03-17 08:00:00','2026-03-17 12:00:00',580.00,100,'Premium Economy'),
('American Airlines','AMA018','Kuala Lumpur','New York','America','2026-03-18 08:00:00','2026-03-18 13:00:00',625.00,110,'Business'),
('JetBlue','JEA019','Kuala Lumpur','Los Angeles','America','2026-03-19 08:00:00','2026-03-19 14:00:00',400.00,120,'Economy'),
('Air Canada','AIA020','Kuala Lumpur','Chicago','America','2026-03-20 08:00:00','2026-03-20 15:00:00',445.00,130,'Premium Economy'),
('Delta','DEA021','Kuala Lumpur','San Francisco','America','2026-03-21 08:00:00','2026-03-21 16:00:00',490.00,140,'Business'),
('United','UNA022','Kuala Lumpur','Miami','America','2026-03-22 08:00:00','2026-03-22 10:00:00',535.00,80,'Economy'),
('American Airlines','AMA023','Kuala Lumpur','Toronto','America','2026-03-23 08:00:00','2026-03-23 11:00:00',580.00,90,'Premium Economy'),
('JetBlue','JEA024','Kuala Lumpur','Vancouver','America','2026-03-24 08:00:00','2026-03-24 12:00:00',625.00,100,'Business'),
('Air Canada','AIA025','Kuala Lumpur','Mexico City','America','2026-03-25 08:00:00','2026-03-25 13:00:00',400.00,110,'Economy'),
('Delta','DEA026','Kuala Lumpur','Dallas','America','2026-03-26 08:00:00','2026-03-26 14:00:00',445.00,120,'Premium Economy'),
('United','UNA027','Kuala Lumpur','Atlanta','America','2026-03-27 08:00:00','2026-03-27 15:00:00',490.00,130,'Business'),
('American Airlines','AMA028','Kuala Lumpur','New York','America','2026-03-28 08:00:00','2026-03-28 16:00:00',535.00,140,'Economy'),
('JetBlue','JEA029','Kuala Lumpur','Los Angeles','America','2026-03-29 08:00:00','2026-03-29 10:00:00',580.00,80,'Premium Economy'),
('Air Canada','AIA030','Kuala Lumpur','Chicago','America','2026-03-30 08:00:00','2026-03-30 11:00:00',625.00,90,'Business'),
('Qantas','QAA001','Kuala Lumpur','Perth','Australia/New Zealand','2026-03-01 08:00:00','2026-03-01 10:00:00',380.00,80,'Economy'),
('Air New Zealand','AIA002','Kuala Lumpur','Adelaide','Australia/New Zealand','2026-03-02 08:00:00','2026-03-02 11:00:00',425.00,90,'Premium Economy'),
('Virgin Australia','VIA003','Kuala Lumpur','Auckland','Australia/New Zealand','2026-03-03 08:00:00','2026-03-03 12:00:00',470.00,100,'Business'),
('Jetstar','JEA004','Kuala Lumpur','Wellington','Australia/New Zealand','2026-03-04 08:00:00','2026-03-04 13:00:00',515.00,110,'Economy'),
('Rex','REA005','Kuala Lumpur','Christchurch','Australia/New Zealand','2026-03-05 08:00:00','2026-03-05 14:00:00',560.00,120,'Premium Economy'),
('Qantas','QAA006','Kuala Lumpur','Gold Coast','Australia/New Zealand','2026-03-06 08:00:00','2026-03-06 15:00:00',605.00,130,'Business'),
('Air New Zealand','AIA007','Kuala Lumpur','Canberra','Australia/New Zealand','2026-03-07 08:00:00','2026-03-07 16:00:00',380.00,140,'Economy'),
('Virgin Australia','VIA008','Kuala Lumpur','Sydney','Australia/New Zealand','2026-03-08 08:00:00','2026-03-08 10:00:00',425.00,80,'Premium Economy'),
('Jetstar','JEA009','Kuala Lumpur','Melbourne','Australia/New Zealand','2026-03-09 08:00:00','2026-03-09 11:00:00',470.00,90,'Business'),
('Rex','REA010','Kuala Lumpur','Brisbane','Australia/New Zealand','2026-03-10 08:00:00','2026-03-10 12:00:00',515.00,100,'Economy'),
('Qantas','QAA011','Kuala Lumpur','Perth','Australia/New Zealand','2026-03-11 08:00:00','2026-03-11 13:00:00',560.00,110,'Premium Economy'),
('Air New Zealand','AIA012','Kuala Lumpur','Adelaide','Australia/New Zealand','2026-03-12 08:00:00','2026-03-12 14:00:00',605.00,120,'Business'),
('Virgin Australia','VIA013','Kuala Lumpur','Auckland','Australia/New Zealand','2026-03-13 08:00:00','2026-03-13 15:00:00',380.00,130,'Economy'),
('Jetstar','JEA014','Kuala Lumpur','Wellington','Australia/New Zealand','2026-03-14 08:00:00','2026-03-14 16:00:00',425.00,140,'Premium Economy'),
('Rex','REA015','Kuala Lumpur','Christchurch','Australia/New Zealand','2026-03-15 08:00:00','2026-03-15 10:00:00',470.00,80,'Business'),
('Qantas','QAA016','Kuala Lumpur','Gold Coast','Australia/New Zealand','2026-03-16 08:00:00','2026-03-16 11:00:00',515.00,90,'Economy'),
('Air New Zealand','AIA017','Kuala Lumpur','Canberra','Australia/New Zealand','2026-03-17 08:00:00','2026-03-17 12:00:00',560.00,100,'Premium Economy'),
('Virgin Australia','VIA018','Kuala Lumpur','Sydney','Australia/New Zealand','2026-03-18 08:00:00','2026-03-18 13:00:00',605.00,110,'Business'),
('Jetstar','JEA019','Kuala Lumpur','Melbourne','Australia/New Zealand','2026-03-19 08:00:00','2026-03-19 14:00:00',380.00,120,'Economy'),
('Rex','REA020','Kuala Lumpur','Brisbane','Australia/New Zealand','2026-03-20 08:00:00','2026-03-20 15:00:00',425.00,130,'Premium Economy'),
('Qantas','QAA021','Kuala Lumpur','Perth','Australia/New Zealand','2026-03-21 08:00:00','2026-03-21 16:00:00',470.00,140,'Business'),
('Air New Zealand','AIA022','Kuala Lumpur','Adelaide','Australia/New Zealand','2026-03-22 08:00:00','2026-03-22 10:00:00',515.00,80,'Economy'),
('Virgin Australia','VIA023','Kuala Lumpur','Auckland','Australia/New Zealand','2026-03-23 08:00:00','2026-03-23 11:00:00',560.00,90,'Premium Economy'),
('Jetstar','JEA024','Kuala Lumpur','Wellington','Australia/New Zealand','2026-03-24 08:00:00','2026-03-24 12:00:00',605.00,100,'Business'),
('Rex','REA025','Kuala Lumpur','Christchurch','Australia/New Zealand','2026-03-25 08:00:00','2026-03-25 13:00:00',380.00,110,'Economy'),
('Qantas','QAA026','Kuala Lumpur','Gold Coast','Australia/New Zealand','2026-03-26 08:00:00','2026-03-26 14:00:00',425.00,120,'Premium Economy'),
('Air New Zealand','AIA027','Kuala Lumpur','Canberra','Australia/New Zealand','2026-03-27 08:00:00','2026-03-27 15:00:00',470.00,130,'Business'),
('Virgin Australia','VIA028','Kuala Lumpur','Sydney','Australia/New Zealand','2026-03-28 08:00:00','2026-03-28 16:00:00',515.00,140,'Economy'),
('Jetstar','JEA029','Kuala Lumpur','Melbourne','Australia/New Zealand','2026-03-29 08:00:00','2026-03-29 10:00:00',560.00,80,'Premium Economy'),
('Rex','REA030','Kuala Lumpur','Brisbane','Australia/New Zealand','2026-03-30 08:00:00','2026-03-30 11:00:00',605.00,90,'Business'),
('AirAsia','KUL031','Kuala Lumpur','Lombok','Asia','2026-04-01 08:00:00','2026-04-01 11:00:00',420.00,120,'Economy'),
('Batik Air','KUL032','Kuala Lumpur','Papua (Jayapura)','Asia','2026-04-02 08:00:00','2026-04-02 16:00:00',820.00,90,'Economy'),
('Malaysia Airlines','KUL033','Kuala Lumpur','Jakarta','Asia','2026-04-03 08:00:00','2026-04-03 10:30:00',380.00,150,'Economy'),
('AirAsia','KUL034','Kuala Lumpur','Bali','Asia','2026-04-04 08:00:00','2026-04-04 11:15:00',410.00,140,'Economy'),
('Garuda Indonesia','KUL035','Kuala Lumpur','Makassar','Asia','2026-04-05 08:00:00','2026-04-05 12:15:00',520.00,110,'Economy'),
('AirAsia','KUL036','Kuala Lumpur','Medan','Asia','2026-04-06 08:00:00','2026-04-06 10:05:00',360.00,140,'Economy'),
('Garuda Indonesia','KUL037','Kuala Lumpur','Yogyakarta','Asia','2026-04-07 08:00:00','2026-04-07 11:05:00',460.00,120,'Economy'),
('Lion Air','KUL038','Kuala Lumpur','Balikpapan','Asia','2026-04-08 08:00:00','2026-04-08 12:15:00',520.00,110,'Economy'),
('Wings Air','KUL039','Kuala Lumpur','Labuan Bajo','Asia','2026-04-09 08:00:00','2026-04-09 12:45:00',560.00,90,'Economy'),
('Garuda Indonesia','KUL040','Kuala Lumpur','Makassar','Asia','2026-04-10 08:00:00','2026-04-10 12:30:00',590.00,100,'Economy');
INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url) VALUES
('Kuala Lumpur Skyline Hotel','Kuala Lumpur','Asia','100 Main Street',3,180.00,'Comfortable stay in Kuala Lumpur with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Bangkok Harbor Hotel','Bangkok','Asia','101 Main Street',4,205.00,'Comfortable stay in Bangkok with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Singapore Lotus Hotel','Singapore','Asia','102 Main Street',5,230.00,'Comfortable stay in Singapore with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Tokyo Grand Hotel','Tokyo','Asia','103 Main Street',3,255.00,'Comfortable stay in Tokyo with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Seoul Zen Hotel','Seoul','Asia','104 Main Street',4,280.00,'Comfortable stay in Seoul with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Bali Skyline Hotel','Bali','Asia','105 Main Street',5,305.00,'Comfortable stay in Bali with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Hong Kong Harbor Hotel','Hong Kong','Asia','106 Main Street',3,180.00,'Comfortable stay in Hong Kong with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Taipei Lotus Hotel','Taipei','Asia','107 Main Street',4,205.00,'Comfortable stay in Taipei with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Hanoi Grand Hotel','Hanoi','Asia','108 Main Street',5,230.00,'Comfortable stay in Hanoi with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Manila Zen Hotel','Manila','Asia','109 Main Street',3,255.00,'Comfortable stay in Manila with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Kuala Lumpur Skyline Hotel','Kuala Lumpur','Asia','110 Main Street',4,280.00,'Comfortable stay in Kuala Lumpur with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Bangkok Harbor Hotel','Bangkok','Asia','111 Main Street',5,305.00,'Comfortable stay in Bangkok with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Singapore Lotus Hotel','Singapore','Asia','112 Main Street',3,180.00,'Comfortable stay in Singapore with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Tokyo Grand Hotel','Tokyo','Asia','113 Main Street',4,205.00,'Comfortable stay in Tokyo with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Seoul Zen Hotel','Seoul','Asia','114 Main Street',5,230.00,'Comfortable stay in Seoul with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Bali Skyline Hotel','Bali','Asia','115 Main Street',3,255.00,'Comfortable stay in Bali with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Hong Kong Harbor Hotel','Hong Kong','Asia','116 Main Street',4,280.00,'Comfortable stay in Hong Kong with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Taipei Lotus Hotel','Taipei','Asia','117 Main Street',5,305.00,'Comfortable stay in Taipei with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Hanoi Grand Hotel','Hanoi','Asia','118 Main Street',3,180.00,'Comfortable stay in Hanoi with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Manila Zen Hotel','Manila','Asia','119 Main Street',4,205.00,'Comfortable stay in Manila with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Kuala Lumpur Skyline Hotel','Kuala Lumpur','Asia','120 Main Street',5,230.00,'Comfortable stay in Kuala Lumpur with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Bangkok Harbor Hotel','Bangkok','Asia','121 Main Street',3,255.00,'Comfortable stay in Bangkok with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Singapore Lotus Hotel','Singapore','Asia','122 Main Street',4,280.00,'Comfortable stay in Singapore with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Tokyo Grand Hotel','Tokyo','Asia','123 Main Street',5,305.00,'Comfortable stay in Tokyo with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Seoul Zen Hotel','Seoul','Asia','124 Main Street',3,180.00,'Comfortable stay in Seoul with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Bali Skyline Hotel','Bali','Asia','125 Main Street',4,205.00,'Comfortable stay in Bali with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Hong Kong Harbor Hotel','Hong Kong','Asia','126 Main Street',5,230.00,'Comfortable stay in Hong Kong with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Taipei Lotus Hotel','Taipei','Asia','127 Main Street',3,255.00,'Comfortable stay in Taipei with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Hanoi Grand Hotel','Hanoi','Asia','128 Main Street',4,280.00,'Comfortable stay in Hanoi with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Manila Zen Hotel','Manila','Asia','129 Main Street',5,305.00,'Comfortable stay in Manila with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('London Continental Hotel','London','Europe','100 Main Street',3,220.00,'Comfortable stay in London with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Paris Riverside Hotel','Paris','Europe','101 Main Street',4,245.00,'Comfortable stay in Paris with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Rome Royal Hotel','Rome','Europe','102 Main Street',5,270.00,'Comfortable stay in Rome with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Amsterdam Heritage Hotel','Amsterdam','Europe','103 Main Street',3,295.00,'Comfortable stay in Amsterdam with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Berlin Metro Hotel','Berlin','Europe','104 Main Street',4,320.00,'Comfortable stay in Berlin with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Madrid Continental Hotel','Madrid','Europe','105 Main Street',5,345.00,'Comfortable stay in Madrid with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Barcelona Riverside Hotel','Barcelona','Europe','106 Main Street',3,220.00,'Comfortable stay in Barcelona with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Lisbon Royal Hotel','Lisbon','Europe','107 Main Street',4,245.00,'Comfortable stay in Lisbon with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Zurich Heritage Hotel','Zurich','Europe','108 Main Street',5,270.00,'Comfortable stay in Zurich with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Vienna Metro Hotel','Vienna','Europe','109 Main Street',3,295.00,'Comfortable stay in Vienna with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('London Continental Hotel','London','Europe','110 Main Street',4,320.00,'Comfortable stay in London with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Paris Riverside Hotel','Paris','Europe','111 Main Street',5,345.00,'Comfortable stay in Paris with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Rome Royal Hotel','Rome','Europe','112 Main Street',3,220.00,'Comfortable stay in Rome with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Amsterdam Heritage Hotel','Amsterdam','Europe','113 Main Street',4,245.00,'Comfortable stay in Amsterdam with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Berlin Metro Hotel','Berlin','Europe','114 Main Street',5,270.00,'Comfortable stay in Berlin with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Madrid Continental Hotel','Madrid','Europe','115 Main Street',3,295.00,'Comfortable stay in Madrid with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Barcelona Riverside Hotel','Barcelona','Europe','116 Main Street',4,320.00,'Comfortable stay in Barcelona with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Lisbon Royal Hotel','Lisbon','Europe','117 Main Street',5,345.00,'Comfortable stay in Lisbon with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Zurich Heritage Hotel','Zurich','Europe','118 Main Street',3,220.00,'Comfortable stay in Zurich with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Vienna Metro Hotel','Vienna','Europe','119 Main Street',4,245.00,'Comfortable stay in Vienna with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('London Continental Hotel','London','Europe','120 Main Street',5,270.00,'Comfortable stay in London with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Paris Riverside Hotel','Paris','Europe','121 Main Street',3,295.00,'Comfortable stay in Paris with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Rome Royal Hotel','Rome','Europe','122 Main Street',4,320.00,'Comfortable stay in Rome with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Amsterdam Heritage Hotel','Amsterdam','Europe','123 Main Street',5,345.00,'Comfortable stay in Amsterdam with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Berlin Metro Hotel','Berlin','Europe','124 Main Street',3,220.00,'Comfortable stay in Berlin with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Madrid Continental Hotel','Madrid','Europe','125 Main Street',4,245.00,'Comfortable stay in Madrid with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Barcelona Riverside Hotel','Barcelona','Europe','126 Main Street',5,270.00,'Comfortable stay in Barcelona with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Lisbon Royal Hotel','Lisbon','Europe','127 Main Street',3,295.00,'Comfortable stay in Lisbon with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Zurich Heritage Hotel','Zurich','Europe','128 Main Street',4,320.00,'Comfortable stay in Zurich with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Vienna Metro Hotel','Vienna','Europe','129 Main Street',5,345.00,'Comfortable stay in Vienna with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('New York Downtown Hotel','New York','America','100 Main Street',3,200.00,'Comfortable stay in New York with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Los Angeles Capital Hotel','Los Angeles','America','101 Main Street',4,225.00,'Comfortable stay in Los Angeles with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Chicago Skyline Hotel','Chicago','America','102 Main Street',5,250.00,'Comfortable stay in Chicago with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('San Francisco Union Hotel','San Francisco','America','103 Main Street',3,275.00,'Comfortable stay in San Francisco with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Miami Bayfront Hotel','Miami','America','104 Main Street',4,300.00,'Comfortable stay in Miami with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Toronto Downtown Hotel','Toronto','America','105 Main Street',5,325.00,'Comfortable stay in Toronto with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Vancouver Capital Hotel','Vancouver','America','106 Main Street',3,200.00,'Comfortable stay in Vancouver with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Mexico City Skyline Hotel','Mexico City','America','107 Main Street',4,225.00,'Comfortable stay in Mexico City with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Dallas Union Hotel','Dallas','America','108 Main Street',5,250.00,'Comfortable stay in Dallas with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Atlanta Bayfront Hotel','Atlanta','America','109 Main Street',3,275.00,'Comfortable stay in Atlanta with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('New York Downtown Hotel','New York','America','110 Main Street',4,300.00,'Comfortable stay in New York with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Los Angeles Capital Hotel','Los Angeles','America','111 Main Street',5,325.00,'Comfortable stay in Los Angeles with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Chicago Skyline Hotel','Chicago','America','112 Main Street',3,200.00,'Comfortable stay in Chicago with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('San Francisco Union Hotel','San Francisco','America','113 Main Street',4,225.00,'Comfortable stay in San Francisco with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Miami Bayfront Hotel','Miami','America','114 Main Street',5,250.00,'Comfortable stay in Miami with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Toronto Downtown Hotel','Toronto','America','115 Main Street',3,275.00,'Comfortable stay in Toronto with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Vancouver Capital Hotel','Vancouver','America','116 Main Street',4,300.00,'Comfortable stay in Vancouver with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Mexico City Skyline Hotel','Mexico City','America','117 Main Street',5,325.00,'Comfortable stay in Mexico City with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Dallas Union Hotel','Dallas','America','118 Main Street',3,200.00,'Comfortable stay in Dallas with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Atlanta Bayfront Hotel','Atlanta','America','119 Main Street',4,225.00,'Comfortable stay in Atlanta with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('New York Downtown Hotel','New York','America','120 Main Street',5,250.00,'Comfortable stay in New York with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Los Angeles Capital Hotel','Los Angeles','America','121 Main Street',3,275.00,'Comfortable stay in Los Angeles with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Chicago Skyline Hotel','Chicago','America','122 Main Street',4,300.00,'Comfortable stay in Chicago with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('San Francisco Union Hotel','San Francisco','America','123 Main Street',5,325.00,'Comfortable stay in San Francisco with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Miami Bayfront Hotel','Miami','America','124 Main Street',3,200.00,'Comfortable stay in Miami with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Toronto Downtown Hotel','Toronto','America','125 Main Street',4,225.00,'Comfortable stay in Toronto with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Vancouver Capital Hotel','Vancouver','America','126 Main Street',5,250.00,'Comfortable stay in Vancouver with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Mexico City Skyline Hotel','Mexico City','America','127 Main Street',3,275.00,'Comfortable stay in Mexico City with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Dallas Union Hotel','Dallas','America','128 Main Street',4,300.00,'Comfortable stay in Dallas with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Atlanta Bayfront Hotel','Atlanta','America','129 Main Street',5,325.00,'Comfortable stay in Atlanta with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Sydney Coastal Hotel','Sydney','Australia/New Zealand','100 Main Street',3,190.00,'Comfortable stay in Sydney with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Melbourne Harbor Hotel','Melbourne','Australia/New Zealand','101 Main Street',4,215.00,'Comfortable stay in Melbourne with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Brisbane Pacific Hotel','Brisbane','Australia/New Zealand','102 Main Street',5,240.00,'Comfortable stay in Brisbane with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Perth Garden Hotel','Perth','Australia/New Zealand','103 Main Street',3,265.00,'Comfortable stay in Perth with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Adelaide Summit Hotel','Adelaide','Australia/New Zealand','104 Main Street',4,290.00,'Comfortable stay in Adelaide with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Auckland Coastal Hotel','Auckland','Australia/New Zealand','105 Main Street',5,315.00,'Comfortable stay in Auckland with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Wellington Harbor Hotel','Wellington','Australia/New Zealand','106 Main Street',3,190.00,'Comfortable stay in Wellington with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Christchurch Pacific Hotel','Christchurch','Australia/New Zealand','107 Main Street',4,215.00,'Comfortable stay in Christchurch with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Gold Coast Garden Hotel','Gold Coast','Australia/New Zealand','108 Main Street',5,240.00,'Comfortable stay in Gold Coast with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Canberra Summit Hotel','Canberra','Australia/New Zealand','109 Main Street',3,265.00,'Comfortable stay in Canberra with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Sydney Coastal Hotel','Sydney','Australia/New Zealand','110 Main Street',4,290.00,'Comfortable stay in Sydney with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Melbourne Harbor Hotel','Melbourne','Australia/New Zealand','111 Main Street',5,315.00,'Comfortable stay in Melbourne with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Brisbane Pacific Hotel','Brisbane','Australia/New Zealand','112 Main Street',3,190.00,'Comfortable stay in Brisbane with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Perth Garden Hotel','Perth','Australia/New Zealand','113 Main Street',4,215.00,'Comfortable stay in Perth with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Adelaide Summit Hotel','Adelaide','Australia/New Zealand','114 Main Street',5,240.00,'Comfortable stay in Adelaide with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Auckland Coastal Hotel','Auckland','Australia/New Zealand','115 Main Street',3,265.00,'Comfortable stay in Auckland with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Wellington Harbor Hotel','Wellington','Australia/New Zealand','116 Main Street',4,290.00,'Comfortable stay in Wellington with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Christchurch Pacific Hotel','Christchurch','Australia/New Zealand','117 Main Street',5,315.00,'Comfortable stay in Christchurch with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Gold Coast Garden Hotel','Gold Coast','Australia/New Zealand','118 Main Street',3,190.00,'Comfortable stay in Gold Coast with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Canberra Summit Hotel','Canberra','Australia/New Zealand','119 Main Street',4,215.00,'Comfortable stay in Canberra with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Sydney Coastal Hotel','Sydney','Australia/New Zealand','120 Main Street',5,240.00,'Comfortable stay in Sydney with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Melbourne Harbor Hotel','Melbourne','Australia/New Zealand','121 Main Street',3,265.00,'Comfortable stay in Melbourne with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Brisbane Pacific Hotel','Brisbane','Australia/New Zealand','122 Main Street',4,290.00,'Comfortable stay in Brisbane with easy access to top sights.','WiFi, Gym, Breakfast',50,NULL),
('Perth Garden Hotel','Perth','Australia/New Zealand','123 Main Street',5,315.00,'Comfortable stay in Perth with easy access to top sights.','WiFi, Gym, Breakfast',55,NULL),
('Adelaide Summit Hotel','Adelaide','Australia/New Zealand','124 Main Street',3,190.00,'Comfortable stay in Adelaide with easy access to top sights.','WiFi, Gym, Breakfast',20,NULL),
('Auckland Coastal Hotel','Auckland','Australia/New Zealand','125 Main Street',4,215.00,'Comfortable stay in Auckland with easy access to top sights.','WiFi, Gym, Breakfast',25,NULL),
('Wellington Harbor Hotel','Wellington','Australia/New Zealand','126 Main Street',5,240.00,'Comfortable stay in Wellington with easy access to top sights.','WiFi, Gym, Breakfast',30,NULL),
('Christchurch Pacific Hotel','Christchurch','Australia/New Zealand','127 Main Street',3,265.00,'Comfortable stay in Christchurch with easy access to top sights.','WiFi, Gym, Breakfast',35,NULL),
('Gold Coast Garden Hotel','Gold Coast','Australia/New Zealand','128 Main Street',4,290.00,'Comfortable stay in Gold Coast with easy access to top sights.','WiFi, Gym, Breakfast',40,NULL),
('Canberra Summit Hotel','Canberra','Australia/New Zealand','129 Main Street',5,315.00,'Comfortable stay in Canberra with easy access to top sights.','WiFi, Gym, Breakfast',45,NULL),
('Lombok Bay Resort','Lombok','Asia','12 Kuta Beach Road',4,320.00,'Beachfront resort near Lombok surf spots.','WiFi, Pool, Spa',28,NULL),
('Papua Highlands Lodge','Papua (Jayapura)','Asia','88 Yos Sudarso Street',4,280.00,'Comfortable stay near Papua highlands and coast.','WiFi, Breakfast',18,NULL),
('Medan Heritage Hotel','Medan','Asia','77 Merdeka Street',4,260.00,'City-center stay close to culinary hotspots.','WiFi, Breakfast',20,NULL),
('Yogyakarta Palace Inn','Yogyakarta','Asia','15 Malioboro Street',4,240.00,'Boutique stay near heritage streets and markets.','WiFi, Breakfast',18,NULL),
('Balikpapan Bay Hotel','Balikpapan','Asia','9 Sudirman Street',4,270.00,'Waterfront views with easy airport access.','WiFi, Pool',16,NULL),
('Makassar Harbor Hotel','Makassar','Asia','21 Losari Street',4,250.00,'Seaside stay near Losari Beach.','WiFi, Breakfast',22,NULL),
('Labuan Bajo Seaside Hotel','Labuan Bajo','Asia','3 Komodo Street',4,360.00,'Gateway hotel for Komodo adventures.','WiFi, Pool, Breakfast',22,NULL);
INSERT INTO users (username, email, password_hash, role, verified)
SELECT 'admin', 'admin@gmail.com', '$2a$10$3cP47As96YHYmhQMNDx5Ue6ewdeuFWnUz6ViToOSW5ehtxkMuvPTO', 'ADMIN', 1
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE username = 'admin' OR email = 'admin@gmail.com'
);

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK101', 'Kuala Lumpur', 'Bangkok', '2026-01-05 07:15:00', '2026-01-05 09:15:00', 299.00, 120, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK101');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Malaysia Airlines', 'MH772', 'Kuala Lumpur', 'Sydney', '2026-01-10 07:15:00', '2026-01-10 15:15:00', 1850.00, 80, 'Economy', 'Australia/New Zealand'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MH772');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Singapore Airlines', 'SQ415', 'Kuala Lumpur', 'Tokyo', '2026-01-15 07:15:00', '2026-01-15 13:15:00', 2200.00, 60, 'Business', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'SQ415');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK202', 'Kuala Lumpur', 'Bali', '2026-01-20 07:15:00', '2026-01-20 10:15:00', 420.00, 140, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK202');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Batik Air', 'BT301', 'Kuala Lumpur', 'Lombok', '2026-01-22 07:15:00', '2026-01-22 10:45:00', 520.00, 110, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'BT301');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Garuda Indonesia', 'GA412', 'Kuala Lumpur', 'Papua (Jayapura)', '2026-01-24 07:15:00', '2026-01-24 15:30:00', 980.00, 90, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'GA412');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Malaysia Airlines', 'MH603', 'Kuala Lumpur', 'Jakarta', '2026-01-26 07:15:00', '2026-01-26 09:45:00', 390.00, 150, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MH603');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK744', 'Kuala Lumpur', 'Surabaya', '2026-01-28 07:15:00', '2026-01-28 10:05:00', 360.00, 130, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK744');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK850', 'Kuala Lumpur', 'Medan', '2026-01-30 07:15:00', '2026-01-30 09:05:00', 340.00, 140, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK850');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Garuda Indonesia', 'GA861', 'Kuala Lumpur', 'Yogyakarta', '2026-02-02 07:15:00', '2026-02-02 10:05:00', 460.00, 120, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'GA861');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Lion Air', 'JT772', 'Kuala Lumpur', 'Balikpapan', '2026-02-04 07:15:00', '2026-02-04 11:15:00', 520.00, 110, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'JT772');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Wings Air', 'IW650', 'Kuala Lumpur', 'Labuan Bajo', '2026-02-06 07:15:00', '2026-02-06 11:45:00', 560.00, 90, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'IW650');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Garuda Indonesia', 'GA980', 'Kuala Lumpur', 'Makassar', '2026-02-08 07:15:00', '2026-02-08 11:30:00', 580.00, 100, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'GA980');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Ocean Breeze Resort', 'Bali', 'Asia', 'Jl. Sunset Road', 4, 350.00, 'Beachfront stay with sunrise views.', 'Pool, Spa, WiFi', 25, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Ocean Breeze Resort' AND location = 'Bali');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Cityline Suites', 'Kuala Lumpur', 'Asia', 'Bukit Bintang', 3, 220.00, 'Central city stay near shopping and food.', 'WiFi, Gym', 30, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Cityline Suites' AND location = 'Kuala Lumpur');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Harbor View Hotel', 'Singapore', 'Asia', 'Marina Bay', 5, 650.00, 'Luxury stay with skyline views.', 'Pool, Spa, Concierge', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Harbor View Hotel' AND location = 'Singapore');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Lombok Bay Resort', 'Lombok', 'Asia', 'Jl. Kuta Beach', 4, 320.00, 'Beachfront resort close to Lombok surf spots.', 'Pool, Spa, WiFi', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Lombok Bay Resort' AND location = 'Lombok');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Papua Highlands Lodge', 'Papua (Jayapura)', 'Asia', 'Jl. Yos Sudarso', 4, 280.00, 'Comfortable stay near Papua highlands and coast.', 'WiFi, Breakfast', 15, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Papua Highlands Lodge' AND location = 'Papua (Jayapura)');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Medan Heritage Hotel', 'Medan', 'Asia', 'Jl. Sudirman', 4, 260.00, 'City-center stay close to culinary hotspots.', 'WiFi, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Medan Heritage Hotel' AND location = 'Medan');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Yogyakarta Palace Inn', 'Yogyakarta', 'Asia', 'Jl. Malioboro', 4, 240.00, 'Boutique stay near heritage streets and markets.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Yogyakarta Palace Inn' AND location = 'Yogyakarta');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Balikpapan Bay Hotel', 'Balikpapan', 'Asia', 'Jl. Sudirman', 4, 270.00, 'Waterfront views with easy airport access.', 'WiFi, Pool', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Balikpapan Bay Hotel' AND location = 'Balikpapan');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Labuan Bajo Seaside Hotel', 'Labuan Bajo', 'Asia', 'Jl. Komodo', 4, 360.00, 'Gateway stay for Komodo adventures.', 'WiFi, Pool, Breakfast', 14, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Labuan Bajo Seaside Hotel' AND location = 'Labuan Bajo');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Makassar Harbor Hotel', 'Makassar', 'Asia', 'Jl. Losari', 4, 250.00, 'Seaside stay near Losari Beach.', 'WiFi, Breakfast', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Makassar Harbor Hotel' AND location = 'Makassar');

UPDATE flights
SET region = 'Asia'
WHERE id IS NOT NULL
  AND region IS NULL
  AND (destination IN ('Bangkok', 'Sydney', 'Tokyo') OR origin IN ('Kuala Lumpur', 'Singapore'));

UPDATE hotels
SET region = 'Asia'
WHERE id IS NOT NULL
  AND region IS NULL
  AND location IN ('Bali', 'Kuala Lumpur', 'Singapore', 'Lombok', 'Papua (Jayapura)', 'Medan', 'Yogyakarta', 'Balikpapan', 'Labuan Bajo', 'Makassar');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Extra Baggage 15kg', 'Add 15kg of checked baggage to your flight.', 45.00, 'BAGGAGE', 'FLIGHT', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Extra Baggage 15kg');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Extra Baggage 25kg', 'Add 25kg of checked baggage to your flight.', 75.00, 'BAGGAGE', 'FLIGHT', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Extra Baggage 25kg');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Premium Meal', 'Chef curated meal with priority service.', 28.00, 'MEAL', 'FLIGHT', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Premium Meal');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Priority Boarding', 'Skip the queue with priority boarding access.', 19.00, 'SEAT', 'FLIGHT', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Priority Boarding');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Flexi Change', 'Change your flight once without penalty.', 39.00, 'FLEX', 'FLIGHT', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Flexi Change');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Travel Insurance', 'Coverage for delays, baggage, and cancellations.', 34.00, 'INSURANCE', 'BOTH', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Travel Insurance');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Airport Transfer', 'Private transfer to or from the airport.', 55.00, 'TRANSFER', 'BOTH', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Airport Transfer');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Late Check-out', 'Stay an extra 3 hours on your last day.', 25.00, 'COMFORT', 'HOTEL', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Late Check-out');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Breakfast Upgrade', 'Daily breakfast for every guest.', 20.00, 'EXTRA', 'HOTEL', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Breakfast Upgrade');

INSERT INTO add_ons (name, description, price, category, scope, active)
SELECT 'Room View Upgrade', 'Upgrade to a premium view room.', 45.00, 'COMFORT', 'HOTEL', 1
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM add_ons WHERE name = 'Room View Upgrade');

INSERT INTO destinations (slug, name, subtitle, image_url, description, map_embed_url)
SELECT 'paris', 'Paris, France', 'The City of Light awaits',
       'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1600&q=80',
       'Paris is famous for art, fashion, cafe culture and iconic landmarks.',
       'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d20954.59318806903!2d2.292292042126358!3d48.85837361160796!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47e66fdfc3c2c5cf%3A0x2b0fd6bbf7f7e7f6!2sEiffel%20Tower!5e0!3m2!1sen!2smy!4v1730000000000!5m2!1sen!2smy'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE slug = 'paris');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Visit the Eiffel Tower at sunset', 1
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Visit the Eiffel Tower at sunset');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Explore the Louvre and see the Mona Lisa', 2
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Explore the Louvre and see the Mona Lisa');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Walk along the Seine River and visit Notre Dame', 3
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Walk along the Seine River and visit Notre Dame');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Enjoy coffee and croissants at a street cafe', 4
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Enjoy coffee and croissants at a street cafe');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Eiffel Tower Summit',
       'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1200&q=80',
       'Go early for smaller crowds and golden light.', 1
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Eiffel Tower Summit');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Louvre Museum',
       'https://images.unsplash.com/photo-1522098543979-ffc7f79a56b5?auto=format&fit=crop&w=1200&q=80',
       'Book a timed entry and focus on one wing.', 2
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Louvre Museum');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Seine River Walk',
       'https://images.unsplash.com/photo-1444312645910-ffa973656eba?auto=format&fit=crop&w=1200&q=80',
       'Stroll from Pont Neuf to Notre Dame.', 3
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Seine River Walk');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Montmartre Cafe',
       'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80',
       'Sunset coffee at Place du Tertre.', 4
FROM destinations d
WHERE d.slug = 'paris'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Montmartre Cafe');

INSERT INTO destinations (slug, name, subtitle, image_url, description, map_embed_url)
SELECT 'tokyo', 'Tokyo, Japan', 'Ancient meets modern',
       'https://images.unsplash.com/photo-1505066836043-7b0f40f2b7a2?auto=format&fit=crop&w=1600&q=80',
       'Tokyo mixes futuristic skyscrapers with historic temples and incredible food.',
       'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3241.987346231799!2d139.69932551525836!3d35.65949498019996!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x60188b57c0f2c9a7%3A0xa2b3f2f2bb0e0123!2sShibuya%20Crossing!5e0!3m2!1sen!2smy!4v1730000000001!5m2!1sen!2smy'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE slug = 'tokyo');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Visit Senso-ji Temple in Asakusa', 1
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Visit Senso-ji Temple in Asakusa');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Watch the Shibuya Crossing at night', 2
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Watch the Shibuya Crossing at night');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Eat sushi around Toyosu or Tsukiji', 3
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Eat sushi around Toyosu or Tsukiji');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Explore Akihabara for anime and games', 4
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Explore Akihabara for anime and games');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Senso-ji at Dawn',
       'https://images.unsplash.com/photo-1549692520-acc6669e2f0c?auto=format&fit=crop&w=1200&q=80',
       'Quiet lantern alleys before the crowds.', 1
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Senso-ji at Dawn');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Shibuya Crossing',
       'https://images.unsplash.com/photo-1505066836043-7b0f40f2b7a2?auto=format&fit=crop&w=1200&q=80',
       'Best view from the Magnet by Shibuya109.', 2
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Shibuya Crossing');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Tsukiji Food Tour',
       'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=1200&q=80',
       'Sample tamago, sushi, and matcha sweets.', 3
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Tsukiji Food Tour');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'TeamLab Planets',
       'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
       'Immersive digital art museum experience.', 4
FROM destinations d
WHERE d.slug = 'tokyo'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'TeamLab Planets');

INSERT INTO destinations (slug, name, subtitle, image_url, description, map_embed_url)
SELECT 'bali', 'Bali, Indonesia', 'Paradise on Earth',
       'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1600&q=80',
       'Bali is known for its beaches, rice terraces, temples and laid-back vibe.',
       'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d253840.48781648088!2d115.0920182778642!3d-8.40951776848085!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2dd246bb4cf2fa2d%3A0x3030bfbca7ccdf0!2sBali!5e0!3m2!1sen!2smy!4v1730000000002!5m2!1sen!2smy'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE slug = 'bali');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Relax at Seminyak or Nusa Dua beach', 1
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Relax at Seminyak or Nusa Dua beach');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Visit Tanah Lot and Uluwatu temples', 2
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Visit Tanah Lot and Uluwatu temples');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'See rice terraces in Ubud', 3
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'See rice terraces in Ubud');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Try surfing or snorkeling', 4
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Try surfing or snorkeling');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Uluwatu Temple',
       'https://images.unsplash.com/photo-1508002366005-75a695ee2d17?auto=format&fit=crop&w=1200&q=80',
       'Clifftop sunset and Kecak dance.', 1
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Uluwatu Temple');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Ubud Rice Terraces',
       'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
       'Morning walk through Tegallalang.', 2
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Ubud Rice Terraces');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Beach Day',
       'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
       'Seminyak loungers and surf breaks.', 3
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Beach Day');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Waterfall Hike',
       'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
       'Cool off at Tegenungan.', 4
FROM destinations d
WHERE d.slug = 'bali'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Waterfall Hike');

INSERT INTO destinations (slug, name, subtitle, image_url, description, map_embed_url)
SELECT 'new-york', 'New York, USA', 'The city that never sleeps',
       'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=1600&q=80',
       'New York is packed with skyscrapers, Broadway shows and amazing food.',
       'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3021.963821169822!2d-73.98715528459372!3d40.75889597932673!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25855d0a4f8bd%3A0x8f4f9ce828d2fd0!2sTimes%20Square!5e0!3m2!1sen!2smy!4v1730000000003!5m2!1sen!2smy'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE slug = 'new-york');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Visit Times Square and Broadway', 1
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Visit Times Square and Broadway');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Walk through Central Park', 2
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Walk through Central Park');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'See the Statue of Liberty', 3
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'See the Statue of Liberty');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Enjoy rooftop views of the skyline', 4
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Enjoy rooftop views of the skyline');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Times Square Lights',
       'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=1200&q=80',
       'Night photos and street performers.', 1
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Times Square Lights');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Central Park Loop',
       'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1200&q=80',
       'Bike the loop or take a carriage ride.', 2
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Central Park Loop');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Statue of Liberty',
       'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
       'Ferry from Battery Park.', 3
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Statue of Liberty');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Brooklyn Bridge Walk',
       'https://images.unsplash.com/photo-1441716844725-09cedc13a4e7?auto=format&fit=crop&w=1200&q=80',
       'Sunrise views toward Manhattan.', 4
FROM destinations d
WHERE d.slug = 'new-york'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Brooklyn Bridge Walk');

INSERT INTO destinations (slug, name, subtitle, image_url, description, map_embed_url)
SELECT 'dubai', 'Dubai, UAE', 'Luxury and adventure',
       'https://images.unsplash.com/photo-1526481280695-3c687fd643ed?auto=format&fit=crop&w=1600&q=80',
       'Dubai combines futuristic architecture with desert adventures.',
       'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3609.5502123299916!2d55.27218791501266!3d25.19719698389543!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3e5f682a2f2bd5df%3A0xa5c4bcd8a2c8f1ab!2sBurj%20Khalifa!5e0!3m2!1sen!2smy!4v1730000000004!5m2!1sen!2smy'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE slug = 'dubai');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Go to the top of Burj Khalifa', 1
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Go to the top of Burj Khalifa');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Shop at Dubai Mall', 2
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Shop at Dubai Mall');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Desert safari with dune bashing', 3
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Desert safari with dune bashing');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Relax at Jumeirah Beach', 4
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Relax at Jumeirah Beach');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Burj Khalifa',
       'https://images.unsplash.com/photo-1526481280695-3c687fd643ed?auto=format&fit=crop&w=1200&q=80',
       'At The Top tickets for sunset.', 1
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Burj Khalifa');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Desert Safari',
       'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
       'Dune bashing and camel rides.', 2
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Desert Safari');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Dubai Marina',
       'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1200&q=80',
       'Evening walk and dinner cruise.', 3
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Dubai Marina');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Jumeirah Beach',
       'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
       'Morning swim with Burj views.', 4
FROM destinations d
WHERE d.slug = 'dubai'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Jumeirah Beach');

INSERT INTO destinations (slug, name, subtitle, image_url, description, map_embed_url)
SELECT 'rome', 'Rome, Italy', 'Eternal city of wonders',
       'https://images.unsplash.com/photo-1501949997128-2fdb9f6428b3?auto=format&fit=crop&w=1600&q=80',
       'Rome is full of ancient ruins, churches and Italian food.',
       'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2994.20105228472!2d12.49136661507727!3d41.890210979221106!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x132f61b4c3b7e2ff%3A0x6f2c8f9f77777777!2sColosseum!5e0!3m2!1sen!2smy!4v1730000000005!5m2!1sen!2smy'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM destinations WHERE slug = 'rome');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Visit the Colosseum and Roman Forum', 1
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Visit the Colosseum and Roman Forum');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Throw a coin into Trevi Fountain', 2
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Throw a coin into Trevi Fountain');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'See the Vatican and St. Peter Basilica', 3
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'See the Vatican and St. Peter Basilica');

INSERT INTO destination_highlights (destination_id, highlight, sort_order)
SELECT d.id, 'Eat gelato near the Spanish Steps', 4
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_highlights h WHERE h.destination_id = d.id AND h.highlight = 'Eat gelato near the Spanish Steps');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Colosseum Tour',
       'https://images.unsplash.com/photo-1501949997128-2fdb9f6428b3?auto=format&fit=crop&w=1200&q=80',
       'Underground access if available.', 1
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Colosseum Tour');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Trevi Fountain',
       'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
       'Visit early morning for photos.', 2
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Trevi Fountain');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Vatican Museums',
       'https://images.unsplash.com/photo-1501949997128-2fdb9f6428b3?auto=format&fit=crop&w=1200&q=80',
       'Sistine Chapel highlight.', 3
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Vatican Museums');

INSERT INTO destination_activities (destination_id, title, image_url, description, sort_order)
SELECT d.id, 'Evening Piazza Walk',
       'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
       'Snack your way across Rome.', 4
FROM destinations d
WHERE d.slug = 'rome'
  AND NOT EXISTS (SELECT 1 FROM destination_activities a WHERE a.destination_id = d.id AND a.title = 'Evening Piazza Walk');

SET SQL_SAFE_UPDATES = 1;
