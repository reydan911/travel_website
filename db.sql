CREATE DATABASE IF NOT EXISTS travel_app;
USE travel_app;

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
origin VARCHAR(10),
destination VARCHAR(10),
region VARCHAR(20),
departure_time DATETIME,
arrival_time DATETIME,
price DECIMAL(10,2),
available_seats INT,
cabin_class VARCHAR(20)
);

CREATE TABLE hotels (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
location VARCHAR(100),
region VARCHAR(20),
address VARCHAR(255),
stars INT,
price_per_night DECIMAL(10,2),
description TEXT,
amenities VARCHAR(500),
available_rooms INT,
image_url VARCHAR(500)
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
CONSTRAINT fk_destination_highlight_destination FOREIGN KEY (destination_id) REFERENCES destinations(id)
);

CREATE TABLE destination_activities (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
destination_id BIGINT,
title VARCHAR(255),
image_url VARCHAR(1000),
description VARCHAR(500),
sort_order INT,
CONSTRAINT fk_destination_activity_destination FOREIGN KEY (destination_id) REFERENCES destinations(id)
);

CREATE TABLE bookings (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
user_id BIGINT,
flight_id BIGINT,
hotel_id BIGINT,
booking_code VARCHAR(20) UNIQUE,
booking_type VARCHAR(20),
booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
flight_date DATE,
check_in_date DATE,
hotel_nights INT,
status VARCHAR(20),
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
interests VARCHAR(255),
CONSTRAINT fk_pref_user FOREIGN KEY (user_id) REFERENCES users(id)
);
UPDATE users SET role = 'ADMIN' WHERE username = 'admin';
-- or
UPDATE users SET role = 'ADMIN' WHERE email = 'admin@gmail.com';
