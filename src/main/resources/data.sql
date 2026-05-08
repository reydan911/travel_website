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

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK901', 'Kuala Lumpur', 'Singapore', '2026-03-01 07:10:00', '2026-03-01 08:25:00', 190.00, 160, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK901');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Singapore Airlines', 'SQ226', 'Kuala Lumpur', 'Singapore', '2026-03-01 13:40:00', '2026-03-01 14:50:00', 320.00, 120, 'Premium Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'SQ226');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Malaysia Airlines', 'MH606', 'Kuala Lumpur', 'Bangkok', '2026-03-02 09:00:00', '2026-03-02 11:15:00', 260.00, 140, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MH606');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Thai Airways', 'TG418', 'Kuala Lumpur', 'Bangkok', '2026-03-02 18:30:00', '2026-03-02 20:45:00', 420.00, 110, 'Business', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'TG418');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Garuda Indonesia', 'GA733', 'Kuala Lumpur', 'Jakarta', '2026-03-03 08:20:00', '2026-03-03 10:30:00', 300.00, 150, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'GA733');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Batik Air', 'BT512', 'Kuala Lumpur', 'Jakarta', '2026-03-03 16:10:00', '2026-03-03 18:20:00', 340.00, 120, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'BT512');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK388', 'Kuala Lumpur', 'Bali', '2026-03-04 07:50:00', '2026-03-04 10:40:00', 360.00, 160, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK388');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Malaysia Airlines', 'MH715', 'Kuala Lumpur', 'Bali', '2026-03-04 14:30:00', '2026-03-04 17:15:00', 520.00, 100, 'Premium Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MH715');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'ANA', 'NH813', 'Kuala Lumpur', 'Tokyo', '2026-03-05 23:10:00', '2026-03-06 07:10:00', 1350.00, 80, 'Business', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'NH813');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Japan Airlines', 'JL702', 'Kuala Lumpur', 'Tokyo', '2026-03-06 11:20:00', '2026-03-06 19:20:00', 980.00, 90, 'Premium Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'JL702');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Korean Air', 'KE680', 'Kuala Lumpur', 'Seoul', '2026-03-06 22:40:00', '2026-03-07 06:10:00', 860.00, 100, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'KE680');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Cathay Pacific', 'CX720', 'Kuala Lumpur', 'Hong Kong', '2026-03-07 13:10:00', '2026-03-07 17:10:00', 680.00, 100, 'Premium Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'CX720');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'EVA Air', 'BR230', 'Kuala Lumpur', 'Taipei', '2026-03-08 10:00:00', '2026-03-08 14:30:00', 600.00, 90, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'BR230');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Vietnam Airlines', 'VN676', 'Kuala Lumpur', 'Ho Chi Minh City', '2026-03-08 12:15:00', '2026-03-08 14:30:00', 320.00, 120, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'VN676');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Philippine Airlines', 'PR528', 'Kuala Lumpur', 'Manila', '2026-03-09 08:50:00', '2026-03-09 12:20:00', 480.00, 110, 'Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'PR528');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'China Eastern', 'MU506', 'Kuala Lumpur', 'Shanghai', '2026-03-10 09:20:00', '2026-03-10 15:20:00', 720.00, 100, 'Premium Economy', 'Asia'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MU506');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'British Airways', 'BA084', 'Kuala Lumpur', 'London', '2026-03-11 23:30:00', '2026-03-12 06:45:00', 3200.00, 70, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'BA084');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Air France', 'AF273', 'Kuala Lumpur', 'Paris', '2026-03-12 22:40:00', '2026-03-13 06:20:00', 3300.00, 60, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AF273');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Lufthansa', 'LH777', 'Kuala Lumpur', 'Frankfurt', '2026-03-13 23:20:00', '2026-03-14 06:30:00', 3400.00, 55, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'LH777');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'KLM', 'KL811', 'Kuala Lumpur', 'Amsterdam', '2026-03-14 23:50:00', '2026-03-15 07:05:00', 3350.00, 50, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'KL811');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'ITA Airways', 'AZ739', 'Kuala Lumpur', 'Rome', '2026-03-15 22:20:00', '2026-03-16 05:55:00', 3250.00, 45, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AZ739');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Iberia', 'IB671', 'Kuala Lumpur', 'Madrid', '2026-03-16 23:10:00', '2026-03-17 06:20:00', 3200.00, 50, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'IB671');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'United Airlines', 'UA030', 'Kuala Lumpur', 'San Francisco', '2026-03-19 22:00:00', '2026-03-20 19:30:00', 4200.00, 45, 'Economy', 'America'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'UA030');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Delta', 'DL523', 'Kuala Lumpur', 'New York', '2026-03-20 21:35:00', '2026-03-21 19:20:00', 4800.00, 40, 'Economy', 'America'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'DL523');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Air Canada', 'AC020', 'Kuala Lumpur', 'Vancouver', '2026-03-21 22:10:00', '2026-03-22 19:35:00', 4600.00, 38, 'Premium Economy', 'America'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AC020');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Singapore Airlines', 'SQ036', 'Kuala Lumpur', 'Los Angeles', '2026-03-23 20:45:00', '2026-03-24 18:30:00', 5200.00, 30, 'Business', 'America'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'SQ036');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Malaysia Airlines', 'MH145', 'Kuala Lumpur', 'Sydney', '2026-03-11 09:05:00', '2026-03-11 17:40:00', 1700.00, 70, 'Economy', 'Australia/New Zealand'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MH145');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'AirAsia', 'AK610', 'Kuala Lumpur', 'Perth', '2026-03-12 07:45:00', '2026-03-12 13:20:00', 880.00, 100, 'Economy', 'Australia/New Zealand'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AK610');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Qantas', 'QF584', 'Kuala Lumpur', 'Melbourne', '2026-03-13 10:30:00', '2026-03-13 18:25:00', 1950.00, 55, 'Premium Economy', 'Australia/New Zealand'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'QF584');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Air New Zealand', 'NZ025', 'Kuala Lumpur', 'Auckland', '2026-03-15 09:15:00', '2026-03-15 19:45:00', 2300.00, 40, 'Premium Economy', 'Australia/New Zealand'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'NZ025');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'British Airways', 'BA092', 'Kuala Lumpur', 'London', '2026-03-18 23:40:00', '2026-03-19 06:55:00', 3350.00, 65, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'BA092');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Malaysia Airlines', 'MH004', 'Kuala Lumpur', 'London', '2026-03-22 10:10:00', '2026-03-22 17:05:00', 3450.00, 60, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'MH004');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Air France', 'AF281', 'Kuala Lumpur', 'Paris', '2026-03-19 22:50:00', '2026-03-20 06:30:00', 3320.00, 58, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AF281');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'KLM', 'KL820', 'Kuala Lumpur', 'Amsterdam', '2026-03-20 23:15:00', '2026-03-21 06:45:00', 3380.00, 52, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'KL820');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Lufthansa', 'LH785', 'Kuala Lumpur', 'Frankfurt', '2026-03-21 23:55:00', '2026-03-22 06:50:00', 3420.00, 50, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'LH785');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'ITA Airways', 'AZ741', 'Kuala Lumpur', 'Rome', '2026-03-22 22:10:00', '2026-03-23 05:40:00', 3280.00, 45, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AZ741');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Iberia', 'IB679', 'Kuala Lumpur', 'Madrid', '2026-03-23 23:05:00', '2026-03-24 06:15:00', 3250.00, 48, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'IB679');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'SWISS', 'LX190', 'Kuala Lumpur', 'Zurich', '2026-03-24 23:25:00', '2026-03-25 06:35:00', 3700.00, 40, 'Business', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'LX190');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Austrian Airlines', 'OS678', 'Kuala Lumpur', 'Vienna', '2026-03-25 22:55:00', '2026-03-26 06:25:00', 3150.00, 55, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'OS678');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Vueling', 'VY894', 'Kuala Lumpur', 'Barcelona', '2026-03-26 23:10:00', '2026-03-27 06:30:00', 3180.00, 50, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'VY894');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Turkish Airlines', 'TK068', 'Kuala Lumpur', 'Istanbul', '2026-03-27 20:45:00', '2026-03-28 02:20:00', 2850.00, 70, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'TK068');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'British Airways', 'BA107', 'Jakarta', 'London', '2026-03-18 21:55:00', '2026-03-19 05:40:00', 3300.00, 50, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'BA107');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Air France', 'AF260', 'Jakarta', 'Paris', '2026-03-19 22:35:00', '2026-03-20 06:15:00', 3280.00, 48, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AF260');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'KLM', 'KL805', 'Jakarta', 'Amsterdam', '2026-03-20 23:40:00', '2026-03-21 06:55:00', 3360.00, 45, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'KL805');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Lufthansa', 'LH762', 'Jakarta', 'Frankfurt', '2026-03-21 23:50:00', '2026-03-22 06:40:00', 3400.00, 42, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'LH762');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'ITA Airways', 'AZ715', 'Jakarta', 'Rome', '2026-03-22 22:25:00', '2026-03-23 05:55:00', 3260.00, 40, 'Premium Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'AZ715');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Iberia', 'IB655', 'Jakarta', 'Madrid', '2026-03-23 23:15:00', '2026-03-24 06:25:00', 3220.00, 44, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'IB655');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'SWISS', 'LX172', 'Jakarta', 'Zurich', '2026-03-24 23:30:00', '2026-03-25 06:40:00', 3650.00, 35, 'Business', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'LX172');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Austrian Airlines', 'OS644', 'Jakarta', 'Vienna', '2026-03-25 22:45:00', '2026-03-26 06:10:00', 3120.00, 45, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'OS644');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Vueling', 'VY870', 'Jakarta', 'Barcelona', '2026-03-26 23:05:00', '2026-03-27 06:20:00', 3160.00, 42, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'VY870');

INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats, cabin_class, region)
SELECT 'Turkish Airlines', 'TK075', 'Jakarta', 'Istanbul', '2026-03-27 20:30:00', '2026-03-28 02:05:00', 2820.00, 60, 'Economy', 'Europe'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM flights WHERE flight_number = 'TK075');

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

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Seminyak Coast Hotel', 'Bali', 'Asia', 'Jl. Petitenget No.88', 4, 320.00, 'Coastal hotel near Seminyak beach clubs.', 'Pool, Spa, WiFi', 28, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Seminyak Coast Hotel' AND location = 'Bali');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Ubud Valley Retreat', 'Bali', 'Asia', 'Jl. Tegallalang No.12', 5, 420.00, 'Hillside retreat overlooking rice terraces.', 'Pool, Spa, Breakfast, WiFi', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Ubud Valley Retreat' AND location = 'Bali');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Orchard Grand Hotel', 'Singapore', 'Asia', '201 Orchard Road', 4, 380.00, 'Central stay near Orchard shopping belt.', 'WiFi, Pool, Gym', 24, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Orchard Grand Hotel' AND location = 'Singapore');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'KL Skyline Suites', 'Kuala Lumpur', 'Asia', '88 Jalan Sultan Ismail', 4, 240.00, 'City-center suites with skyline views.', 'WiFi, Gym, Breakfast', 30, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'KL Skyline Suites' AND location = 'Kuala Lumpur');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Siam Riverside Hotel', 'Bangkok', 'Asia', '12 Chao Phraya Rd', 4, 230.00, 'Riverside hotel with sunset decks.', 'Pool, Spa, WiFi', 26, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Siam Riverside Hotel' AND location = 'Bangkok');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Sukhumvit Garden Inn', 'Bangkok', 'Asia', '45 Sukhumvit Soi 24', 3, 190.00, 'Comfortable stay near BTS and cafes.', 'WiFi, Breakfast', 34, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Sukhumvit Garden Inn' AND location = 'Bangkok');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Jakarta Central Plaza Hotel', 'Jakarta', 'Asia', '20 Jalan Thamrin', 4, 210.00, 'Business-friendly hotel in central Jakarta.', 'WiFi, Gym, Breakfast', 28, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Jakarta Central Plaza Hotel' AND location = 'Jakarta');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Menteng Heritage Suites', 'Jakarta', 'Asia', '9 Jalan Cikini', 4, 220.00, 'Heritage-style suites near Menteng district.', 'WiFi, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Menteng Heritage Suites' AND location = 'Jakarta');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Shibuya Crossing Hotel', 'Tokyo', 'Asia', '4-2 Shibuya', 4, 320.00, 'Steps from Shibuya Station with city views.', 'WiFi, Gym, Restaurant', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Shibuya Crossing Hotel' AND location = 'Tokyo');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Asakusa Lantern Inn', 'Tokyo', 'Asia', '1-5 Asakusa', 3, 210.00, 'Quiet stay near temples and riverside walks.', 'WiFi, Breakfast', 26, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Asakusa Lantern Inn' AND location = 'Tokyo');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Gangnam City Hotel', 'Seoul', 'Asia', '77 Teheran-ro', 4, 260.00, 'Modern rooms in Gangnam business district.', 'WiFi, Gym, Breakfast', 24, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Gangnam City Hotel' AND location = 'Seoul');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Kowloon Harbour Hotel', 'Hong Kong', 'Asia', '18 Salisbury Rd', 4, 300.00, 'Harbourfront hotel near Tsim Sha Tsui.', 'WiFi, Pool, Gym', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Kowloon Harbour Hotel' AND location = 'Hong Kong');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Daan Park Hotel', 'Taipei', 'Asia', '22 Xinsheng South Rd', 3, 180.00, 'Simple stay near Daan Park and metro.', 'WiFi, Breakfast', 30, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Daan Park Hotel' AND location = 'Taipei');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Makati Business Hotel', 'Manila', 'Asia', '120 Ayala Ave', 4, 200.00, 'Business district hotel with easy transit.', 'WiFi, Gym, Breakfast', 26, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Makati Business Hotel' AND location = 'Manila');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Saigon River Hotel', 'Ho Chi Minh City', 'Asia', '15 Nguyen Hue Blvd', 4, 210.00, 'Riverfront stay near downtown markets.', 'WiFi, Pool, Breakfast', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Saigon River Hotel' AND location = 'Ho Chi Minh City');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Pudong Skyline Hotel', 'Shanghai', 'Asia', '88 Lujiazui Rd', 4, 240.00, 'Skyline views in Pudong district.', 'WiFi, Gym, Restaurant', 24, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Pudong Skyline Hotel' AND location = 'Shanghai');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'London Thames View Hotel', 'London', 'Europe', '15 Southbank Way', 4, 290.00, 'Thames-side stay near major landmarks.', 'WiFi, Gym, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'London Thames View Hotel' AND location = 'London');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Paris Champs Elysees Hotel', 'Paris', 'Europe', '32 Avenue des Champs Elysees', 4, 310.00, 'Classic Paris stay near boutiques and cafes.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Paris Champs Elysees Hotel' AND location = 'Paris');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Frankfurt Messe Hotel', 'Frankfurt', 'Europe', '10 Messeplatz', 4, 220.00, 'Convenient to the exhibition center.', 'WiFi, Gym, Breakfast', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Frankfurt Messe Hotel' AND location = 'Frankfurt');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Amsterdam Jordaan Inn', 'Amsterdam', 'Europe', '5 Prinsengracht', 4, 240.00, 'Canal-side rooms in Jordaan district.', 'WiFi, Breakfast', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Amsterdam Jordaan Inn' AND location = 'Amsterdam');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Rome Piazza Hotel', 'Rome', 'Europe', '14 Via del Corso', 4, 230.00, 'Walkable to major piazzas and sights.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Rome Piazza Hotel' AND location = 'Rome');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Madrid Gran Via Hotel', 'Madrid', 'Europe', '100 Gran Via', 4, 220.00, 'Central stay near shopping and theatres.', 'WiFi, Gym, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Madrid Gran Via Hotel' AND location = 'Madrid');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'San Francisco Bayview Hotel', 'San Francisco', 'America', '50 Embarcadero', 4, 280.00, 'Bayfront hotel with transit nearby.', 'WiFi, Gym, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'San Francisco Bayview Hotel' AND location = 'San Francisco');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'New York Central Suites', 'New York', 'America', '250 W 53rd St', 4, 320.00, 'Midtown suites near Broadway.', 'WiFi, Gym', 24, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'New York Central Suites' AND location = 'New York');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Vancouver Waterfront Hotel', 'Vancouver', 'America', '200 Waterfront Rd', 4, 260.00, 'Harbour views with easy airport link.', 'WiFi, Gym, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Vancouver Waterfront Hotel' AND location = 'Vancouver');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Los Angeles Downtown Hotel', 'Los Angeles', 'America', '1200 Grand Ave', 4, 270.00, 'Downtown base near museums and dining.', 'WiFi, Pool, Gym', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Los Angeles Downtown Hotel' AND location = 'Los Angeles');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Sydney Harbour Central Hotel', 'Sydney', 'Australia/New Zealand', '18 Circular Quay', 4, 280.00, 'Harbour views near the Opera House.', 'WiFi, Pool, Gym', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Sydney Harbour Central Hotel' AND location = 'Sydney');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Perth Riverside Hotel', 'Perth', 'Australia/New Zealand', '55 Riverside Dr', 4, 210.00, 'Riverside stay with city access.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Perth Riverside Hotel' AND location = 'Perth');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Melbourne Docklands Hotel', 'Melbourne', 'Australia/New Zealand', '9 Harbour Esplanade', 4, 230.00, 'Docklands hotel near CBD and stadiums.', 'WiFi, Gym, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Melbourne Docklands Hotel' AND location = 'Melbourne');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Auckland Sky Harbour Hotel', 'Auckland', 'Australia/New Zealand', '22 Viaduct Harbour', 4, 240.00, 'Harbourfront rooms by the viaduct.', 'WiFi, Pool, Gym', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Auckland Sky Harbour Hotel' AND location = 'Auckland');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'London Westminster Hotel', 'London', 'Europe', '8 Bridge St', 4, 300.00, 'Walk to Parliament and riverside paths.', 'WiFi, Gym, Breakfast', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'London Westminster Hotel' AND location = 'London');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'London City Loft Hotel', 'London', 'Europe', '55 Bishopsgate', 4, 280.00, 'Modern rooms in the financial district.', 'WiFi, Gym', 24, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'London City Loft Hotel' AND location = 'London');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Paris Louvre Stay', 'Paris', 'Europe', '6 Rue de lAmiral', 4, 295.00, 'Boutique stay near the Louvre district.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Paris Louvre Stay' AND location = 'Paris');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Paris Montmartre Hotel', 'Paris', 'Europe', '22 Rue Lepic', 3, 210.00, 'Cozy rooms near Montmartre cafes.', 'WiFi, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Paris Montmartre Hotel' AND location = 'Paris');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Rome Colosseum Suites', 'Rome', 'Europe', '18 Via Labicana', 4, 240.00, 'Steps from the Colosseum and metro.', 'WiFi, Breakfast', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Rome Colosseum Suites' AND location = 'Rome');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Rome Trastevere Garden Hotel', 'Rome', 'Europe', '30 Via della Lungaretta', 3, 200.00, 'Quiet garden courtyard in Trastevere.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Rome Trastevere Garden Hotel' AND location = 'Rome');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Amsterdam Central Canal Hotel', 'Amsterdam', 'Europe', '40 Herengracht', 4, 260.00, 'Canal views near the Central Station.', 'WiFi, Breakfast', 14, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Amsterdam Central Canal Hotel' AND location = 'Amsterdam');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Amsterdam Museum Quarter Inn', 'Amsterdam', 'Europe', '12 Museumplein', 4, 250.00, 'Steps from museums and parks.', 'WiFi, Breakfast', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Amsterdam Museum Quarter Inn' AND location = 'Amsterdam');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Frankfurt Skyline Hotel', 'Frankfurt', 'Europe', '55 Mainzer Landstrasse', 4, 230.00, 'Business district hotel with skyline views.', 'WiFi, Gym, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Frankfurt Skyline Hotel' AND location = 'Frankfurt');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Frankfurt Airport Express Hotel', 'Frankfurt', 'Europe', '7 Flughafenstrasse', 3, 180.00, 'Quick airport access for early flights.', 'WiFi, Breakfast', 26, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Frankfurt Airport Express Hotel' AND location = 'Frankfurt');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Madrid Plaza Hotel', 'Madrid', 'Europe', '12 Plaza Mayor', 4, 220.00, 'Central stay near Plaza Mayor.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Madrid Plaza Hotel' AND location = 'Madrid');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Madrid Retiro Park Hotel', 'Madrid', 'Europe', '5 Calle de Ibiza', 3, 190.00, 'Walk to Retiro Park and museums.', 'WiFi, Breakfast', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Madrid Retiro Park Hotel' AND location = 'Madrid');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Barcelona Gothic Quarter Hotel', 'Barcelona', 'Europe', '9 Carrer del Bisbe', 4, 230.00, 'Historic quarter stay near the cathedral.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Barcelona Gothic Quarter Hotel' AND location = 'Barcelona');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Barcelona Beachside Suites', 'Barcelona', 'Europe', '70 Passeig Maritim', 4, 240.00, 'Beachfront suites near Barceloneta.', 'WiFi, Pool', 20, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Barcelona Beachside Suites' AND location = 'Barcelona');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Berlin Alexanderplatz Hotel', 'Berlin', 'Europe', '2 Alexanderplatz', 4, 220.00, 'Central hotel near TV tower and transit.', 'WiFi, Gym, Breakfast', 22, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Berlin Alexanderplatz Hotel' AND location = 'Berlin');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Berlin Tiergarten Lodge', 'Berlin', 'Europe', '15 Tiergartenstrasse', 3, 180.00, 'Green stay near Tiergarten park.', 'WiFi, Breakfast', 24, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Berlin Tiergarten Lodge' AND location = 'Berlin');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Zurich Bahnhofstrasse Hotel', 'Zurich', 'Europe', '88 Bahnhofstrasse', 5, 380.00, 'Luxury stay on the main shopping street.', 'WiFi, Spa, Breakfast', 12, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Zurich Bahnhofstrasse Hotel' AND location = 'Zurich');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Zurich Old Town Inn', 'Zurich', 'Europe', '6 Niederdorfstrasse', 4, 260.00, 'Old town charm near the river.', 'WiFi, Breakfast', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Zurich Old Town Inn' AND location = 'Zurich');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Vienna Ring Boulevard Hotel', 'Vienna', 'Europe', '20 Ringstrasse', 4, 230.00, 'Elegant stay near the opera house.', 'WiFi, Breakfast', 18, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Vienna Ring Boulevard Hotel' AND location = 'Vienna');

INSERT INTO hotels (name, location, region, address, stars, price_per_night, description, amenities, available_rooms, image_url)
SELECT 'Vienna Palace Courtyard Hotel', 'Vienna', 'Europe', '5 Hofburg Platz', 4, 240.00, 'Historic courtyard hotel by the palace.', 'WiFi, Breakfast', 16, NULL
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM hotels WHERE name = 'Vienna Palace Courtyard Hotel' AND location = 'Vienna');

UPDATE flights
SET region = 'Asia'
WHERE region IS NULL
  AND (destination IN ('Bangkok', 'Sydney', 'Tokyo') OR origin IN ('Kuala Lumpur', 'Singapore'));

UPDATE hotels
SET region = 'Asia'
WHERE region IS NULL
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
