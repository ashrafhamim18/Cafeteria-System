<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Map<String, Object>> reviews = (List<Map<String, Object>>) request.getAttribute("reviews");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");

    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Reviews</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f5fafd; padding: 2rem; margin: 0; }
        .home-btn { position: fixed; top: 20px; left: 20px; z-index: 1000; }
        .home-btn img { height: 60px; cursor: pointer; transition: transform 0.2s; }
        .home-btn img:hover { transform: scale(1.05); }

        h2 {
            color: #00796b;
            text-align: center;
            margin-top: 40px;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-top: 1rem;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 1rem;
            text-align: left;
            vertical-align: top;
        }

        th {
            background-color: #e0f2f1;
            color: #00796b;
        }

        .reply-box {
            background-color: #f0f9ff;
            border-left: 4px solid #00acc1;
            padding: 10px;
            border-radius: 6px;
        }

        .no-reviews {
            text-align: center;
            color: #999;
            margin-top: 2rem;
        }
    </style>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<a href="CustomerDashboardServlet1" class="home-btn">
    <img src="images/logo1.png" alt="Home">
</a>

<h2>My Reviews & Replies</h2>

<% if (reviews != null && !reviews.isEmpty()) { %>
    <table>
        <tr>
            <th>Order ID</th>
            <th>Date</th>
            <th>Rating</th>
            <th>Your Feedback</th>
            <th>Staff Reply</th>
        </tr>
        <% for (Map<String, Object> row : reviews) { %>
            <tr>
                <td>#<%= row.get("order_id") %></td>
                <td><%= row.get("created_at") %></td>
                <td><%= row.get("rating") %> ⭐</td>
                <td><%= row.get("feedback") != null ? ((String) row.get("feedback")).replace("\n", "<br>") : "" %></td>
                <td>
                    <% if (row.get("reply") != null && !((String) row.get("reply")).isEmpty()) { %>
                        <div class="reply-box"><%= ((String) row.get("reply")).replace("\n", "<br>") %></div>
                    <% } else { %>
                        <em>No reply yet.</em>
                    <% } %>
                </td>
            </tr>
        <% } %>
    </table>
<% } else { %>
    <p class="no-reviews">You haven't submitted any feedback yet.</p>
<% } %>

<!-- SweetAlert2 Popups -->
<script>
    window.onload = function () {
        <% if ("1".equals(success)) { %>
        Swal.fire({
            icon: 'success',
            title: 'Thank you for your review!',
            timer: 3000,
            showConfirmButton: false,
            toast: true,
            position: 'top-end',
            timerProgressBar: true,
        });
        <% } else if ("0".equals(success)) { %>
        Swal.fire({
            icon: 'error',
            title: 'Failed to submit review. Please try again.',
            timer: 3000,
            showConfirmButton: false,
            toast: true,
            position: 'top-end',
            timerProgressBar: true,
        });
        <% } else if (message != null) { %>
        Swal.fire({
            icon: 'success',
            title: '<%= message.replace("\"", "\\\"") %>',
            timer: 3000,
            showConfirmButton: false,
            toast: true,
            position: 'top-end',
            timerProgressBar: true,
        });
        <% } else if (error != null) { %>
        Swal.fire({
            icon: 'error',
            title: '<%= error.replace("\"", "\\\"") %>',
            timer: 3000,
            showConfirmButton: false,
            toast: true,
            position: 'top-end',
            timerProgressBar: true,
        });
        <% } %>
    };
</script>

</body>
</html>
