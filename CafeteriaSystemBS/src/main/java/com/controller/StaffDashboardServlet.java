package com.controller;

import com.dao.DBConnection;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class StaffDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null || !"staff".equals(user.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, Object>> todayOrders = new ArrayList<>();
        double totalSales = 0;
        int totalOrders = 0;
        int pending = 0, inProcess = 0, completed = 0;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = """
                SELECT o.id, o.status, o.total_price, o.created_at, u.full_name 
                FROM orders o 
                JOIN users u ON o.user_id = u.id 
                ORDER BY o.created_at DESC
            """;

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            String today = new java.sql.Date(System.currentTimeMillis()).toString();

            while (rs.next()) {
                String orderDate = rs.getTimestamp("created_at").toLocalDateTime().toLocalDate().toString();
                if (today.equals(orderDate)) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("status", rs.getString("status"));
                    map.put("total_price", rs.getDouble("total_price"));
                    map.put("created_at", rs.getTimestamp("created_at"));
                    map.put("full_name", rs.getString("full_name"));
                    todayOrders.add(map);

                    totalSales += rs.getDouble("total_price");
                    totalOrders++;

                    switch (rs.getString("status")) {
                        case "pending" -> pending++;
                        case "in process" -> inProcess++;
                        case "completed" -> completed++;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ Transfer login success message to request
        if (session != null) {
            String loginMsg = (String) session.getAttribute("success");
            if (loginMsg != null) {
                req.setAttribute("msg", loginMsg);
                session.removeAttribute("success");
            }
        }

        req.setAttribute("fullName", user.getFullName());
        req.setAttribute("totalSales", totalSales);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("pending", pending);
        req.setAttribute("inProcess", inProcess);
        req.setAttribute("completed", completed);
        req.setAttribute("todayOrders", todayOrders);

        req.getRequestDispatcher("staff_dashboard.jsp").forward(req, res);
    }
}
