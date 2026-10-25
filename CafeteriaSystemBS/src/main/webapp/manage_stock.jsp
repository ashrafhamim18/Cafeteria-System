<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.model.Menu" %>
<%@ page import="java.util.List" %>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<html>
<head>
    <title>Manage Stock</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #fbeaff, #e4f9f5);
            margin: 0;
            padding: 4rem 2rem 2rem;
        }

        h2 {
            text-align: center;
            color: #6c5b7b;
            margin-bottom: 30px;
        }

        table {
            border-collapse: collapse;
            width: 90%;
            margin: auto;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
            font-size: 0.95rem;
        }

        th {
            background-color: #fdfbff;
            color: #6c5b7b;
        }

        td {
            background-color: #fdfbff;
        }

        input[type=number] {
            width: 60px;
            text-align: center;
            padding: 5px;
            border: 1px solid #b0bec5;
            border-radius: 8px;
            background-color: #f5fafd;
        }

        .btn, .adjust-btn {
            background-color: #a8e6cf;
            color: #333;
            padding: 6px 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .btn:hover, .adjust-btn:hover {
            background-color: #dcedc1;
        }

        .adjust-btn {
            padding: 4px 10px;
            margin: 0 5px;
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
    </style>

    <!-- ✅ SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        function adjustQuantity(button, increment) {
            const input = button.parentElement.querySelector("input[name='stock_quantity']");
            let value = parseInt(input.value);
            value = isNaN(value) ? 0 : value;
            value += increment;
            if (value >= 0) input.value = value;
        }
    </script>
</head>
<body>

<div class="top-left-controls">
    <a href="StaffDashboardServlet" class="home-btn">
        <img src="images/logo1.png" alt="Home" class="logo">
    </a>
</div>

<h2>Manage Stock</h2>

<% if (success != null) { %>
<script>
    window.onload = () => {
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'success',
            title: '<%= success %>',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    };
</script>
<% } else if (error != null) { %>
<script>
    window.onload = () => {
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'error',
            title: '<%= error %>',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    };
</script>
<% } %>

<form method="post" action="ManageStockServlet">
    <table>
        <tr>
            <th>No</th>
            <th>Menu Name</th>
            <th>Current Stock</th>
            <th>New Quantity</th>
        </tr>
        <%
            int count = 1;
            com.dao.StockDAO stockDAO = new com.dao.StockDAO(com.dao.DBConnection.getConnection());
            for (Menu menu : menuList) {
                int stockQty = stockDAO.getStockQuantity(menu.getId());
        %>
        <tr>
            <td><%= count++ %></td>
            <td><%= menu.getName() %></td>
            <td><%= stockQty %></td>
            <td>
                <input type="hidden" name="menu_id" value="<%= menu.getId() %>">
                <button type="button" class="adjust-btn" onclick="adjustQuantity(this, -1)">−</button>
                <input type="number" name="stock_quantity" value="<%= stockQty %>" min="0">
                <button type="button" class="adjust-btn" onclick="adjustQuantity(this, 1)">+</button>
            </td>
        </tr>
        <% } %>
    </table>
    <div style="text-align:center; margin-top:20px;">
        <button class="btn" type="submit">Update Stock</button>
    </div>
</form>

</body>
</html>
