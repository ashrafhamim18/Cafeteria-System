<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String dashboardLink = "login.jsp"; // fallback
    if (user != null) {
        if ("staff".equalsIgnoreCase(user.getRole())) {
            dashboardLink = "StaffDashboardServlet";
        } else if ("customer".equalsIgnoreCase(user.getRole())) {
            dashboardLink = "CustomerDashboardServlet1";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary-color: #3498db;
            --primary-dark: #2980b9;
            --bg-color: #f0f6fc;
            --text-color: #333;
            --card-bg: #fff;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--bg-color);
            padding: 40px;
            margin: 0;
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
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 30px;
        }

        form {
            background: var(--card-bg);
            padding: 25px 30px;
            max-width: 420px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px;
            margin-top: 10px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: var(--primary-dark);
        }

        a {
            display: block;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
            color: var(--primary-color);
            transition: color 0.3s ease;
        }

        a:hover {
            color: var(--primary-dark);
        }
    </style>
</head>
<body>
<div class="top-left-controls">
    <a href="<%= dashboardLink %>" class="home-btn">
        <img src="images/logo1.png" alt="Home" class="logo">
    </a>
</div>

<div class="container">
    <h2>Change Password</h2>
    <form method="post" action="ChangePasswordServlet">
        <label>Current Password</label>
        <input type="password" name="currentPassword" required>

        <label>New Password</label>
        <input type="password" name="newPassword" required>

        <label>Confirm New Password</label>
        <input type="password" name="confirmPassword" required>

        <button type="submit">Update Password</button>
    </form>
</div>

<%-- SweetAlert2 toast for success or error --%>
<% if (request.getAttribute("error") != null) { %>
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: '<%= request.getAttribute("error") %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    </script>
<% } else if (request.getAttribute("message") != null) { %>
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Success',
            text: '<%= request.getAttribute("message") %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    </script>
<% } %>

</body>
</html>
