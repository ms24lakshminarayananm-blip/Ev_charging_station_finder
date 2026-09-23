package com.evcharging.dao;

import com.evcharging.model.Payment;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment p) {
        String sql = "INSERT INTO payments (booking_id, user_id, transaction_id, payment_method, amount, payment_status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getBookingId());
            ps.setInt(2, p.getUserId());
            ps.setString(3, p.getTransactionId());
            ps.setString(4, p.getPaymentMethod());
            ps.setBigDecimal(5, p.getAmount());
            ps.setString(6, p.getPaymentStatus() != null ? p.getPaymentStatus() : "SUCCESS");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getByBookingId(int bookingId) {
        String sql = "SELECT p.*, b.booking_number, u.name AS user_name, s.name AS station_name " +
                     "FROM payments p " +
                     "JOIN bookings b ON p.booking_id = b.id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "JOIN stations s ON b.station_id = s.id " +
                     "WHERE p.booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, b.booking_number, u.name AS user_name, s.name AS station_name " +
                     "FROM payments p " +
                     "JOIN bookings b ON p.booking_id = b.id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "JOIN stations s ON b.station_id = s.id " +
                     "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));

        try {
            p.setBookingNumber(rs.getString("booking_number"));
            p.setUserName(rs.getString("user_name"));
            p.setStationName(rs.getString("station_name"));
        } catch (SQLException ignored) {}

        return p;
    }
}
