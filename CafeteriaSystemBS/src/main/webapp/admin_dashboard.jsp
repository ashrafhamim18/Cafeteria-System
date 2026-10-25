<%@ page import="java.util.*, com.model.User" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<User> users = (List<User>) request.getAttribute("users");
    String search = (String) request.getAttribute("search");
    String filter = (String) request.getAttribute("filter");
    int total = (Integer) request.getAttribute("total_users");
    int admins = (Integer) request.getAttribute("admins");
    int staff = (Integer) request.getAttribute("staff");
    int customers = (Integer) request.getAttribute("customers");
    String msg = request.getParameter("msg") != null ? request.getParameter("msg") : "";
    String success = (String) session.getAttribute("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #fbeaff, #e4f9f5);
            padding: 4rem 2rem 2rem;
            margin: 0;
        }

        .header {
            background-color: #6c5b7b;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 999;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            margin: 0;
            font-size: 1.8rem;
        }

        .dashboard-summary {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 6rem;
            margin-bottom: 2rem;
        }

        .summary-box {
            background: linear-gradient(135deg, #f3c6f1, #c1f3e8);
            padding: 1.5rem;
            border-radius: 50%;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            font-weight: bold;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            color: #6c5b7b;
            width: 180px;
            height: 180px;
            text-align: center;
            border: 4px dashed #ffb6c1;
            transition: transform 0.3s ease;
        }

        .summary-box:hover {
            transform: scale(1.05);
        }

        .summary-box strong {
            font-size: 2.4rem;
            color: #ff6b6b;
            margin-top: 0.5rem;
        }

        .container {
            padding: 1rem 2rem;
        }

        .actions {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        input[type="text"], select {
            padding: 0.5rem;
            font-size: 1rem;
            margin-right: 0.5rem;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .logoutbtn {
            padding: 0.5rem 1rem;
            background-color: #ff6b6b;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background-color 0.3s;
        }

        .logoutbtn:hover {
            background-color: #e63946;
        }

        .btn {
            padding: 0.5rem 1rem;
            background-color: #a8e6cf;
            color: #333;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            min-width: 80px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #dcedc1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            background-color: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        table th, table td {
            padding: 0.8rem;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #fdfbff;
            color: #6c5b7b;
        }

        .msg {
            background-color: #c8f7c5;
            padding: 1rem;
            margin: 1rem 2rem;
            color: green;
            border-left: 5px solid green;
            border-radius: 4px;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 99;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: white;
            margin: 8% auto;
            padding: 2rem;
            border-radius: 16px;
            width: 40%;
            box-shadow: 0 0 20px rgba(0,0,0,0.2);
            border: 2px dashed #fcb69f;
            animation: fadeIn 0.3s ease;
        }

        .modal-content input, .modal-content select {
            width: 100%;
            padding: 0.6rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .close {
            float: right;
            cursor: pointer;
            font-size: 1.2rem;
            font-weight: bold;
            color: #ff6b6b;
        }

        .close:hover {
            color: #e63946;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Admin Dashboard</h1>
    <form action="LogOutServlet" method="post">
        <button class="logoutbtn">Logout</button>
    </form>
</div>

<div class="dashboard-summary">
    <div class="summary-box">Total Users<br><strong><%= total %></strong></div>
    <div class="summary-box">Admins<br><strong><%= admins %></strong></div>
    <div class="summary-box">Staff<br><strong><%= staff %></strong></div>
    <div class="summary-box">Customers<br><strong><%= customers %></strong></div>
</div>

<div class="container">
    <form class="actions" method="get" action="AdminDashboardServlet">
        <div>
            <input type="text" name="search" placeholder="Search fullname..." value="<%= search %>">
            <select name="filter">
                <option value="">All Roles</option>
                <option value="admin" <%= "admin".equals(filter) ? "selected" : "" %>>Admin</option>
                <option value="staff" <%= "staff".equals(filter) ? "selected" : "" %>>Staff</option>
                <option value="customer" <%= "customer".equals(filter) ? "selected" : "" %>>Customer</option>
            </select>
            <button class="btn" type="submit">Search</button>
        </div>
        <button class="btn" type="button" onclick="openModal()">+ Add User</button>
    </form>

    <table>
        <tr>
            <th>ID</th><th>Full Name</th><th>Username</th><th>Email</th><th>Role</th><th>Actions</th>
        </tr>
        <% for (User u : users) { %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRole() %></td>
                <td>
                    <form method="post" action="AdminDashboardServlet" style="display:inline-block">
                        <input type="hidden" name="id" value="<%= u.getId() %>">
                        <input type="hidden" name="action" value="delete">
                        <button class="btn" type="submit" onclick="return confirm('Are you sure to delete this user?')">Delete</button>
                    </form>
                    <button class="btn" onclick="editUser('<%= u.getId() %>', '<%= u.getFullName() %>', '<%= u.getUsername() %>', '<%= u.getEmail() %>', '<%= u.getPassword() %>', '<%= u.getRole() %>')">Edit</button>
                </td>
            </tr>
        <% } %>
    </table>
</div>

<!-- Modal -->
<div id="userModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">×</span>
        <form method="post" action="AdminDashboardServlet">
            <input type="hidden" name="id" id="userId">
            <input type="hidden" name="action" value="add" id="formAction">
            <label>Full Name:</label>
            <input type="text" name="full_name" id="fullName" required>
            <label>Username:</label>
            <input type="text" name="username" id="username" required>
            <label>Email:</label>
            <input type="email" name="email" id="email" required>
            <label>Password:</label>
            <input type="text" name="password" id="password" required>
            <label>Role:</label>
            <select name="role" id="role" required>
                <option value="admin">Admin</option>
                <option value="staff">Staff</option>
                <option value="customer">Customer</option>
            </select>
            <button class="btn" type="submit">Save</button>
        </form>
    </div>
</div>

<!-- ✅ SweetAlert Toast Notification -->
<script>
    window.onload = function () {
        <% if (msg != null && !msg.isEmpty()) { %>
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
        <% } else if (success != null && !success.isEmpty()) { %>
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: '<%= success.replaceAll("\"", "\\\\\"") %>',
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

<% session.removeAttribute("success"); %>

<script>
    function openModal() {
        document.getElementById('userModal').style.display = 'block';
        document.getElementById('formAction').value = 'add';
        document.getElementById('userId').value = '';
        document.getElementById('fullName').value = '';
        document.getElementById('username').value = '';
        document.getElementById('email').value = '';
        document.getElementById('password').value = '';
        document.getElementById('role').value = 'customer';
    }

    function closeModal() {
        document.getElementById('userModal').style.display = 'none';
    }

    function editUser(id, fullName, username, email, password, role) {
        openModal();
        document.getElementById('formAction').value = 'update';
        document.getElementById('userId').value = id;
        document.getElementById('fullName').value = fullName;
        document.getElementById('username').value = username;
        document.getElementById('email').value = email;
        document.getElementById('password').value = password;
        document.getElementById('role').value = role;
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('userModal')) {
            closeModal();
        }
    }
</script>
</body>
</html>