package com.evcharging.dao;

import com.evcharging.model.Station;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StationDAO {

    public int addStation(Station s) {
        String sql = "INSERT INTO stations (owner_id, name, address, city, state, pincode, latitude, longitude, charger_types, power_rating, price_per_unit, total_slots, amenities, approval_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, s.getOwnerId());
            ps.setString(2, s.getName());
            ps.setString(3, s.getAddress());
            ps.setString(4, s.getCity());
            ps.setString(5, s.getState());
            ps.setString(6, s.getPincode());
            ps.setBigDecimal(7, s.getLatitude());
            ps.setBigDecimal(8, s.getLongitude());
            ps.setString(9, s.getChargerTypes());
            ps.setString(10, s.getPowerRating());
            ps.setBigDecimal(11, s.getPricePerUnit());
            ps.setInt(12, s.getTotalSlots());
            ps.setString(13, s.getAmenities());

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

    public boolean updateStation(Station s) {
        String sql = "UPDATE stations SET name=?, address=?, city=?, state=?, pincode=?, latitude=?, longitude=?, charger_types=?, power_rating=?, price_per_unit=?, total_slots=?, amenities=? WHERE id=? AND owner_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getAddress());
            ps.setString(3, s.getCity());
            ps.setString(4, s.getState());
            ps.setString(5, s.getPincode());
            ps.setBigDecimal(6, s.getLatitude());
            ps.setBigDecimal(7, s.getLongitude());
            ps.setString(8, s.getChargerTypes());
            ps.setString(9, s.getPowerRating());
            ps.setBigDecimal(10, s.getPricePerUnit());
            ps.setInt(11, s.getTotalSlots());
            ps.setString(12, s.getAmenities());
            ps.setInt(13, s.getId());
            ps.setInt(14, s.getOwnerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateApprovalStatus(int stationId, String status) {
        String sql = "UPDATE stations SET approval_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, stationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Station getById(int id) {
        String sql = "SELECT s.*, o.name AS owner_name, o.business_name AS owner_business_name, " +
                     "(SELECT COUNT(*) FROM charging_slots cs WHERE cs.station_id = s.id AND cs.status = 'AVAILABLE') AS available_slots_count, " +
                     "(SELECT IFNULL(AVG(r.rating), 0) FROM reviews r WHERE r.station_id = s.id) AS avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.station_id = s.id) AS total_reviews " +
                     "FROM stations s " +
                     "JOIN station_owners o ON s.owner_id = o.id " +
                     "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStation(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Station> getAllApprovedStations() {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT s.*, o.name AS owner_name, o.business_name AS owner_business_name, " +
                     "(SELECT COUNT(*) FROM charging_slots cs WHERE cs.station_id = s.id AND cs.status = 'AVAILABLE') AS available_slots_count, " +
                     "(SELECT IFNULL(AVG(r.rating), 0) FROM reviews r WHERE r.station_id = s.id) AS avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.station_id = s.id) AS total_reviews " +
                     "FROM stations s " +
                     "JOIN station_owners o ON s.owner_id = o.id " +
                     "WHERE s.approval_status = 'APPROVED' " +
                     "ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapStation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Station> searchStations(String cityOrQuery, String chargerType, Double maxPrice) {
        List<Station> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT s.*, o.name AS owner_name, o.business_name AS owner_business_name, ")
           .append("(SELECT COUNT(*) FROM charging_slots cs WHERE cs.station_id = s.id AND cs.status = 'AVAILABLE') AS available_slots_count, ")
           .append("(SELECT IFNULL(AVG(r.rating), 0) FROM reviews r WHERE r.station_id = s.id) AS avg_rating, ")
           .append("(SELECT COUNT(*) FROM reviews r WHERE r.station_id = s.id) AS total_reviews ")
           .append("FROM stations s ")
           .append("JOIN station_owners o ON s.owner_id = o.id ")
           .append("WHERE s.approval_status = 'APPROVED' ");

        List<Object> params = new ArrayList<>();

        if (cityOrQuery != null && !cityOrQuery.trim().isEmpty()) {
            sql.append("AND (s.city LIKE ? OR s.name LIKE ? OR s.address LIKE ?) ");
            String q = "%" + cityOrQuery.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (chargerType != null && !chargerType.trim().isEmpty() && !chargerType.equalsIgnoreCase("ALL")) {
            sql.append("AND s.charger_types LIKE ? ");
            params.add("%" + chargerType.trim() + "%");
        }

        if (maxPrice != null && maxPrice > 0) {
            sql.append("AND s.price_per_unit <= ? ");
            params.add(maxPrice);
        }

        sql.append("ORDER BY s.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Station> getStationsByOwner(int ownerId) {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT s.*, o.name AS owner_name, o.business_name AS owner_business_name, " +
                     "(SELECT COUNT(*) FROM charging_slots cs WHERE cs.station_id = s.id AND cs.status = 'AVAILABLE') AS available_slots_count, " +
                     "(SELECT IFNULL(AVG(r.rating), 0) FROM reviews r WHERE r.station_id = s.id) AS avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.station_id = s.id) AS total_reviews " +
                     "FROM stations s " +
                     "JOIN station_owners o ON s.owner_id = o.id " +
                     "WHERE s.owner_id = ? " +
                     "ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Station> getAllStations() {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT s.*, o.name AS owner_name, o.business_name AS owner_business_name, " +
                     "(SELECT COUNT(*) FROM charging_slots cs WHERE cs.station_id = s.id AND cs.status = 'AVAILABLE') AS available_slots_count, " +
                     "(SELECT IFNULL(AVG(r.rating), 0) FROM reviews r WHERE r.station_id = s.id) AS avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.station_id = s.id) AS total_reviews " +
                     "FROM stations s " +
                     "JOIN station_owners o ON s.owner_id = o.id " +
                     "ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapStation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Station> getPendingStations() {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT s.*, o.name AS owner_name, o.business_name AS owner_business_name, " +
                     "(SELECT COUNT(*) FROM charging_slots cs WHERE cs.station_id = s.id AND cs.status = 'AVAILABLE') AS available_slots_count, " +
                     "(SELECT IFNULL(AVG(r.rating), 0) FROM reviews r WHERE r.station_id = s.id) AS avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.station_id = s.id) AS total_reviews " +
                     "FROM stations s " +
                     "JOIN station_owners o ON s.owner_id = o.id " +
                     "WHERE s.approval_status = 'PENDING' " +
                     "ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapStation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalStationCount() {
        String sql = "SELECT COUNT(*) FROM stations WHERE approval_status = 'APPROVED'";
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

    public int getPendingStationCount() {
        String sql = "SELECT COUNT(*) FROM stations WHERE approval_status = 'PENDING'";
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

    private Station mapStation(ResultSet rs) throws SQLException {
        Station s = new Station();
        s.setId(rs.getInt("id"));
        s.setOwnerId(rs.getInt("owner_id"));
        s.setName(rs.getString("name"));
        s.setAddress(rs.getString("address"));
        s.setCity(rs.getString("city"));
        s.setState(rs.getString("state"));
        s.setPincode(rs.getString("pincode"));
        s.setLatitude(rs.getBigDecimal("latitude"));
        s.setLongitude(rs.getBigDecimal("longitude"));
        s.setChargerTypes(rs.getString("charger_types"));
        s.setPowerRating(rs.getString("power_rating"));
        s.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
        s.setTotalSlots(rs.getInt("total_slots"));
        s.setAmenities(rs.getString("amenities"));
        s.setApprovalStatus(rs.getString("approval_status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            s.setOwnerName(rs.getString("owner_name"));
            s.setOwnerBusinessName(rs.getString("owner_business_name"));
            s.setAvailableSlotsCount(rs.getInt("available_slots_count"));
            s.setAverageRating(Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0);
            s.setTotalReviews(rs.getInt("total_reviews"));
        } catch (SQLException ignored) {}

        return s;
    }
}
