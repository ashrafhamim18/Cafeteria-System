package com.controller;

import com.dao.DBConnection;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class MyOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"customer".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();
        List<Map<String, Object>> orderList = new ArrayList<>();
        Set<Integer> reviewedOrderIds = new HashSet<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Order and item details
            String sql = """
                SELECT o.id AS order_id, o.total_price, o.created_at,
                       o.status, q.queue_number, q.pickup_status, q.estimated_time,
                       m.name, oi.quantity, oi.price
                FROM orders o
                LEFT JOIN queue q ON o.id = q.order_id
                JOIN order_items oi ON o.id = oi.order_id
                JOIN menu m ON oi.menu_id = m.id
                WHERE o.user_id = ?
                ORDER BY o.created_at DESC
            """;

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("order_id", rs.getInt("order_id"));
                row.put("total_price", rs.getDouble("total_price"));
                row.put("timestamp", rs.getTimestamp("created_at")); // renamed to timestamp to match JSP
                row.put("status", rs.getString("status"));
                row.put("queue_number", rs.getInt("queue_number"));
                row.put("pickup_status", rs.getString("pickup_status"));
                row.put("estimated_time", rs.getTimestamp("estimated_time"));
                row.put("name", rs.getString("name"));
                row.put("quantity", rs.getInt("quantity"));
                row.put("price", rs.getDouble("price"));
                orderList.add(row);
            }

            // Get orders already reviewed
            String reviewSql = "SELECT order_id FROM feedback WHERE user_id = ?";
            PreparedStatement reviewStmt = conn.prepareStatement(reviewSql);
            reviewStmt.setInt(1, userId);
            ResultSet reviewRs = reviewStmt.executeQuery();

            while (reviewRs.next()) {
                reviewedOrderIds.add(reviewRs.getInt("order_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ Add success alert for pickup
        String pickupSuccess = (String) session.getAttribute("pickupSuccess");
        if (pickupSuccess != null) {
            request.setAttribute("pickupSuccess", pickupSuccess);
            session.removeAttribute("pickupSuccess");
        }

        request.setAttribute("orders", orderList);
        request.setAttribute("reviewedOrderIds", reviewedOrderIds);
        request.getRequestDispatcher("my_orders.jsp").forward(request, response);
    }
}
