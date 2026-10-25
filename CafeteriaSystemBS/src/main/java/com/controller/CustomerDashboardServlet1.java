package com.controller;

import com.dao.FeedbackDAO;
import com.dao.MenuDAO;
import com.dao.OrderDAO;
import com.dao.QueueDAO;
import com.model.Menu;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Collections;
import java.util.List;

public class CustomerDashboardServlet1 extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"customer".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        int userId = user.getId();

        try (Connection conn = com.dao.DBConnection.getConnection()) {
            OrderDAO orderDao = new OrderDAO(conn);
            MenuDAO menuDao = new MenuDAO(conn);
            QueueDAO queueDao = new QueueDAO(conn);
            FeedbackDAO feedbackDao = new FeedbackDAO(conn);

            boolean hasReadyPickup = orderDao.hasOrderReadyForPickup(userId);
            List<Menu> previewItems = menuDao.getRandomPreviewItems(4);

            boolean hasUnseenReply;
            try {
                hasUnseenReply = feedbackDao.hasUnseenReply(userId);
            } catch (Exception e) {
                hasUnseenReply = false;
                e.printStackTrace();
            }

            String estimatedTimeMsg = queueDao.getEstimatedTimeMessage(userId);

            if (previewItems == null) previewItems = Collections.emptyList();

            request.setAttribute("hasReadyPickup", hasReadyPickup);
            request.setAttribute("hasUnseenReply", hasUnseenReply);
            request.setAttribute("estimatedTimeMsg", estimatedTimeMsg != null ? estimatedTimeMsg : "");
            request.setAttribute("previewItems", previewItems);

            request.getRequestDispatcher("/customer_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
