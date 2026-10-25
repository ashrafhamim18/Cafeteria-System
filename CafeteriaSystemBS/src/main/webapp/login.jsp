<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%
    String errorParam = request.getParameter("error");
    String logoutParam = request.getParameter("logout");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>

    <!-- SweetAlert2 -->
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
            overflow: hidden;
            position: relative;
        }

        #welcome {
            position: absolute;
            top: 0;
            left: 0;
            height: 100vh;
            width: 100vw;
            background-color: #b2dfdb;
            color: #2f4f4f;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            font-size: 2rem;
            z-index: 10;
            animation: slideUp 1s ease-out forwards;
            animation-delay: 0.5s;
        }

        #welcome img {
            width: 100px;
            height: 100px;
            margin-bottom: 1rem;
            animation: pulse 2s infinite ease-in-out;
        }

        @keyframes slideUp {
            0% { transform: translateY(0%); opacity: 1; }
            100% { transform: translateY(-100%); opacity: 0; visibility: hidden; }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        form {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 300px;
            z-index: 1;
            opacity: 0;
            animation: fadeIn 1s ease-out forwards;
            animation-delay: 2.2s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        h2 {
            margin-bottom: 1.5rem;
            color: #2c3e50;
        }

        input[type="text"], input[type="password"] {
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
            transition: background-color 0.3s;
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

<!-- Welcome Animation -->
<div id="welcome">
    <img src="images/logo.png" alt="Logo" />
    Welcome to Smart Cafeteria System
</div>

<form action="LoginServlet" method="post">
    <h2>Login Page</h2>
    <input type="text" name="username" placeholder="Username" required><br><br>
    <input type="password" name="password" placeholder="Password" required><br><br>
    <button type="submit">Login</button>
    <p>Don't have an account? <a href="register.jsp">Register here</a>.</p>
</form>

<!-- SweetAlert Popups -->
<script>
    <% if ("1".equals(errorParam)) { %>
        Swal.fire({
            icon: 'error',
            title: 'Login Failed',
            text: 'Invalid username or password!',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000
        });
    <% } else if ("2".equals(errorParam)) { %>
        Swal.fire({
            icon: 'warning',
            title: 'System Error',
            text: 'Something went wrong. Please try again.',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000
        });
    <% } else if ("1".equals(logoutParam)) { %>
        Swal.fire({
            icon: 'success',
            title: 'Logged Out',
            text: 'You have successfully logged out.',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000
        });
    <% } else if (success != null) { %>
        Swal.fire({
            icon: 'success',
            title: 'Login Successful',
            text: '<%= success.replaceAll("\"", "\\\\\"") %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000
        });
    <% } else if (error != null) { %>
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: '<%= error.replaceAll("\"", "\\\\\"") %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000
        });
    <% } %>
</script>

</body>
</html>
