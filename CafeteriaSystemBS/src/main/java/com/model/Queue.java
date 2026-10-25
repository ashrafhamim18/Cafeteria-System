package com.model;

import java.sql.Timestamp;

public class Queue {
    private int id;
    private int orderId;
    private int queueNumber;
    private String pickupStatus;
    private Timestamp estimatedTime;
    private boolean seenStatus;

    // Getters and Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getQueueNumber() {
        return queueNumber;
    }
    public void setQueueNumber(int queueNumber) {
        this.queueNumber = queueNumber;
    }

    public String getPickupStatus() {
        return pickupStatus;
    }
    public void setPickupStatus(String pickupStatus) {
        this.pickupStatus = pickupStatus;
    }

    public Timestamp getEstimatedTime() {
        return estimatedTime;
    }
    public void setEstimatedTime(Timestamp estimatedTime) {
        this.estimatedTime = estimatedTime;
    }

    public boolean isSeenStatus() {
        return seenStatus;
    }
    public void setSeenStatus(boolean seenStatus) {
        this.seenStatus = seenStatus;
    }
}
