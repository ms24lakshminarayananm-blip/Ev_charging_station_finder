package com.evcharging.dao;

import com.evcharging.model.ChargingSlot;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SlotDAO {

    public boolean addSlot(ChargingSlot slot) {
        String sql = "INSERT INTO charging_slots (station_id, slot_number, charger_type, power_output, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slot.getStationId());
            ps.setString(2, slot.getSlotNumber());
            ps.setString(3, slot.getChargerType());
            ps.setString(4, slot.getPowerOutput());
            ps.setString(5, slot.getStatus() != null ? slot.getStatus() : "AVAILABLE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ChargingSlot> getSlotsByStation(int stationId) {
        List<ChargingSlot> list = new ArrayList<>();
        String sql = "SELECT cs.*, s.name AS station_name FROM charging_slots cs JOIN stations s ON cs.station_id = s.id WHERE cs.station_id = ? ORDER BY cs.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSlot(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ChargingSlot> getAvailableSlots(int stationId) {
        List<ChargingSlot> list = new ArrayList<>();
        String sql = "SELECT cs.*, s.name AS station_name FROM charging_slots cs JOIN stations s ON cs.station_id = s.id WHERE cs.station_id = ? AND cs.status = 'AVAILABLE' ORDER BY cs.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSlot(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ChargingSlot getById(int id) {
        String sql = "SELECT cs.*, s.name AS station_name FROM charging_slots cs JOIN stations s ON cs.station_id = s.id WHERE cs.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSlot(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(int slotId, String status) {
        String sql = "UPDATE charging_slots SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void createDefaultSlotsForStation(int stationId, int totalSlots, String defaultChargerType, String powerOutput) {
        for (int i = 1; i <= totalSlots; i++) {
            ChargingSlot s = new ChargingSlot();
            s.setStationId(stationId);
            s.setSlotNumber("Slot " + i);
            s.setChargerType(defaultChargerType != null && !defaultChargerType.isEmpty() ? defaultChargerType : "CCS2 Fast DC");
            s.setPowerOutput(powerOutput != null && !powerOutput.isEmpty() ? powerOutput : "50 kW");
            s.setStatus("AVAILABLE");
            addSlot(s);
        }
    }

    private ChargingSlot mapSlot(ResultSet rs) throws SQLException {
        ChargingSlot cs = new ChargingSlot();
        cs.setId(rs.getInt("id"));
        cs.setStationId(rs.getInt("station_id"));
        cs.setSlotNumber(rs.getString("slot_number"));
        cs.setChargerType(rs.getString("charger_type"));
        cs.setPowerOutput(rs.getString("power_output"));
        cs.setStatus(rs.getString("status"));
        cs.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            cs.setStationName(rs.getString("station_name"));
        } catch (SQLException ignored) {}
        return cs;
    }
}
