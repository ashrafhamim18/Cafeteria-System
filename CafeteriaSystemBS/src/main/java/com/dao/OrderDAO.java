package com.dao;

import com.model.Order;
import com.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private Connection conn;

    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.created_at ASC";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setCustomerName(rs.getString("full_name"));
                order.setTotal(rs.getDouble("total_price"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at").toString());

                orders.add(order);
            }
        }

        return orders;
    }

    public void updateStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }

    public void insertOrderHistory(int orderId, String status) throws SQLException {
        String sql = "INSERT INTO order_history (order_id, status) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setString(2, status);
            stmt.executeUpdate();
        }
    }

    public void updateQueueEstimatedTime(int orderId) throws SQLException {
        String sql = "UPDATE queue SET estimated_time = ? WHERE order_id = ?";
        Timestamp estimatedTime = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // +5 minutes
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, estimatedTime);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }

    // ✅ Corrected version: match PHP logic to check both status and pickup_status
    public boolean hasOrderReadyForPickup(int userId) throws SQLException {
        String sql = """
            SELECT COUNT(*) 
            FROM orders o
            JOIN queue q ON o.id = q.order_id
            WHERE o.user_id = ? 
              AND o.status = 'completed' 
              AND q.pickup_status = 'ready'
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}
