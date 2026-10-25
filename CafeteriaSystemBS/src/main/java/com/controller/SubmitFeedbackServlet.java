package com.controller;

import com.dao.DBConnection;
import com.dao.FeedbackDAO;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/SubmitFeedbackServlet")
public class SubmitFeedbackServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String message = req.getParameter("message");
        String ratingStr = req.getParameter("rating");
        String orderIdStr = req.getParameter("order_id");

        if (message == null || message.trim().isEmpty() || ratingStr == null || orderIdStr == null) {
            res.sendRedirect("submit_feedback.jsp?error=empty");
            return;
        }

        User user = (User) session.getAttribute("user");
        int rating = Integer.parseInt(ratingStr);
        int orderId = Integer.parseInt(orderIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            FeedbackDAO dao = new FeedbackDAO(conn);
            dao.insertFeedback(user.getId(), orderId, rating, message);
            res.sendRedirect("submit_feedback.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("submit_feedback.jsp?error=server");
        }
    }
}
