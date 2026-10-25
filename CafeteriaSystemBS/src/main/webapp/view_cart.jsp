<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    double total = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Cart</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f7f7f7; margin: 0; }
        h2 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; background: #fff; box-shadow: 0 0 5px rgba(0,0,0,0.1); }
        th, td { padding: 12px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #eaeaea; }
        .btn-group { text-align: center; margin-top: 10px; }
        .btn-group button { padding: 10px 20px; margin-right: 10px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .btn-group button:last-child { background: #dc3545; }
        .btn-group button:hover { opacity: 0.9; }
        .remove-btn { background: #ffc107; color: #000; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 14px; }
        .remove-btn:hover { background: #e0a800; }
        .back-link { display: inline-block; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }
        .back-link:hover { background: #0056b3; }
        .total-row td { font-weight: bold; background-color: #f8f9fa; }
        .home-btn { position: fixed; top: 20px; left: 20px; z-index: 999; }
        .home-btn img { height: 60px; width: auto; cursor: pointer; transition: transform 0.2s ease; }
        .home-btn img:hover { transform: scale(1.05); }
    </style>
</head>
<body>

<a href="CustomerDashboardServlet1" class="home-btn">
    <img src="images/logo1.png" alt="Home">
</a>

<h2>My Cart</h2>

<% if (cart != null && !cart.isEmpty()) { %>
    <table>
        <tr><th>Name</th><th>Qty</th><th>Price</th><th>Action</th></tr>
        <% for (int i = 0; i < cart.size(); i++) {
            Map<String, Object> item = cart.get(i);
            int qty = (int) item.get("quantity");
            double price = (double) item.get("price");
            double subtotal = qty * price;
            total += subtotal;
        %>
        <tr>
            <td><%= item.get("name") %></td>
            <td><%= qty %></td>
            <td>RM<%= String.format("%.2f", subtotal) %></td>
            <td><a href="ViewCartServlet?remove=<%= i %>" class="remove-btn" onclick="return confirm('Remove this item?')">Remove</a></td>
        </tr>
        <% } %>
        <tr class="total-row">
            <td colspan="2">Total</td>
            <td colspan="2">RM<%= String.format("%.2f", total) %></td>
        </tr>
    </table>

    <form method="post" class="btn-group" action="ViewCartServlet">
        <button type="submit" name="action" value="checkout" onclick="return confirm('Proceed to checkout?')">Checkout</button>
        <button type="submit" name="action" value="clear" onclick="return confirm('Clear all items in cart?')">Clear Cart</button>
    </form>
<% } else { %>
    <p style="text-align:center;">Your cart is empty.</p>
<% } %>

<div style="text-align:center;">
    <a href="CustomerBrowseMenuServlet" class="back-link">← Back to Menu</a>
</div>

</body>
</html>
