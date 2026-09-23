package com.evcharging.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Coupon {
    private int id;
    private String code;
    private int discountPercentage;
    private BigDecimal maxDiscount;
    private BigDecimal minAmount;
    private Date validUntil;
    private boolean active;

    public Coupon() {}

    public Coupon(int id, String code, int discountPercentage, BigDecimal maxDiscount, BigDecimal minAmount, Date validUntil, boolean active) {
        this.id = id;
        this.code = code;
        this.discountPercentage = discountPercentage;
        this.maxDiscount = maxDiscount;
        this.minAmount = minAmount;
        this.validUntil = validUntil;
        this.active = active;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public int getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(int discountPercentage) { this.discountPercentage = discountPercentage; }

    public BigDecimal getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(BigDecimal maxDiscount) { this.maxDiscount = maxDiscount; }

    public BigDecimal getMinAmount() { return minAmount; }
    public void setMinAmount(BigDecimal minAmount) { this.minAmount = minAmount; }

    public Date getValidUntil() { return validUntil; }
    public void setValidUntil(Date validUntil) { this.validUntil = validUntil; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
