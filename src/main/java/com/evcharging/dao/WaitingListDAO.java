package com.evcharging.dao;

import com.evcharging.model.WaitingList;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WaitingListDAO {

    public boolean addWaiting(WaitingList wl) {
        String sql = "INSERT INTO waiting_list (user_id, station_id, desired_date, desired_time, status) VALUES (?, ?, ?, ?, 'WAITING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wl.getUserId());
            ps.setInt(2, wl.getStationId());
            ps.setDate(3, wl.getDesiredDate());
            ps.setString(4, wl.getDesiredTime());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<WaitingList> getByUserId(int userId) {
        List<WaitingList> list = new ArrayList<>();
        String sql = "SELECT w.*, u.name AS user_name, u.email AS user_email, u.phone AS user_phone, " +
                     "s.name AS station_name, s.city AS station_city " +
                     "FROM waiting_list w " +
                     "JOIN users u ON w.user_id = u.id " +
                     "JOIN stations s ON w.station_id = s.id " +
                     "WHERE w.user_id = ? " +
                     "ORDER BY w.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapWaiting(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<WaitingList> getByStationId(int stationId) {
        List<WaitingList> list = new ArrayList<>();
        String sql = "SELECT w.*, u.name AS user_name, u.email AS user_email, u.phone AS user_phone, " +
                     "s.name AS station_name, s.city AS station_city " +
                     "FROM waiting_list w " +
                     "JOIN users u ON w.user_id = u.id " +
                     "JOIN stations s ON w.station_id = s.id " +
                     "WHERE w.station_id = ? " +
                     "ORDER BY w.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapWaiting(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE waiting_list SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM waiting_list WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private WaitingList mapWaiting(ResultSet rs) throws SQLException {
        WaitingList wl = new WaitingList();
        wl.setId(rs.getInt("id"));
        wl.setUserId(rs.getInt("user_id"));
        wl.setStationId(rs.getInt("station_id"));
        wl.setDesiredDate(rs.getDate("desired_date"));
        wl.setDesiredTime(rs.getString("desired_time"));
        wl.setStatus(rs.getString("status"));
        wl.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            wl.setUserName(rs.getString("user_name"));
            wl.setUserEmail(rs.getString("user_email"));
            wl.setUserPhone(rs.getString("user_phone"));
            wl.setStationName(rs.getString("station_name"));
            wl.setStationCity(rs.getString("station_city"));
        } catch (SQLException ignored) {}
        return wl;
    }
}
