package com.controller;

import com.dao.DBConnection;
import com.dao.FeedbackDAO;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class GiveReviewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"customer".equals(user.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        String orderIdStr = req.getParameter("order_id");
        if (orderIdStr == null) {
            res.sendRedirect("MyOrdersServlet");
            return;
        }

        req.setAttribute("order_id", orderIdStr);
        req.getRequestDispatcher("give_reviews.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"customer".equals(user.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int userId = user.getId();
            int orderId = Integer.parseInt(req.getParameter("order_id"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String feedback = req.getParameter("feedback");

            FeedbackDAO dao = new FeedbackDAO(conn); // ✅ Use new constructor
            dao.insertFeedback(userId, orderId, rating, feedback);

            res.sendRedirect("MyReviewsServlet?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("MyReviewsServlet?success=0");
        }
    }
}
