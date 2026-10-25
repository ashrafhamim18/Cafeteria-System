package com.dao;

import java.sql.*;

public class StockDAO {
    private final Connection conn;

    public StockDAO(Connection conn) {
        this.conn = conn;
    }

    public boolean exists(int menuId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM stock WHERE menu_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public void insertStock(int menuId, int quantity) throws SQLException {
        String sql = "INSERT INTO stock (menu_id, stock_quantity) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            ps.setInt(2, quantity);
            ps.executeUpdate();
        }
    }

    public void updateStock(int menuId, int quantity) throws SQLException {
        String sql = "UPDATE stock SET stock_quantity = ? WHERE menu_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, menuId);
            ps.executeUpdate();
        }
    }

    public int getStockQuantity(int menuId) throws SQLException {
        String sql = "SELECT stock_quantity FROM stock WHERE menu_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("stock_quantity");
            }
        }
        return 0;
    }
}
