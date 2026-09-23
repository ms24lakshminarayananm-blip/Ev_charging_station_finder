package com.evcharging.model;

import java.sql.Timestamp;

public class ChargingSlot {
    private int id;
    private int stationId;
    private String slotNumber;
    private String chargerType;
    private String powerOutput;
    private String status; // AVAILABLE, OCCUPIED, MAINTENANCE
    private Timestamp createdAt;

    // Helper
    private String stationName;

    public ChargingSlot() {}

    public ChargingSlot(int id, int stationId, String slotNumber, String chargerType, String powerOutput, String status) {
        this.id = id;
        this.stationId = stationId;
        this.slotNumber = slotNumber;
        this.chargerType = chargerType;
        this.powerOutput = powerOutput;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStationId() { return stationId; }
    public void setStationId(int stationId) { this.stationId = stationId; }

    public String getSlotNumber() { return slotNumber; }
    public void setSlotNumber(String slotNumber) { this.slotNumber = slotNumber; }

    public String getChargerType() { return chargerType; }
    public void setChargerType(String chargerType) { this.chargerType = chargerType; }

    public String getPowerOutput() { return powerOutput; }
    public void setPowerOutput(String powerOutput) { this.powerOutput = powerOutput; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }
}
