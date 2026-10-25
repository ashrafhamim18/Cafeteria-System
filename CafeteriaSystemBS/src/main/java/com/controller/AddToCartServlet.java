package com.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.dao.DBConnection;

public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int menuId = Integer.parseInt(req.getParameter("menu_id"));
        int quantity = Math.max(1, Integer.parseInt(req.getParameter("quantity")));

        try (Connection conn = DBConnection.getConnection()) {
            // Check if item exists and available
            PreparedStatement itemStmt = conn.prepareStatement(
                "SELECT * FROM menu WHERE id = ? AND availability = 'available'");
            itemStmt.setInt(1, menuId);
            ResultSet itemRs = itemStmt.executeQuery();

            if (!itemRs.next()) {
                res.getWriter().println("<script>alert('Item not available.');window.location='CustomerBrowseMenuServlet';</script>");
                return;
            }

            String name = itemRs.getString("name");
            double price = itemRs.getDouble("price");

            // Get stock
            PreparedStatement stockStmt = conn.prepareStatement(
                "SELECT stock_quantity FROM stock WHERE menu_id = ?");
            stockStmt.setInt(1, menuId);
            ResultSet stockRs = stockStmt.executeQuery();

            int stockQty = 0;
            if (stockRs.next()) {
                stockQty = stockRs.getInt("stock_quantity");
            }

            // Cart
            List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();

            // Find existing quantity
            int existingQty = 0;
            for (Map<String, Object> item : cart) {
                if ((int) item.get("menu_id") == menuId) {
                    existingQty = (int) item.get("quantity");
                    break;
                }
            }

            int totalRequested = existingQty + quantity;
            if (totalRequested > stockQty) {
                int remaining = Math.max(0, stockQty - existingQty);
                res.getWriter().println("<script>alert('Only " + remaining + " unit(s) left in stock. Cannot add more.');window.location='CustomerBrowseMenuServlet';</script>");
                return;
            }

            // Add or update cart
            boolean found = false;
            for (Map<String, Object> item : cart) {
                if ((int) item.get("menu_id") == menuId) {
                    item.put("quantity", existingQty + quantity);
                    found = true;
                    break;
                }
            }

            if (!found) {
                Map<String, Object> newItem = new HashMap<>();
                newItem.put("menu_id", menuId);
                newItem.put("name", name);
                newItem.put("price", price);
                newItem.put("quantity", quantity);
                cart.add(newItem);
            }

            session.setAttribute("cart", cart);
            res.getWriter().println("<script>alert('Item added to cart.');window.location='ViewCartServlet';</script>");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("<script>alert('Error occurred.');window.location='CustomerBrowseMenuServlet';</script>");
        }
    }
}
