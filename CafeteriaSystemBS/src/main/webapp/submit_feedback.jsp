<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Submit Feedback</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: #fbeaff;
            font-family: 'Segoe UI', sans-serif;
        }

        .container {
            margin-top: 60px;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        h2 {
            color: #6c5b7b;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: 600;
        }

        .btn-custom {
            background-color: #6c5b7b;
            color: white;
            border: none;
        }

        .btn-custom:hover {
            background-color: #5a4b6b;
        }
    </style>
</head>
<body>

<div class="container col-md-6">
    <h2>Submit Feedback</h2>
    <form action="SubmitFeedbackServlet" method="post">
        <div class="mb-3">
            <label for="order_id" class="form-label">Order ID</label>
            <input type="number" name="order_id" id="order_id" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="rating" class="form-label">Rating (1-5)</label>
            <input type="number" name="rating" id="rating" min="1" max="5" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="message" class="form-label">Feedback Message</label>
            <textarea name="message" id="message" class="form-control" rows="4" required></textarea>
        </div>

        <button type="submit" class="btn btn-custom">Submit</button>
    </form>
</div>

<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    if ("empty".equals(error)) {
%>
<script>
    Swal.fire({
        icon: 'error',
        title: 'Feedback Failed',
        text: 'All fields must be filled in!',
        confirmButtonColor: '#6c5b7b'
    });
</script>
<% } else if ("server".equals(error)) { %>
<script>
    Swal.fire({
        icon: 'error',
        title: 'Server Error',
        text: 'Something went wrong. Please try again later.',
        confirmButtonColor: '#6c5b7b'
    });
</script>
<% } else if ("1".equals(success)) { %>
<script>
    Swal.fire({
        icon: 'success',
        title: 'Feedback Submitted!',
        text: 'Thank you for your feedback.',
        confirmButtonColor: '#6c5b7b'
    });
</script>
<% } %>

</body>
</html>
