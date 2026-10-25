package com.controller;

import com.dao.DBConnection;
import com.dao.OrderDAO;
import com.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class ManageOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            OrderDAO dao = new OrderDAO(conn);
            List<Order> orders = dao.getAllOrders();
            request.setAttribute("orders", orders);

            // Handle flash message
            HttpSession session = request.getSession();
            String message = (String) session.getAttribute("message");
            String messageType = (String) session.getAttribute("messageType");
            if (message != null) {
                request.setAttribute("message", message);
                request.setAttribute("messageType", messageType);
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            }

            request.getRequestDispatcher("manage_orders.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Something went wrong.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        String status = request.getParameter("status");

        try (Connection conn = DBConnection.getConnection()) {
            OrderDAO dao = new OrderDAO(conn);
            dao.updateStatus(orderId, status);
            dao.insertOrderHistory(orderId, status);

            if ("in process".equalsIgnoreCase(status)) {
                dao.updateQueueEstimatedTime(orderId);
            }

            HttpSession session = request.getSession();
            session.setAttribute("message", "Order status updated successfully.");
            session.setAttribute("messageType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("message", "Failed to update order status.");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect("ManageOrdersServlet");
    }
}
