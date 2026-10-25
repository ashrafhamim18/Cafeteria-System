<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.model.Menu" %>
<%@ page import="java.util.List" %>
<%
    com.model.User sessionUser = (com.model.User) session.getAttribute("user");
    boolean hasReadyPickup = Boolean.TRUE.equals(request.getAttribute("hasReadyPickup"));
    boolean hasUnseenReply = Boolean.TRUE.equals(request.getAttribute("hasUnseenReply"));
    String estimatedTimeMsg = (String) request.getAttribute("estimatedTimeMsg");
    List<Menu> previewItems = (List<Menu>) request.getAttribute("previewItems");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(to right, #e8f0f7, #dceef2);
            min-height: 100vh;
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
            height: 100vh;
            padding: 20px;
            transition: transform 0.3s ease;
        }

        .sidebar.hidden {
            transform: translateX(-100%);
        }

        .sidebar h3 {
            margin-top: 80px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 15px 0;
        }

        .sidebar ul li a {
            color: #00796b;
            text-decoration: none;
        }

        .content {
            flex-grow: 1;
            padding: 2rem;
            background-color: #f5fafd;
            transition: margin-left 0.3s ease;
            width: 100%;
        }

        .logout-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #ff6b6b;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
        }

        .alert {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-left: 6px solid #28a745;
            border-radius: 5px;
            margin-top: 20px;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border-left: 6px solid #ffc107;
        }

        .alert-info {
            background-color: #cce5ff;
            color: #004085;
            border-left: 6px solid #17a2b8;
        }

        .view-btn {
            margin-top: 10px;
            display: inline-block;
            padding: 8px 16px;
            background-color: #00796b;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }

        .food-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 30px;
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
        }

        .preview-card p {
            font-size: 0.95rem;
            color: #555;
            margin: 0 0 10px;
        }

        .interested-btn {
            background-color: #ffb347;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            margin-top: 8px;
        }

        .interested-btn:hover {
            background-color: #f79f1f;
        }

        /* 🔥 Top Popup Styling */
        .login-popup {
            display: none;
            position: fixed;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
            width: 350px;
            z-index: 9999;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
            border-top: 5px solid #00796b;
            animation: slideDown 0.4s ease;
        }

        .login-popup.active {
            display: block;
        }

        .login-popup h3 {
            margin-top: 0;
            color: #00796b;
        }

        .login-popup input {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .login-popup button {
            width: 100%;
            padding: 10px;
            background-color: #00796b;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .login-popup .close-btn {
            position: absolute;
            top: 5px;
            right: 10px;
            font-size: 20px;
            color: #666;
            cursor: pointer;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-30px) translateX(-50%); }
            to { opacity: 1; transform: translateY(0) translateX(-50%); }
        }
    </style>
</head>
<body>

<%
    String success = (session != null) ? (String) session.getAttribute("success") : null;
    String error = (session != null) ? (String) session.getAttribute("error") : null;
%>

<% if (success != null || error != null) { %>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
	    window.onload = function() {
	        <% if (success != null) { %>
	            Swal.fire({
	                icon: 'success',
	                title: 'Success',
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
	    };
	</script>

<%
    session.removeAttribute("success");
    session.removeAttribute("error");
} 
%>

<!-- ✅ TOP-POP LOGIN -->
<div id="loginPopup" class="login-popup">
    <span class="close-btn" onclick="hideLoginPopup()">×</span>
    <h3>Login</h3>
    <form action="login" method="post">
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />
        <button type="submit">Login</button>
    </form>
</div>

<div class="top-left-controls">
    <button class="toggle-btn" onclick="toggleSidebar()">☰</button>
    <a href="CustomerDashboardServlet1" class="home-btn">
        <img src="images/logo1.png" alt="Home" class="logo">
    </a>
</div>

<div class="sidebar" id="sidebar">
    <h3>Menu</h3>
    <ul>
        <li><a href="CustomerBrowseMenuServlet">Browse Menu</a></li>
        <li><a href="ViewCartServlet">View Cart</a></li>
        <li><a href="MyOrdersServlet">My Orders</a></li>
        <li><a href="MyReviewsServlet">My Reviews</a></li>
        <li><a href="ChangePasswordServlet">Change Password</a></li>
    </ul>
</div>

<div class="content">
    <a href="LogOutServlet" class="logout-btn">Logout</a>
    <h2>Welcome, <%= sessionUser.getUsername() %>!</h2>
    <p>This is your customer dashboard.</p>

    <% if (hasReadyPickup) { %>
        <div class="alert">
            ✅ Your order is <strong>completed</strong> and <strong>ready to pick up</strong>!
            <br><a class="view-btn" href="MyOrdersServlet">View Order Details</a>
        </div>
    <% } %>

    <% if (hasUnseenReply) { %>
        <div class="alert alert-warning">
            📨 You have new reply from staff on your review!
            <br><a class="view-btn" href="MyReviewsServlet">View Feedback</a>
        </div>
    <% } %>

    <% if (estimatedTimeMsg != null && !estimatedTimeMsg.isEmpty()) { %>
        <div class="alert alert-info">
            <%= estimatedTimeMsg %>
            <br><a class="view-btn" href="MyOrdersServlet">View Order</a>
        </div>
    <% } %>

    <p>Check out our popular menu items:</p>
    <div class="food-grid">
        <% for (Menu item : previewItems) { %>
            <div class="preview-card">
                <img src="images/<%= item.getImage() %>" alt="<%= item.getName() %>">
                <h3><%= item.getName() %></h3>
                <p><%= item.getDescription() %></p>
                <p><strong>RM<%= String.format("%.2f", item.getPrice()) %></strong></p>
                <a class="interested-btn" href="CustomerBrowseMenuServlet">Interested?</a>
            </div>
        <% } %>
    </div>
</div>

<script>
function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('hidden');
}

function showLoginPopup() {
    document.getElementById('loginPopup').classList.add('active');
}

function hideLoginPopup() {
    document.getElementById('loginPopup').classList.remove('active');
}
</script>

</body>
</html>
