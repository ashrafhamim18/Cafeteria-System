package com.dao;

import com.model.Feedback;
import java.sql.*;
import java.util.*;

public class FeedbackDAO {
    private Connection conn;

    public FeedbackDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Feedback> getFeedbackByUserId(int userId) throws Exception {
        List<Feedback> list = new ArrayList<>();
        String sql = """
            SELECT f.* 
            FROM feedback f
            JOIN orders o ON f.order_id = o.id
            WHERE o.user_id = ?
            ORDER BY f.created_at DESC
        """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setOrderId(rs.getInt("order_id"));
                fb.setRating(rs.getInt("rating"));
                fb.setFeedback(rs.getString("feedback"));
                fb.setReply(rs.getString("reply"));
                fb.setReplySeen(rs.getBoolean("reply_seen"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fb);
            }
        }

        return list;
    }

    public void insertFeedback(int userId, int orderId, int rating, String feedback) throws Exception {
        String sql = "INSERT INTO feedback (user_id, order_id, rating, feedback, created_at) VALUES (?, ?, ?, ?, NOW())";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, orderId);
            stmt.setInt(3, rating);
            stmt.setString(4, feedback);
            stmt.executeUpdate();
        }
    }

    public boolean hasUnseenReply(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM feedback WHERE user_id = ? AND reply IS NOT NULL AND reply_seen = 0";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }
}
