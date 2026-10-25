<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.model.Menu" %>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    String selectedCategory = request.getAttribute("selectedCategory") != null ? (String) request.getAttribute("selectedCategory") : "";
    String selectedAvailability = request.getAttribute("selectedAvailability") != null ? (String) request.getAttribute("selectedAvailability") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Menu</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            margin: 0;
            padding: 4rem 2rem 2rem;
            color: #333;
            position: relative;
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
            transform: scale(1.1);
        }
        .cart-btn {
            position: fixed;
            top: 90px;
            left: 20px;
            z-index: 1000;
        }
        .cart-btn img {
            height: 60px;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .cart-btn img:hover {
            transform: scale(1.1);
        }
        h2 {
            color: #2f4f4f;
            text-align: center;
        }
        form.filter-form {
            text-align: center;
            margin-bottom: 30px;
        }
        form select {
            padding: 8px 12px;
            border-radius: 6px;
            margin: 0 10px;
            border: 1px solid #ccc;
        }
        .food-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 2rem;
        }
        .preview-card {
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            text-align: center;
        }
        .preview-card:hover {
            transform: scale(1.05);
        }
        .preview-card img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 8px;
        }
        .preview-card h3 {
            margin: 10px 0 5px;
            color: #00796b;
        }
        .preview-card p {
            font-size: 0.95rem;
            color: #555;
            margin: 0 0 10px;
        }
        .preview-card .price {
            font-weight: bold;
            margin-bottom: 0.5rem;
            font-size: 1rem;
        }
        .preview-card form {
            display: flex;
            justify-content: center;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .qty-btn {
            background-color: #8fd3f4;
            color: #1e2a38;
            border: none;
            width: 28px;
            height: 28px;
            border-radius: 6px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
        }
        .qty-btn:hover {
            background-color: #6ec1e4;
        }
        input[type="number"] {
            width: 50px;
            padding: 0.4rem;
            border-radius: 6px;
            border: 1px solid #b0c4de;
            background-color: #f5faff;
            text-align: center;
        }
        .add-btn {
            background-color: #00796b;
            color: white;
            padding: 0.4rem 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .add-btn:hover {
            background-color: #004d40;
        }
        em {
            color: #b22222;
            font-weight: bold;
        }
    </style>
</head>
<body>

<!-- Home Button -->
<a href="CustomerDashboardServlet1" class="home-btn">
    <img src="images/logo1.png" alt="Home">
</a>

<!-- Cart Button -->
<a href="ViewCartServlet" class="cart-btn">
    <img src="images/cart1.png" alt="Cart">
</a>

<h2>Browse Menu</h2>

<!-- Filter Form -->
<form method="get" action="CustomerBrowseMenuServlet" class="filter-form">
    <label>Category:</label>
    <select name="category">
        <option value="">All</option>
        <option value="food" <%= "food".equals(selectedCategory) ? "selected" : "" %>>Food</option>
        <option value="drink" <%= "drink".equals(selectedCategory) ? "selected" : "" %>>Drink</option>
    </select>

    <label>Availability:</label>
    <select name="availability">
        <option value="">All</option>
        <option value="available" <%= "available".equals(selectedAvailability) ? "selected" : "" %>>Available</option>
        <option value="unavailable" <%= "unavailable".equals(selectedAvailability) ? "selected" : "" %>>Unavailable</option>
    </select>

    <button type="submit" class="add-btn">Filter</button>
</form>

<div class="food-grid">
    <%
        if (menuList != null) {
            for (Menu item : menuList) {
    %>
        <div class="preview-card">
            <img src="images/<%= item.getImage() %>" alt="<%= item.getName() %>">
            <h3><%= item.getName() %></h3>
            <p><%= item.getDescription() %></p>
            <div class="price">RM<%= String.format("%.2f", item.getPrice()) %></div>

            <% if ("available".equals(item.getAvailability()) && item.getStockQuantity() > 0) { %>
            <form method="post" action="AddToCartServlet">
                <input type="hidden" name="menu_id" value="<%= item.getId() %>">
                <button type="button" class="qty-btn" onclick="adjustQty(this, -1, <%= item.getStockQuantity() %>)">−</button>
                <input type="number" name="quantity" value="1" min="1" max="<%= item.getStockQuantity() %>">
                <button type="button" class="qty-btn" onclick="adjustQty(this, 1, <%= item.getStockQuantity() %>)">+</button>
                <button type="submit" class="add-btn">Add to Cart</button>
            </form>
            <% } else { %>
                <em>Out Of Stock</em>
            <% } %>
        </div>
    <%
            }
        }
    %>
</div>

<script>
    function adjustQty(button, change, maxQty) {
        const input = button.parentElement.querySelector('input[type="number"]');
        let current = parseInt(input.value) || 1;
        current += change;
        if (current < 1) current = 1;
        if (current > maxQty) current = maxQty;
        input.value = current;
    }
</script>

</body>
</html>
