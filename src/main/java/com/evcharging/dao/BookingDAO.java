package com.evcharging.dao;

import com.evcharging.model.Booking;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public int createBooking(Booking b) {
        String sql = "INSERT INTO bookings (booking_number, user_id, station_id, slot_id, booking_date, start_time, end_time, total_hours, total_amount, discount_amount, final_amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'BOOKED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, b.getBookingNumber());
            ps.setInt(2, b.getUserId());
            ps.setInt(3, b.getStationId());
            ps.setInt(4, b.getSlotId());
            ps.setDate(5, b.getBookingDate());
            ps.setString(6, b.getStartTime());
            ps.setString(7, b.getEndTime());
            ps.setBigDecimal(8, b.getTotalHours());
            ps.setBigDecimal(9, b.getTotalAmount());
            ps.setBigDecimal(10, b.getDiscountAmount());
            ps.setBigDecimal(11, b.getFinalAmount());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean isSlotAvailable(int slotId, Date date, String startTime) {
        String sql = "SELECT id FROM bookings WHERE slot_id = ? AND booking_date = ? AND start_time = ? AND status = 'BOOKED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            ps.setDate(2, date);
            ps.setString(3, startTime);
            try (ResultSet rs = ps.executeQuery()) {
                return !rs.next(); // true if no conflicting booking exists
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Booking getById(int id) {
        String sql = getBaseSelectQuery() + " WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Booking getByBookingNumber(String bookingNumber) {
        String sql = getBaseSelectQuery() + " WHERE b.booking_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Booking> getByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = getBaseSelectQuery() + " WHERE b.user_id = ? ORDER BY b.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getByOwnerId(int ownerId) {
        List<Booking> list = new ArrayList<>();
        String sql = getBaseSelectQuery() + " WHERE s.owner_id = ? ORDER BY b.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = getBaseSelectQuery() + " ORDER BY b.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBooking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean cancelBooking(int bookingId, int userId) {
        String sql = "UPDATE bookings SET status = 'CANCELLED' WHERE id = ? AND user_id = ? AND status = 'BOOKED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalBookingsCount() {
        String sql = "SELECT COUNT(*) FROM bookings";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue() {
        String sql = "SELECT IFNULL(SUM(final_amount), 0) FROM bookings WHERE status IN ('BOOKED', 'COMPLETED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private String getBaseSelectQuery() {
        return "SELECT b.*, u.name AS user_name, u.email AS user_email, u.phone AS user_phone, u.vehicle_number AS user_vehicle_number, " +
               "s.name AS station_name, s.address AS station_address, s.city AS station_city, " +
               "cs.slot_number, cs.charger_type " +
               "FROM bookings b " +
               "JOIN users u ON b.user_id = u.id " +
               "JOIN stations s ON b.station_id = s.id " +
               "JOIN charging_slots cs ON b.slot_id = cs.id";
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setBookingNumber(rs.getString("booking_number"));
        b.setUserId(rs.getInt("user_id"));
        b.setStationId(rs.getInt("station_id"));
        b.setSlotId(rs.getInt("slot_id"));
        b.setBookingDate(rs.getDate("booking_date"));
        b.setStartTime(rs.getString("start_time"));
        b.setEndTime(rs.getString("end_time"));
        b.setTotalHours(rs.getBigDecimal("total_hours"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        b.setFinalAmount(rs.getBigDecimal("final_amount"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            b.setUserName(rs.getString("user_name"));
            b.setUserEmail(rs.getString("user_email"));
            b.setUserPhone(rs.getString("user_phone"));
            b.setUserVehicleNumber(rs.getString("user_vehicle_number"));
            b.setStationName(rs.getString("station_name"));
            b.setStationAddress(rs.getString("station_address"));
            b.setStationCity(rs.getString("station_city"));
            b.setSlotNumber(rs.getString("slot_number"));
            b.setChargerType(rs.getString("charger_type"));
        } catch (SQLException ignored) {}

        return b;
    }
}
