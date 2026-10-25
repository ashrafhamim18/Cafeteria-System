<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.sql.Timestamp, java.text.SimpleDateFormat" %>
<%
    List<Map<String, Object>> reviews = (List<Map<String, Object>>) request.getAttribute("reviews");
    int selectedRating = request.getAttribute("selectedRating") != null ? (Integer) request.getAttribute("selectedRating") : 0;
    String message = (String) request.getAttribute("message");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reviews</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(to right, #fbeaff, #e4f9f5);
            padding: 4rem 2rem;
        }

        .home-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
        }

        .home-btn img {
            height: 60px;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .home-btn img:hover {
            transform: scale(1.05);
        }

        h2 {
            color: #00796b;
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 1rem;
            text-align: left;
            vertical-align: top;
        }

        th {
            background: #fdfbff;
            color: #6c5b7b;
        }

        select, textarea, button {
            border-radius: 6px;
        }

        textarea {
            width: 100%;
            padding: 0.6rem;
            resize: vertical;
        }

        button {
            background: #00796b;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            font-weight: bold;
            margin-top: 0.5rem;
        }

        button:hover {
            background: #57456a;
        }

        .reply-msg {
            font-style: italic;
            color: 00796b;
            margin-top: 0.5rem;
        }

        .filter-form {
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>

<a href="StaffDashboardServlet" class="home-btn">
    <img src="images/logo1.png" alt="home-btn">
</a>

<h2>Customer Feedback</h2>

<!-- SweetAlert2 Message -->
<% if (message != null && !message.isEmpty()) { %>
<script>
    Swal.fire({
        icon: 'success',
        title: 'Success',
        text: '<%= message.replace("'", "\\'") %>',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 2500,
        timerProgressBar: true,
        background: '#fdfbff',
        color: '#6c5b7b'
    });
</script>
<% } %>

<!-- Filter -->
<form method="GET" class="filter-form">
    <label for="rating">Filter by Rating:</label>
    <select name="rating" onchange="this.form.submit()">
        <option value="0">-- All Ratings --</option>
        <% for (int i = 1; i <= 5; i++) { %>
            <option value="<%= i %>" <%= selectedRating == i ? "selected" : "" %>><%= i %> Star</option>
        <% } %>
    </select>
</form>

<% if (reviews != null && !reviews.isEmpty()) { %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Customer</th>
            <th>Order ID</th>
            <th>Date</th>
            <th>Rating</th>
            <th>Feedback</th>
            <th>Reply</th>
        </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> r : reviews) {
            Timestamp ts = (Timestamp) r.get("created_at");
            String existingReply = (String) r.get("reply");
        %>
        <tr>
            <td><%= r.get("full_name") %></td>
            <td>#<%= r.get("order_id") %></td>
            <td><%= sdf.format(ts) %></td>
            <td><%= r.get("rating") %> ⭐</td>
            <td><%= r.get("feedback") %></td>
            <td>
                <% if (existingReply != null && !existingReply.trim().isEmpty()) { %>
                    <textarea readonly rows="3"><%= existingReply %></textarea>
                    <div class="reply-msg">✅ You have replied to this review.</div>
                <% } else { %>
                    <form method="post" action="ManageReviewServlet">
                        <input type="hidden" name="feedback_id" value="<%= r.get("id") %>">
                        <textarea name="reply" rows="3" placeholder="Reply to this review..." required></textarea>
                        <button type="submit">Submit</button>
                    </form>
                <% } %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
<% } else { %>
    <p>No feedback found for the selected filter.</p>
<% } %>

</body>
</html>
