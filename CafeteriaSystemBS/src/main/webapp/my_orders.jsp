<%@ page import="java.util.*, java.sql.Timestamp, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Map<String, Object>> orders = (List<Map<String, Object>>) request.getAttribute("orders");
    Set<Integer> reviewedOrderIds = (Set<Integer>) request.getAttribute("reviewedOrderIds");

    Map<Integer, List<Map<String, Object>>> grouped = new LinkedHashMap<>();
    Map<Integer, Map<String, Object>> orderSummary = new LinkedHashMap<>();

    for (Map<String, Object> row : orders) {
        int oid = (int) row.get("order_id");
        grouped.computeIfAbsent(oid, k -> new ArrayList<>()).add(row);

        if (!orderSummary.containsKey(oid)) {
            Map<String, Object> info = new HashMap<>();
            info.put("timestamp", row.get("timestamp"));
            info.put("total_price", row.get("total_price"));
            orderSummary.put(oid, info);
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #fdfbfb, #ebedee);
            margin: 0;
            padding: 4rem 20px 20px;
            color: #333;
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
            text-align: center;
        }

        .order-section {
            background: #ffffff;
            border: 1px solid #ddd;
            border-left: 6px solid #c06c84;
            margin-bottom: 25px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.04);
        }

        .order-section h3 {
            margin-top: 0;
            color: #355c7d;
        }

        .status-label {
            font-weight: bold;
            padding: 4px 10px;
            border-radius: 12px;
            color: white;
        }

        .status-pending {
            background-color: #e67e22;
        }

        .status-inprocess {
            background-color: #3498db;
        }

        .status-completed {
            background-color: #27ae60;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            margin-bottom: 15px;
            background: #fdfdfd;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #f7f1ff;
            color: #6c5b7b;
        }

        .review-button, .pickup-button {
            background-color: #88d8b0;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            text-decoration: none;
            font-weight: bold;
            margin-right: 10px;
            display: inline-block;
        }

        .review-button:hover, .pickup-button:hover {
            background-color: #6cd4a3;
        }

        .pickup-info {
            margin-top: 10px;
            font-weight: 500;
            color: #444;
        }

        .completed {
            color: #27ae60;
            font-weight: bold;
        }

        .estimate-time {
            color: #2980b9;
            font-weight: bold;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<a href="CustomerDashboardServlet1" class="home-btn">
    <img src="images/logo1.png" alt="Home">
</a>

<h2>My Orders</h2>

<% if (grouped.isEmpty()) { %>
    <p style="text-align:center;">You have no orders yet.</p>
<% } else {
    for (int orderId : grouped.keySet()) {
        Map<String, Object> info = orderSummary.get(orderId);
        List<Map<String, Object>> items = grouped.get(orderId);
        Map<String, Object> firstItem = items.get(0);
        String status = (String) firstItem.get("status");
        String pickupStatus = (String) firstItem.get("pickup_status");
        Integer queueNo = (Integer) firstItem.get("queue_number");
        Timestamp estTime = (Timestamp) firstItem.get("estimated_time");

        String statusClass = "status-pending";
        if ("in process".equalsIgnoreCase(status)) statusClass = "status-inprocess";
        else if ("completed".equalsIgnoreCase(status)) statusClass = "status-completed";
%>

<div class="order-section">
    <h3>
        Order #<%= orderId %> -
        <span class="status-label <%= statusClass %>">
            <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
        </span>
    </h3>
    <p>Total: <strong>RM<%= String.format("%.2f", info.get("total_price")) %></strong> | Placed at: <%= info.get("timestamp") %></p>

    <% if (queueNo != null || pickupStatus != null) { %>
        <p class="pickup-info">
            Queue No: <strong><%= queueNo != null ? queueNo : "N/A" %></strong> |
            Pickup: <strong><%= pickupStatus != null ? pickupStatus : "N/A" %></strong>
        </p>
    <% } %>

    <% if ("in process".equalsIgnoreCase(status) && estTime != null) { %>
        <p class="estimate-time">⏱ Estimated Pickup Time: <%= sdf.format(estTime) %></p>
    <% } %>

    <table>
        <tr><th>Item</th><th>Qty</th><th>Price</th><th>Subtotal</th></tr>
        <% double total = 0;
           for (Map<String, Object> item : items) {
               int qty = (int) item.get("quantity");
               double price = (double) item.get("price");
               double subtotal = qty * price;
               total += subtotal;
        %>
        <tr>
            <td><%= item.get("name") %></td>
            <td><%= qty %></td>
            <td>RM<%= String.format("%.2f", price) %></td>
            <td>RM<%= String.format("%.2f", subtotal) %></td>
        </tr>
        <% } %>
        <tr>
            <td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
            <td><strong>RM<%= String.format("%.2f", total) %></strong></td>
        </tr>
    </table>

    <% if ("ready".equalsIgnoreCase(pickupStatus)) { %>
        <form method="post" action="ConfirmPickupServlet">
            <input type="hidden" name="order_id" value="<%= orderId %>">
            <button class="pickup-button" type="submit">I've Picked Up</button>
        </form>
    <% } else if ("picked up".equalsIgnoreCase(pickupStatus)) {
            if (reviewedOrderIds == null || !reviewedOrderIds.contains(orderId)) {
    %>
        <a class="review-button" href="GiveReviewServlet?order_id=<%= orderId %>">Give Review</a>
    <% } else { %>
        <p class="completed">✓ You have reviewed this order.</p>
    <% } } %>

</div>
<% } } %>

</body>
</html>
