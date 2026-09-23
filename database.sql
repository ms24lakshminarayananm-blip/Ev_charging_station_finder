-- =====================================================================
-- EV CHARGING STATION FINDER SYSTEM - DATABASE SCHEMA
-- Database: ev_charging_db
-- 3rd Year CSE Software Engineering College Project
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `ev_charging_db`;
USE `ev_charging_db`;

-- Drop existing tables in reverse dependency order if any
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `waiting_list`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `charging_slots`;
DROP TABLE IF EXISTS `stations`;
DROP TABLE IF EXISTS `coupons`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `station_owners`;
DROP TABLE IF EXISTS `admin_users`;

-- ---------------------------------------------------------------------
-- 1. Table: admin_users
-- ---------------------------------------------------------------------
CREATE TABLE `admin_users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 2. Table: station_owners
-- ---------------------------------------------------------------------
CREATE TABLE `station_owners` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) NOT NULL,
    `business_name` VARCHAR(150),
    `address` TEXT,
    `status` VARCHAR(20) DEFAULT 'ACTIVE',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 3. Table: users
-- ---------------------------------------------------------------------
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) NOT NULL,
    `vehicle_number` VARCHAR(30),
    `vehicle_model` VARCHAR(50),
    `status` VARCHAR(20) DEFAULT 'ACTIVE',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 4. Table: stations
-- ---------------------------------------------------------------------
CREATE TABLE `stations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `owner_id` INT NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `address` TEXT NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `state` VARCHAR(100) NOT NULL,
    `pincode` VARCHAR(20) NOT NULL,
    `latitude` DECIMAL(10, 8) DEFAULT 0.00000000,
    `longitude` DECIMAL(11, 8) DEFAULT 0.00000000,
    `charger_types` VARCHAR(150) NOT NULL, -- e.g. 'Type 2 AC, CCS2 Fast DC'
    `power_rating` VARCHAR(50) DEFAULT '50 kW',
    `price_per_unit` DECIMAL(10, 2) NOT NULL, -- rate per kWh / hour
    `total_slots` INT NOT NULL DEFAULT 4,
    `amenities` TEXT, -- e.g. 'Cafe, Restroom, WiFi, Parking'
    `approval_status` VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_station_owner` FOREIGN KEY (`owner_id`) REFERENCES `station_owners` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 5. Table: charging_slots
-- ---------------------------------------------------------------------
CREATE TABLE `charging_slots` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `station_id` INT NOT NULL,
    `slot_number` VARCHAR(20) NOT NULL,
    `charger_type` VARCHAR(50) NOT NULL,
    `power_output` VARCHAR(50) DEFAULT '50 kW',
    `status` VARCHAR(20) DEFAULT 'AVAILABLE', -- 'AVAILABLE', 'OCCUPIED', 'MAINTENANCE'
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_slot_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 6. Table: bookings
-- ---------------------------------------------------------------------
CREATE TABLE `bookings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `booking_number` VARCHAR(50) NOT NULL UNIQUE,
    `user_id` INT NOT NULL,
    `station_id` INT NOT NULL,
    `slot_id` INT NOT NULL,
    `booking_date` DATE NOT NULL,
    `start_time` VARCHAR(20) NOT NULL,
    `end_time` VARCHAR(20) NOT NULL,
    `total_hours` DECIMAL(4, 2) DEFAULT 1.00,
    `total_amount` DECIMAL(10, 2) NOT NULL,
    `discount_amount` DECIMAL(10, 2) DEFAULT 0.00,
    `final_amount` DECIMAL(10, 2) NOT NULL,
    `status` VARCHAR(20) DEFAULT 'BOOKED', -- 'BOOKED', 'CANCELLED', 'COMPLETED'
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_booking_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_booking_slot` FOREIGN KEY (`slot_id`) REFERENCES `charging_slots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 7. Table: waiting_list
-- ---------------------------------------------------------------------
CREATE TABLE `waiting_list` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `station_id` INT NOT NULL,
    `desired_date` DATE NOT NULL,
    `desired_time` VARCHAR(20) NOT NULL,
    `status` VARCHAR(20) DEFAULT 'WAITING', -- 'WAITING', 'NOTIFIED', 'EXPIRED'
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_waiting_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_waiting_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 8. Table: payments
-- ---------------------------------------------------------------------
CREATE TABLE `payments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `booking_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `transaction_id` VARCHAR(100) NOT NULL UNIQUE,
    `payment_method` VARCHAR(30) NOT NULL, -- 'UPI', 'WALLET', 'CARD'
    `amount` DECIMAL(10, 2) NOT NULL,
    `payment_status` VARCHAR(20) DEFAULT 'SUCCESS', -- 'SUCCESS', 'FAILED'
    `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_payment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 9. Table: coupons
-- ---------------------------------------------------------------------
CREATE TABLE `coupons` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `discount_percentage` INT NOT NULL,
    `max_discount` DECIMAL(10, 2) DEFAULT 500.00,
    `min_amount` DECIMAL(10, 2) DEFAULT 100.00,
    `valid_until` DATE DEFAULT '2030-12-31',
    `is_active` TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- 10. Table: reviews
-- ---------------------------------------------------------------------
CREATE TABLE `reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `station_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `rating` INT NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
    `review_text` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_review_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================================
-- SAMPLE DATA & DEMO LOGIN ACCOUNTS
-- =====================================================================

-- ---------------------------------------------------------------------
-- DEMO ACCOUNTS (CLEARLY MARKED)
-- Admin: admin / admin123
-- User:  user@gmail.com / user123
-- Owner: owner@gmail.com / owner123
-- ---------------------------------------------------------------------

-- DEMO ADMIN ACCOUNT
INSERT INTO `admin_users` (`id`, `username`, `password`, `email`, `full_name`) VALUES
(1, 'admin', 'admin123', 'admin@evcharge.com', 'System Administrator');

-- DEMO STATION OWNER ACCOUNTS
INSERT INTO `station_owners` (`id`, `name`, `email`, `password`, `phone`, `business_name`, `address`, `status`) VALUES
(1, 'Demo Station Owner', 'owner@gmail.com', 'owner123', '9876543210', 'VoltCharge Infra Pvt Ltd', 'Tech Park Road, Sector 5', 'ACTIVE'),
(2, 'Rajesh Sharma', 'rajesh@powerpoint.in', 'owner123', '9812345678', 'PowerPoint Hubs', 'Ring Road Junction, City Center', 'ACTIVE');

-- DEMO USER ACCOUNTS
INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `vehicle_number`, `vehicle_model`, `status`) VALUES
(1, 'Demo EV User', 'user@gmail.com', 'user123', '9123456780', 'KA-01-EV-2024', 'Tata Nexon EV Max', 'ACTIVE'),
(2, 'Priya Patel', 'priya@gmail.com', 'user123', '9234567891', 'MH-02-EV-9876', 'MG ZS EV', 'ACTIVE');

-- DEMO COUPONS
INSERT INTO `coupons` (`id`, `code`, `discount_percentage`, `max_discount`, `min_amount`, `valid_until`, `is_active`) VALUES
(1, 'EV10', 10, 100.00, 100.00, '2030-12-31', 1),
(2, 'SAVE20', 20, 200.00, 200.00, '2030-12-31', 1),
(3, 'WELCOME50', 50, 250.00, 300.00, '2030-12-31', 1);

-- DEMO CHARGING STATIONS (At least 5 fictional stations, 4 Approved and 1 Pending for Admin Approval demo)
INSERT INTO `stations` (`id`, `owner_id`, `name`, `address`, `city`, `state`, `pincode`, `latitude`, `longitude`, `charger_types`, `power_rating`, `price_per_unit`, `total_slots`, `amenities`, `approval_status`) VALUES
(1, 1, 'GreenVolt Fast Charging Hub', 'Opposite Phoenix Mall, Whitefield Main Road', 'Bengaluru', 'Karnataka', '560066', 12.99820000, 77.69740000, 'CCS2 Fast DC, Type 2 AC', '60 kW DC', 18.50, 4, 'Cafe, Free WiFi, Clean Restroom, 24/7 Security', 'APPROVED'),
(2, 1, 'EcoCharge Express Station', 'Near Metro Pillar 142, Indiranagar 100ft Road', 'Bengaluru', 'Karnataka', '560038', 12.97190000, 77.64120000, 'CCS2 Fast DC, CHAdeMO', '50 kW DC', 16.00, 3, 'Convenience Store, Restroom, Air Pump', 'APPROVED'),
(3, 2, 'Nexus Supercharge Terminal', 'Cyber Towers Intersection, Hitech City', 'Hyderabad', 'Telangana', '500081', 17.45040000, 78.38080000, 'CCS2 Fast DC, Type 2 AC, Bharat DC001', '120 kW Ultra-Fast', 22.00, 4, 'Food Court, Coffee Shop, Waiting Lounge, WiFi', 'APPROVED'),
(4, 2, 'CityWatt Urban EV Point', 'Next to Express Avenue Mall, Anna Salai', 'Chennai', 'Tamil Nadu', '600002', 13.05870000, 80.26420000, 'Type 2 AC, CCS2 Fast DC', '30 kW Fast', 14.50, 3, 'Restroom, Drinking Water, Covered Parking', 'APPROVED'),
(5, 1, 'BluPulse Highway Mega Station', 'Mumbai-Pune Expressway Toll Plaza KM 42', 'Pune', 'Maharashtra', '410506', 18.75200000, 73.40800000, 'CCS2 Fast DC, CHAdeMO, Type 2 AC', '150 kW Supercharge', 20.00, 4, 'Highway Restaurant, EV Diagnostics, Rest Area', 'PENDING');

-- DEMO CHARGING SLOTS
-- Station 1 (GreenVolt) Slots
INSERT INTO `charging_slots` (`id`, `station_id`, `slot_number`, `charger_type`, `power_output`, `status`) VALUES
(1, 1, 'Slot A1', 'CCS2 Fast DC', '60 kW', 'AVAILABLE'),
(2, 1, 'Slot A2', 'CCS2 Fast DC', '60 kW', 'AVAILABLE'),
(3, 1, 'Slot A3', 'Type 2 AC', '22 kW', 'AVAILABLE'),
(4, 1, 'Slot A4', 'Type 2 AC', '22 kW', 'OCCUPIED');

-- Station 2 (EcoCharge) Slots
INSERT INTO `charging_slots` (`id`, `station_id`, `slot_number`, `charger_type`, `power_output`, `status`) VALUES
(5, 2, 'Slot B1', 'CCS2 Fast DC', '50 kW', 'AVAILABLE'),
(6, 2, 'Slot B2', 'CCS2 Fast DC', '50 kW', 'AVAILABLE'),
(7, 2, 'Slot B3', 'CHAdeMO', '50 kW', 'MAINTENANCE');

-- Station 3 (Nexus Supercharge) Slots
INSERT INTO `charging_slots` (`id`, `station_id`, `slot_number`, `charger_type`, `power_output`, `status`) VALUES
(8, 3, 'Slot C1', 'CCS2 Fast DC', '120 kW', 'AVAILABLE'),
(9, 3, 'Slot C2', 'CCS2 Fast DC', '120 kW', 'AVAILABLE'),
(10, 3, 'Slot C3', 'Type 2 AC', '22 kW', 'AVAILABLE'),
(11, 3, 'Slot C4', 'Bharat DC001', '15 kW', 'AVAILABLE');

-- Station 4 (CityWatt) Slots
INSERT INTO `charging_slots` (`id`, `station_id`, `slot_number`, `charger_type`, `power_output`, `status`) VALUES
(12, 4, 'Slot D1', 'Type 2 AC', '22 kW', 'AVAILABLE'),
(13, 4, 'Slot D2', 'Type 2 AC', '22 kW', 'AVAILABLE'),
(14, 4, 'Slot D3', 'CCS2 Fast DC', '30 kW', 'AVAILABLE');

-- Station 5 (BluPulse - Pending Station) Slots
INSERT INTO `charging_slots` (`id`, `station_id`, `slot_number`, `charger_type`, `power_output`, `status`) VALUES
(15, 5, 'Slot E1', 'CCS2 Fast DC', '150 kW', 'AVAILABLE'),
(16, 5, 'Slot E2', 'CCS2 Fast DC', '150 kW', 'AVAILABLE'),
(17, 5, 'Slot E3', 'CHAdeMO', '50 kW', 'AVAILABLE'),
(18, 5, 'Slot E4', 'Type 2 AC', '22 kW', 'AVAILABLE');

-- SAMPLE REVIEWS
INSERT INTO `reviews` (`id`, `station_id`, `user_id`, `rating`, `review_text`) VALUES
(1, 1, 1, 5, 'Excellent charging speed! The lounge and cafe while waiting were super convenient.'),
(2, 1, 2, 4, 'Very smooth booking process and CCS2 charger worked seamlessly with my MG ZS EV.'),
(3, 2, 1, 4, 'Clean area and easy to locate right off Indiranagar 100ft road.'),
(4, 3, 2, 5, 'Ultra fast 120kW charging! Topped up 20% to 80% in just 25 minutes.');

-- SAMPLE BOOKING & PAYMENT FOR USER 2
INSERT INTO `bookings` (`id`, `booking_number`, `user_id`, `station_id`, `slot_id`, `booking_date`, `start_time`, `end_time`, `total_hours`, `total_amount`, `discount_amount`, `final_amount`, `status`) VALUES
(1, 'EVBK-2026-0001', 2, 1, 4, CURDATE(), '10:00 AM', '11:00 AM', 1.00, 370.00, 37.00, 333.00, 'COMPLETED');

INSERT INTO `payments` (`id`, `booking_id`, `user_id`, `transaction_id`, `payment_method`, `amount`, `payment_status`, `payment_date`) VALUES
(1, 1, 2, 'TXN-EV-98234123', 'UPI', 333.00, 'SUCCESS', CURRENT_TIMESTAMP);
