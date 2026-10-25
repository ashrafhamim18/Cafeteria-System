package com.controller;

import com.dao.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class ManageReviewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> reviewList = new ArrayList<>();
        int filterRating = 0;

        try {
            String ratingParam = request.getParameter("rating");
            if (ratingParam != null && ratingParam.matches("\\d+")) {
                filterRating = Integer.parseInt(ratingParam);
            }

            try (Connection conn = DBConnection.getConnection()) {
                String sql = """
                    SELECT f.*, u.full_name, o.id AS order_id, o.created_at
                    FROM feedback f
                    JOIN users u ON f.user_id = u.id
                    JOIN orders o ON f.order_id = o.id
                    """ + (filterRating > 0 ? "WHERE f.rating = ? " : "") + "ORDER BY f.created_at DESC";

                PreparedStatement stmt = conn.prepareStatement(sql);
                if (filterRating > 0) {
                    stmt.setInt(1, filterRating);
                }

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("id", rs.getInt("id"));
                    review.put("full_name", rs.getString("full_name"));
                    review.put("order_id", rs.getInt("order_id"));
                    review.put("created_at", rs.getTimestamp("created_at"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("feedback", rs.getString("feedback"));
                    review.put("reply", rs.getString("reply"));
                    reviewList.add(review);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("reviews", reviewList);
        request.setAttribute("selectedRating", filterRating);

        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("manage_reviews.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reply = request.getParameter("reply");
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE feedback SET reply = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, reply);
            stmt.setInt(2, feedbackId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession();
        session.setAttribute("message", "Reply submitted successfully!");

        response.sendRedirect("ManageReviewServlet");
    }
}
