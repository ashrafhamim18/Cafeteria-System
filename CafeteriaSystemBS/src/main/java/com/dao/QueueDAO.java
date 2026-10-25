package com.dao;

import java.sql.*;
import java.text.SimpleDateFormat;

public class QueueDAO {
    private Connection conn;

    public QueueDAO(Connection conn) {
        this.conn = conn;
    }

    public String getEstimatedTimeMessage(int userId) throws SQLException {
        String sql = """
            SELECT q.estimated_time
            FROM queue q
            JOIN orders o ON q.order_id = o.id
            WHERE o.user_id = ? AND o.status = 'in process'
              AND q.pickup_status = 'pending'
              AND q.estimated_time IS NOT NULL
            ORDER BY q.estimated_time DESC
            LIMIT 1
        """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Timestamp estimatedTime = rs.getTimestamp("estimated_time");
                if (estimatedTime != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
                    String timeFormatted = sdf.format(estimatedTime);
                    return "🕒 Your order is being prepared. Estimated pickup time: " + timeFormatted;
                }
            }
        }
        return null;
    }
}
