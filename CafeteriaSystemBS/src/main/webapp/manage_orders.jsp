<%@ page import="java.util.*, com.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Orders</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #fbeaff, #e4f9f5);
            margin: 0;
            padding: 4rem 2rem 2rem;
        }
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
        h2 {
            color: #6c5b7b;
            margin-bottom: 1rem;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        th, td {
            padding: 0.8rem;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #fdfbff;
            color: #6c5b7b;
        }
        td {
            color: #555;
        }
        select {
            padding: 0.4rem;
            border-radius: 6px;
            border: 1px solid #ccc;
            background-color: #fdfbff;
        }
        button {
            background-color: #a8e6cf;
            border: none;
            padding: 0.4rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            margin-left: 0.5rem;
        }
        button:hover {
            background-color: #dcedc1;
        }
        form {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Toast styles */
        #toast-container {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
        }
        .toast {
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: bold;
            font-family: 'Segoe UI', sans-serif;
            animation: slideDown 0.3s ease, fadeOut 3.5s forwards;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            opacity: 0.95;
            margin-top: 10px;
        }
        .toast-success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d0e9c6;
        }
        .toast-error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        @keyframes slideDown {
            from { transform: translate(-50%, -20px); opacity: 0; }
            to { transform: translate(-50%, 0); opacity: 1; }
        }
        @keyframes fadeOut {
            0%, 85% { opacity: 1; }
            100% { opacity: 0; }
        }
    </style>
</head>
<body>
<a href="StaffDashboardServlet" class="home-btn">
    <img src="images/logo1.png" alt="Home">
</a>

<h2>Manage Orders</h2>

<!-- Toast container -->
<div id="toast-container"></div>

<table>
    <tr>
        <th>ID</th>
        <th>User</th>
        <th>Total</th>
        <th>Status</th>
        <th>Update</th>
    </tr>
    <%
        if (orders != null) {
            for (Order order : orders) {
    %>
    <tr>
        <td><%= order.getId() %></td>
        <td><%= order.getCustomerName() %></td>
        <td>RM<%= order.getTotal() %></td>
        <td><%= order.getStatus() %></td>
        <td>
            <% if ("completed".equals(order.getStatus())) { %>
                <span style="color: green; font-weight: bold;">✔ Completed</span>
            <% } else { %>
                <form method="post" action="ManageOrdersServlet">
                    <input type="hidden" name="order_id" value="<%= order.getId() %>" />
                    <select name="status">
                        <option value="pending" <%= "pending".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="in process" <%= "in process".equals(order.getStatus()) ? "selected" : "" %>>In Process</option>
                        <option value="completed">Completed</option>
                    </select>
                    <button type="submit">Update</button>
                </form>
            <% } %>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>

<% if (message != null && messageType != null) { %>
<script>
    window.onload = function() {
        showToast("<%= message %>", "<%= messageType %>");
    };

    function showToast(message, type) {
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        toast.textContent = message;
        document.getElementById('toast-container').appendChild(toast);

        setTimeout(() => {
            toast.remove();
        }, 3500);
    }
</script>
<% } %>

</body>
</html>
