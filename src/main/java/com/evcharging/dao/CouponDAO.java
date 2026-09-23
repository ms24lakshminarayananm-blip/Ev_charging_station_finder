package com.evcharging.dao;

import com.evcharging.model.Coupon;
import com.evcharging.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CouponDAO {

    public Coupon getByCode(String code) {
        if (code == null) return null;
        String sql = "SELECT * FROM coupons WHERE UPPER(code) = UPPER(?) AND is_active = 1 AND valid_until >= CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCoupon(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Coupon> getAllCoupons() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapCoupon(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Coupon mapCoupon(ResultSet rs) throws SQLException {
        Coupon c = new Coupon();
        c.setId(rs.getInt("id"));
        c.setCode(rs.getString("code"));
        c.setDiscountPercentage(rs.getInt("discount_percentage"));
        c.setMaxDiscount(rs.getBigDecimal("max_discount"));
        c.setMinAmount(rs.getBigDecimal("min_amount"));
        c.setValidUntil(rs.getDate("valid_until"));
        c.setActive(rs.getBoolean("is_active"));
        return c;
    }
}
