package com.controller;

import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

import com.dao.DBConnection;

public class ViewCartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // Remove item
        String removeIndex = req.getParameter("remove");
        if (removeIndex != null) {
            try {
                int index = Integer.parseInt(removeIndex);
                List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
                if (cart != null && index >= 0 && index < cart.size()) {
                    cart.remove(index);
                }
            } catch (Exception ignored) {}
            res.sendRedirect("ViewCartServlet");
            return;
        }

        req.getRequestDispatcher("view_cart.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

        if ("clear".equals(action)) {
            session.removeAttribute("cart");
            res.sendRedirect("ViewCartServlet");
            return;
        }

        if ("checkout".equals(action)) {
            if (cart == null || cart.isEmpty()) {
                res.getWriter().println("<script>alert('Your cart is empty.');window.location='ViewCartServlet';</script>");
                return;
            }

            User user = (User) session.getAttribute("user");
            int userId = user.getId();


            Connection conn = null;

            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false);

                for (Map<String, Object> item : cart) {
                    int menuId = (int) item.get("menu_id");
                    int qty = (int) item.get("quantity");

                    PreparedStatement stockStmt = conn.prepareStatement("SELECT stock_quantity FROM stock WHERE menu_id = ? FOR UPDATE");
                    stockStmt.setInt(1, menuId);
                    ResultSet rs = stockStmt.executeQuery();
                    if (!rs.next() || rs.getInt("stock_quantity") < qty) {
                        throw new Exception("Insufficient stock for item: " + item.get("name"));
                    }
                }

                double total = 0;
                for (Map<String, Object> item : cart) {
                    total += (double) item.get("price") * (int) item.get("quantity");
                }

                PreparedStatement insertOrder = conn.prepareStatement("INSERT INTO orders (user_id, total_price) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
                insertOrder.setInt(1, userId);
                insertOrder.setDouble(2, total);
                insertOrder.executeUpdate();
                ResultSet generatedKeys = insertOrder.getGeneratedKeys();
                generatedKeys.next();
                int orderId = generatedKeys.getInt(1);

                for (Map<String, Object> item : cart) {
                    PreparedStatement insertItem = conn.prepareStatement("INSERT INTO order_items (order_id, menu_id, quantity, price) VALUES (?, ?, ?, ?)");
                    insertItem.setInt(1, orderId);
                    insertItem.setInt(2, (int) item.get("menu_id"));
                    insertItem.setInt(3, (int) item.get("quantity"));
                    insertItem.setDouble(4, (double) item.get("price"));
                    insertItem.executeUpdate();

                    PreparedStatement updateStock = conn.prepareStatement("UPDATE stock SET stock_quantity = stock_quantity - ? WHERE menu_id = ?");
                    updateStock.setInt(1, (int) item.get("quantity"));
                    updateStock.setInt(2, (int) item.get("menu_id"));
                    updateStock.executeUpdate();
                }

                conn.createStatement().executeUpdate(
                    "UPDATE menu m JOIN stock s ON m.id = s.menu_id " +
                    "SET m.availability = CASE WHEN s.stock_quantity <= 0 THEN 'unavailable' ELSE 'available' END"
                );

                ResultSet qRes = conn.createStatement().executeQuery("SELECT MAX(queue_number) AS last FROM queue");
                int nextQueue = (qRes.next() && qRes.getInt("last") > 0) ? qRes.getInt("last") + 1 : 1;

                PreparedStatement insertQueue = conn.prepareStatement("INSERT INTO queue (order_id, queue_number) VALUES (?, ?)");
                insertQueue.setInt(1, orderId);
                insertQueue.setInt(2, nextQueue);
                insertQueue.executeUpdate();

                conn.commit();
                session.removeAttribute("cart");

                res.getWriter().println("<script>alert('Order placed successfully!');window.location='MyOrdersServlet';</script>");

            } catch (Exception e) {
                try {
                    if (conn != null) conn.rollback();
                } catch (Exception ignored) {}
                e.printStackTrace();
                res.getWriter().println("<script>alert('" + e.getMessage() + "');window.location='ViewCartServlet';</script>");
            }
        }
    }
}
