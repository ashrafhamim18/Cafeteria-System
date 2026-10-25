<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<Map<String, Object>> todayOrders = (List<Map<String, Object>>) request.getAttribute("todayOrders");
    String fullName = (String) request.getAttribute("fullName");

    double totalSales = (double) request.getAttribute("totalSales");
    int totalOrders = (int) request.getAttribute("totalOrders");
    int pending = (int) request.getAttribute("pending");
    int inProcess = (int) request.getAttribute("inProcess");
    int completed = (int) request.getAttribute("completed");

    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");

    String success = (String) request.getAttribute("msg"); // ✅ FIXED LINE
    String error = (String) session.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* [Your CSS remains untouched] */
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f1f8fc;
            display: flex;
        }
        .top-left-controls {
            position: fixed;
            top: 20px;
            left: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            z-index: 1001;
        }
        .toggle-btn {
            width: 50px;
            height: 50px;
            background-color: #00796b;
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 1.5rem;
            cursor: pointer;
        }
        .home-btn img.logo {
            height: 60px;
            cursor: pointer;
        }
        .sidebar {
            width: 220px;
            background-color: #ffffff;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            height: 100vh;
        }
        .sidebar.hidden {
            transform: translateX(-100%);
        }
        .sidebar h2 {
            margin-top: 80px;
            color: #2c3e50;
        }
        .sidebar a {
            display: block;
            margin: 12px 0;
            text-decoration: none;
            color: #00796b;
            font-weight: 500;
        }
        .sidebar a:hover {
            color: #004d40;
        }
        .content {
            flex-grow: 1;
            padding: 2rem;
            width: 100%;
        }
        .logout-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #ff6b6b;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .card {
            flex: 1;
            min-width: 220px;
            background: white;
            padding: 20px;
            border-left: 6px solid #00796b;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .card h3 {
            margin: 0 0 10px;
            color: #333;
        }
        .card p {
            font-size: 1.5rem;
            color: #00796b;
        }
        #statusChart {
            max-width: 600px;
            margin: 0 auto 40px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            background: #fff;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #e0f7fa;
        }
        .btn-view {
            background-color: #00796b;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            text-decoration: none;
        }
        .filter-box {
            margin-bottom: 20px;
        }
        .status.pending { color: #ff9800; font-weight: bold; }
        .status.in-process { color: #2196f3; font-weight: bold; }
        .status.completed { color: #4caf50; font-weight: bold; }
    </style>
</head>
<body>
<% String msg = (String) request.getAttribute("msg"); %>
<!-- ✅ SweetAlert Toasts -->
<script>
    window.onload = function () {
        <% if (success != null && !success.isEmpty()) { %>
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'success',
            title: '<%= msg.replaceAll("\"", "\\\\\"") %>',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer);
                toast.addEventListener('mouseleave', Swal.resumeTimer);
            }
        });
        <% } else if (error != null && !error.isEmpty()) { %>
        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'error',
            title: '<%= error.replaceAll("\"", "\\\\\"") %>',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer);
                toast.addEventListener('mouseleave', Swal.resumeTimer);
            }
        });
        <% } %>
    };
</script>

<% session.removeAttribute("success"); session.removeAttribute("error"); %>

<div class="top-left-controls">
    <button class="toggle-btn" onclick="toggleSidebar()">☰</button>
    <a href="StaffDashboardServlet" class="home-btn">
        <img src="images/logo1.png" alt="Home" class="logo">
    </a>
</div>

<div class="sidebar" id="sidebar">
    <h2>Staff Panel</h2>
    <a href="ManageMenuServlet">Manage Menu</a>
    <a href="ManageOrdersServlet">Manage Orders</a>
    <a href="ManageStockServlet">Manage Stock</a>
    <a href="ManageQueueServlet">Manage Queue</a>
    <a href="ManageReviewServlet">View Reviews</a>
    <a href="ChangePasswordServlet">Change Password</a>
</div>

<div class="content">
    <a href="LogOutServlet" class="logout-btn">Logout</a>
    <h1>Welcome, <%= fullName %>!</h1>
    <p>This is your staff dashboard.</p>

    <div class="cards">
        <div class="card"><h3>Total Sales (Today)</h3><p>RM <%= String.format("%.2f", totalSales) %></p></div>
        <div class="card"><h3>Total Orders</h3><p><%= totalOrders %></p></div>
        <div class="card"><h3>Pending</h3><p><%= pending %></p></div>
        <div class="card"><h3>In Process</h3><p><%= inProcess %></p></div>
        <div class="card"><h3>Completed</h3><p><%= completed %></p></div>
    </div>

    <canvas id="statusChart"></canvas>

    <h2>Today's Orders</h2>
    <div class="filter-box">
        <label for="statusFilter"><strong>Filter by Status:</strong></label>
        <select id="statusFilter" onchange="filterTable()">
            <option value="">All</option>
            <option value="pending">Pending</option>
            <option value="in process">In Process</option>
            <option value="completed">Completed</option>
        </select>
    </div>

    <% if (!todayOrders.isEmpty()) { %>
    <table id="ordersTable">
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Status</th>
            <th>Total (RM)</th>
            <th>Time</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> order : todayOrders) {
            String status = (String) order.get("status");
            String statusClass = status.toLowerCase().replace(" ", "-");
        %>
            <tr>
                <td><%= order.get("id") %></td>
                <td><%= order.get("full_name") %></td>
                <td class="status <%= statusClass %>"><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></td>
                <td><%= String.format("%.2f", (Double) order.get("total_price")) %></td>
                <td><%= timeFormat.format(order.get("created_at")) %></td>
                <td><a class="btn-view" href="ManageOrdersServlet?orderId=<%= order.get("id") %>">View Details</a></td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
        <p>No orders received today.</p>
    <% } %>
</div>

<script>
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('hidden');
    }

    function filterTable() {
        const status = document.getElementById("statusFilter").value.toLowerCase();
        const rows = document.querySelectorAll("#ordersTable tbody tr");
        rows.forEach(row => {
            const cell = row.cells[2].textContent.toLowerCase();
            row.style.display = (status === "" || cell === status) ? "" : "none";
        });
    }

    const ctx = document.getElementById('statusChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Pending', 'In Process', 'Completed'],
            datasets: [{
                label: 'Order Status Count',
                data: [<%= pending %>, <%= inProcess %>, <%= completed %>],
                backgroundColor: ['#ff9800', '#2196f3', '#4caf50']
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                title: { display: true, text: "Today's Order Status Breakdown" }
            },
            scales: {
                y: { beginAtZero: true, precision: 0 }
            }
        }
    });
</script>

</body>
</html>
