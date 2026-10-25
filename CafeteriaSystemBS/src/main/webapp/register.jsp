<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    String msg = request.getParameter("msg");
    String status = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - Cafeteria System</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e8f0f7, #dceef2);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        form {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
            text-align: center;
            width: 340px;
        }
        h2 {
            margin-bottom: 1.5rem;
            color: #2c3e50;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"],
        select {
            width: 90%;
            padding: 0.6rem;
            margin-bottom: 1rem;
            border: 1px solid #b0bec5;
            border-radius: 10px;
            font-size: 1rem;
            background-color: #f5fafd;
        }
        button {
            background-color: #81d4fa;
            color: #1e2a38;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1rem;
            width: 100%;
        }
        button:hover {
            background-color: #4fc3f7;
        }
        p {
            margin-top: 1rem;
            font-size: 0.95rem;
            color: #546e7a;
        }
        a {
            color: #00796b;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<form name="regForm" method="POST" action="RegisterServlet" onsubmit="return validateForm();">
    <h2>Register</h2>
    <input type="hidden" name="action" value="register">
    <input type="text" name="username" placeholder="Username" required><br>
    <input type="password" name="password" placeholder="Password (min 5 chars)" required><br>
    <input type="password" name="confirm_password" placeholder="Confirm Password" required><br>
    <input type="email" name="email" placeholder="Email" required><br>
    <input type="text" name="full_name" placeholder="Full Name" required><br>
    <select name="role" required>
        <option value="">Select Role</option>
        <option value="customer">Customer</option>
        <option value="staff">Staff</option>
    </select><br>
    <button type="submit">Register</button>
    <p>Already have an account? <a href="login.jsp">Login here</a>.</p>
</form>

<script>
    function validateForm() {
        const form = document.forms["regForm"];
        const username = form["username"].value.trim();
        const password = form["password"].value;
        const confirm = form["confirm_password"].value;
        const email = form["email"].value.trim();
        const fullName = form["full_name"].value.trim();
        const role = form["role"].value;

        if (!username || !password || !confirm || !email || !fullName || !role) {
            alert("All fields are required.");
            return false;
        }

        if (password.length < 5) {
            alert("Password must be at least 5 characters long.");
            return false;
        }

        if (password !== confirm) {
            alert("Passwords do not match.");
            return false;
        }

        if (role !== "customer" && role !== "staff") {
            alert("Invalid role selected.");
            return false;
        }

        return true;
    }

    <% if (msg != null) { %>
        window.onload = function () {
            Swal.fire({
                icon: '<%= "success".equals(status) ? "success" : "error" %>',
                title: '<%= "success".equals(status) ? "Registered!" : "Oops..." %>',
                text: '<%= msg.replaceAll("'", "\\\\'") %>',
                timer: 3000,
                showConfirmButton: false
            }).then(() => {
                <% if ("success".equals(status)) { %>
                    window.location.href = "login.jsp";
                <% } %>
            });
        };
    <% } %>
</script>

</body>
</html>
