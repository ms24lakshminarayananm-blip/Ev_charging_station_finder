package com.evcharging.model;

import java.sql.Date;
import java.sql.Timestamp;

public class WaitingList {
    private int id;
    private int userId;
    private int stationId;
    private Date desiredDate;
    private String desiredTime;
    private String status; // WAITING, NOTIFIED, EXPIRED
    private Timestamp createdAt;

    // Helper fields
    private String userName;
    private String userEmail;
    private String userPhone;
    private String stationName;
    private String stationCity;

    public WaitingList() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getStationId() { return stationId; }
    public void setStationId(int stationId) { this.stationId = stationId; }

    public Date getDesiredDate() { return desiredDate; }
    public void setDesiredDate(Date desiredDate) { this.desiredDate = desiredDate; }

    public String getDesiredTime() { return desiredTime; }
    public void setDesiredTime(String desiredTime) { this.desiredTime = desiredTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

    public String getStationCity() { return stationCity; }
    public void setStationCity(String stationCity) { this.stationCity = stationCity; }
}
