package com.dao;

import com.model.Menu;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {
    private Connection conn;

    public MenuDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Menu> getFilteredMenu(String category, String availability) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT m.*, s.stock_quantity FROM menu m LEFT JOIN stock s ON m.id = s.menu_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (category != null && (category.equals("food") || category.equals("drink"))) {
            sql.append(" AND m.category = ?");
            params.add(category);
        }
        if (availability != null && (availability.equals("available") || availability.equals("unavailable"))) {
            sql.append(" AND m.availability = ?");
            params.add(availability);
        }

        PreparedStatement stmt = conn.prepareStatement(sql.toString());
        for (int i = 0; i < params.size(); i++) {
            stmt.setObject(i + 1, params.get(i));
        }

        ResultSet rs = stmt.executeQuery();
        List<Menu> list = new ArrayList<>();
        while (rs.next()) {
            Menu m = new Menu();
            m.setId(rs.getInt("id"));
            m.setName(rs.getString("name"));
            m.setDescription(rs.getString("description"));
            m.setPrice(rs.getDouble("price"));
            m.setAvailability(rs.getString("availability"));
            m.setCategory(rs.getString("category"));
            m.setImage(rs.getString("image"));
            m.setStockQuantity(rs.getObject("stock_quantity") != null ? rs.getInt("stock_quantity") : 0);
            list.add(m);
        }
        return list;
    }

    public List<Menu> getAllMenu() throws Exception {
        String sql = "SELECT m.*, s.stock_quantity FROM menu m LEFT JOIN stock s ON m.id = s.menu_id";
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        List<Menu> list = new ArrayList<>();
        while (rs.next()) {
            Menu m = new Menu();
            m.setId(rs.getInt("id"));
            m.setName(rs.getString("name"));
            m.setDescription(rs.getString("description"));
            m.setPrice(rs.getDouble("price"));
            m.setAvailability(rs.getString("availability"));
            m.setCategory(rs.getString("category"));
            m.setImage(rs.getString("image"));
            m.setStockQuantity(rs.getObject("stock_quantity") != null ? rs.getInt("stock_quantity") : 0);
            list.add(m);
        }
        return list;
    }

    public Menu getMenuById(int id) throws SQLException {
        String sql = "SELECT * FROM menu WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Menu m = new Menu();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setDescription(rs.getString("description"));
                m.setPrice(rs.getDouble("price"));
                m.setCategory(rs.getString("category"));
                m.setImage(rs.getString("image"));
                m.setAvailability(rs.getString("availability"));
                return m;
            }
        }
        return null;
    }

    public void addMenu(Menu menu) throws SQLException {
        String sql = "INSERT INTO menu (name, description, price, category, image, availability) VALUES (?, ?, ?, ?, ?, 'available')";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, menu.getName());
            stmt.setString(2, menu.getDescription());
            stmt.setDouble(3, menu.getPrice());
            stmt.setString(4, menu.getCategory());
            stmt.setString(5, menu.getImage());
            stmt.executeUpdate();
        }
    }

    public void updateMenu(Menu menu) throws SQLException {
        String sql = "UPDATE menu SET name = ?, description = ?, price = ?, category = ?, image = ?, availability = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, menu.getName());
            stmt.setString(2, menu.getDescription());
            stmt.setDouble(3, menu.getPrice());
            stmt.setString(4, menu.getCategory());
            stmt.setString(5, menu.getImage());
            stmt.setString(6, menu.getAvailability());
            stmt.setInt(7, menu.getId());
            stmt.executeUpdate();
        }
    }

    public void deleteMenu(int id) throws SQLException {
        String sql = "DELETE FROM menu WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Menu> getRandomPreviewItems(int limit) throws SQLException {
        String sql = "SELECT * FROM menu WHERE availability = 'available' ORDER BY RAND() LIMIT ?";
        List<Menu> items = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Menu m = new Menu();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setDescription(rs.getString("description"));
                m.setCategory(rs.getString("category"));
                m.setPrice(rs.getDouble("price"));
                m.setImage(rs.getString("image"));
                m.setAvailability(rs.getString("availability"));
                items.add(m);
            }
        }

        return items;
    }
    public void updateAvailability(int menuId, String availability) throws SQLException {
        String sql = "UPDATE menu SET availability = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, availability);
            stmt.setInt(2, menuId);
            stmt.executeUpdate();
        }
    }

}
