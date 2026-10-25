// ✅ CartDAO.java
package com.dao;

import java.sql.*;
import java.util.*;
import com.model.*;
import com.dao.DBConnection;

public class CartDAO {

    public void addToCart(int userId, int menuId) throws Exception {
        Connection conn = DBConnection.getConnection();

        // Check if item already in cart
        String checkSql = "SELECT * FROM cart_items WHERE user_id=? AND menu_id=?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setInt(1, userId);
        checkStmt.setInt(2, menuId);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Update quantity
            String updateSql = "UPDATE cart_items SET quantity = quantity + 1 WHERE user_id=? AND menu_id=?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, userId);
            updateStmt.setInt(2, menuId);
            updateStmt.executeUpdate();
        } else {
            // Insert new
            String insertSql = "INSERT INTO cart_items (user_id, menu_id, quantity) VALUES (?, ?, 1)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, userId);
            insertStmt.setInt(2, menuId);
            insertStmt.executeUpdate();
        }
    }

    public List<CartItem> getCartItems(int userId) throws Exception {
        List<CartItem> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        String sql = "SELECT c.id, c.quantity, m.id AS menu_id, m.name, m.price FROM cart_items c JOIN menu m ON c.menu_id = m.id WHERE c.user_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            CartItem item = new CartItem();
            item.setId(rs.getInt("id"));
            item.setQuantity(rs.getInt("quantity"));

            Menu menu = new Menu();
            menu.setId(rs.getInt("menu_id"));
            menu.setName(rs.getString("name"));
            menu.setPrice(rs.getDouble("price"));
            item.setMenu(menu);

            list.add(item);
        }
        return list;
    }

    public void removeItem(int cartId) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM cart_items WHERE id = ?");
        stmt.setInt(1, cartId);
        stmt.executeUpdate();
    }

    public void clearCart(int userId) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM cart_items WHERE user_id = ?");
        stmt.setInt(1, userId);
        stmt.executeUpdate();
    }
}
