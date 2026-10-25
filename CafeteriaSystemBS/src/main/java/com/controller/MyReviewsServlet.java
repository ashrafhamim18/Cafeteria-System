package com.controller;

import com.dao.DBConnection;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class MyReviewsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"customer".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();
        List<Map<String, Object>> reviews = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Mark replies as seen
            String updateSeen = "UPDATE feedback f " +
                                "JOIN orders o ON f.order_id = o.id " +
                                "SET f.reply_seen = 1 " +
                                "WHERE o.user_id = ? AND f.reply IS NOT NULL";
            try (PreparedStatement ps = conn.prepareStatement(updateSeen)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            // Fetch user feedback and replies
            String sql = """
                SELECT f.id AS feedback_id, f.rating, f.feedback, f.reply, f.created_at,
                       o.id AS order_id, o.created_at AS order_created_at
                FROM feedback f
                JOIN orders o ON f.order_id = o.id
                WHERE o.user_id = ?
                ORDER BY o.created_at DESC
            """;

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("order_id", rs.getInt("order_id"));
                    row.put("created_at", rs.getTimestamp("order_created_at"));
                    row.put("rating", rs.getInt("rating"));
                    row.put("feedback", rs.getString("feedback"));
                    row.put("reply", rs.getString("reply"));
                    reviews.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace(); // You may log this instead in real projects
        }

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("my_reviews.jsp").forward(request, response);
    }
}
