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
address VARCHAR(255),
stars INT,
price_per_night DECIMAL(10,2),
description TEXT,
amenities VARCHAR(500),
available_rooms INT,
image_url VARCHAR(500)
);

CREATE TABLE bookings (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
user_id BIGINT,
booking_type VARCHAR(20),
reference_id BIGINT,
booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
status VARCHAR(20),
total_price DECIMAL(10,2),
passenger_details TEXT,
CONSTRAINT fk_book_user FOREIGN KEY (user_id) REFERENCES users(id)
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
