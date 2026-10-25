package com.controller;

import com.dao.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ConfirmPickupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("order_id"));

        try (Connection conn = DBConnection.getConnection()) {
            // Update pickup_status in queue table
            String sql = "UPDATE queue SET pickup_status = 'picked up' WHERE order_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            stmt.executeUpdate();

            // Success message in session
            HttpSession session = request.getSession();
            session.setAttribute("pickupSuccess", "Thanks! Order marked as picked up.");
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("MyOrdersServlet");
    }
}
