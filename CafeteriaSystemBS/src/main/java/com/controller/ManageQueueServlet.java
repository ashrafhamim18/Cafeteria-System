package com.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import com.dao.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class ManageQueueServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> queueList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = """
                SELECT q.*, o.status AS order_status
                FROM queue q
                JOIN orders o ON q.order_id = o.id
                ORDER BY q.queue_number
            """;
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("queue_number", rs.getInt("queue_number"));
                map.put("order_id", rs.getInt("order_id"));
                map.put("pickup_status", rs.getString("pickup_status"));
                map.put("estimated_time", rs.getTimestamp("estimated_time"));
                map.put("order_status", rs.getString("order_status"));
                queueList.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("queueList", queueList);
        request.getRequestDispatcher("manage_queue.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int queueId = Integer.parseInt(request.getParameter("queue_id"));
        String status = request.getParameter("pickup_status");
        String estimatedTimeStr = request.getParameter("estimated_time");

        try (Connection conn = DBConnection.getConnection()) {
            String updateSql = "UPDATE queue SET pickup_status = ?, estimated_time = ? WHERE id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, status);

            if (estimatedTimeStr != null && !estimatedTimeStr.isEmpty()) {
                // Correct fix: parse as LocalDateTime from "yyyy-MM-ddTHH:mm"
                LocalDateTime dateTime = LocalDateTime.parse(estimatedTimeStr);
                Timestamp estimatedTime = Timestamp.valueOf(dateTime); // e.g., "2025-07-24 16:00:00"
                updateStmt.setTimestamp(2, estimatedTime);
            } else {
                updateStmt.setNull(2, Types.TIMESTAMP);
            }

            updateStmt.setInt(3, queueId);
            updateStmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("message", "Queue updated successfully.");
        doGet(request, response);
    }
}
