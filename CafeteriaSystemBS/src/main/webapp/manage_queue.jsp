<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, java.sql.Timestamp" %>

<%
    List<Map<String, Object>> queueList = (List<Map<String, Object>>) request.getAttribute("queueList");
    String message = (String) request.getAttribute("message");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Queue</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(to right, #fbeaff, #e4f9f5);
            margin: 0;
            padding: 4rem 2rem 2rem;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 0.9rem;
            border: 1px solid #ddd;
            text-align: center;
        }
        select, input[type="datetime-local"] {
            padding: 5px;
            font-size: 1rem;
            margin: 0.3rem 0;
        }
        button {
            padding: 6px 12px;
            background-color: #2980b9;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #1f5f90;
        }
        .status-pending { color: #e67e22; font-weight: bold; }
        .status-ready { color: #2980b9; font-weight: bold; }
        .status-picked { color: #27ae60; font-weight: bold; }

        /* Home button */
        .home-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
        }
        .home-btn img {
            height: 60px;
            width: auto;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .home-btn img:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<div class="top-left-controls">
    <a href="StaffDashboardServlet" class="home-btn">
        <img src="images/logo1.png" alt="Home" class="logo">
    </a>
</div>

<%
    String messages = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>

<% if (message != null) { %>
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: '<%= message %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    </script>
<% } else if (error != null) { %>
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: '<%= error %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    </script>
<% } %>


<h2>Order Pickup Queue</h2>

<table>
    <tr>
        <th>Queue #</th>
        <th>Order ID</th>
        <th>Status</th>
        <th>Estimated Time</th>
        <th>Action</th>
    </tr>

<%
    for (Map<String, Object> row : queueList) {
        String status = (String) row.get("pickup_status");
        String statusClass = switch (status) {
            case "pending" -> "status-pending";
            case "ready" -> "status-ready";
            case "picked up" -> "status-picked";
            default -> "";
        };

        Timestamp estTime = (Timestamp) row.get("estimated_time");
        String formattedTime = (estTime != null) ? sdf.format(estTime) : "-";
%>
    <tr>
        <td><%= row.get("queue_number") %></td>
        <td><%= row.get("order_id") %></td>
        <td class="<%= statusClass %>"><%= status.substring(0,1).toUpperCase() + status.substring(1) %></td>
        <td><%= formattedTime %></td>
        <td>
            <form method="post" action="ManageQueueServlet">
                <input type="hidden" name="queue_id" value="<%= row.get("id") %>">

                <select name="pickup_status">
                    <option value="pending" <%= "pending".equals(status) ? "selected" : "" %>>Pending</option>
                    <option value="ready" <%= "ready".equals(status) ? "selected" : "" %>>Ready</option>
                    <option value="picked up" <%= "picked up".equals(status) ? "selected" : "" %>>Picked Up</option>
                </select>

                <input type="datetime-local" name="estimated_time"
                       value="<%= (estTime != null) ? estTime.toLocalDateTime().toString().replace(" ", "T") : "" %>">

                <button type="submit">Update</button>
            </form>
        </td>
    </tr>
<% } %>
</table>
</body>
</html>
