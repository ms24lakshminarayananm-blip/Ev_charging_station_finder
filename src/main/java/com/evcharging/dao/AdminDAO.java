package com.evcharging.dao;

import com.evcharging.model.Admin;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class AdminDAO {

    public Admin login(String username, String password) {
        String sql = "SELECT * FROM admin_users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setId(rs.getInt("id"));
                    a.setUsername(rs.getString("username"));
                    a.setPassword(rs.getString("password"));
                    a.setEmail(rs.getString("email"));
                    a.setFullName(rs.getString("full_name"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            stats.put("totalUsers", getCount(conn, "SELECT COUNT(*) FROM users"));
            stats.put("totalOwners", getCount(conn, "SELECT COUNT(*) FROM station_owners"));
            stats.put("totalStations", getCount(conn, "SELECT COUNT(*) FROM stations WHERE approval_status = 'APPROVED'"));
            stats.put("pendingStations", getCount(conn, "SELECT COUNT(*) FROM stations WHERE approval_status = 'PENDING'"));
            stats.put("totalBookings", getCount(conn, "SELECT COUNT(*) FROM bookings"));
            stats.put("totalReviews", getCount(conn, "SELECT COUNT(*) FROM reviews"));

            String revSql = "SELECT IFNULL(SUM(final_amount), 0) FROM bookings WHERE status IN ('BOOKED', 'COMPLETED')";
            try (PreparedStatement ps = conn.prepareStatement(revSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalRevenue", rs.getDouble(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    private int getCount(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
