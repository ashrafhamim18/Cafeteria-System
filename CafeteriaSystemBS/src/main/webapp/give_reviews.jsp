<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String orderId = (String) request.getAttribute("order_id");

    // Check for messages in request or session
    String success = (String) request.getAttribute("msg");
    if (success == null) {
        success = (String) session.getAttribute("success");
        if (success != null) session.removeAttribute("success");
    }
    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = (String) session.getAttribute("error");
        if (error != null) session.removeAttribute("error");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Give Review</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Segoe+UI&display=swap');

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f1f8fc;
            padding: 4rem 2rem;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        h2 {
            color: #00796b;
            text-align: center;
            margin-bottom: 2rem;
            font-weight: 700;
            letter-spacing: 1px;
        }

        form {
            background: #fff;
            padding: 2.5rem 3rem;
            width: 100%;
            max-width: 600px;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0, 121, 107, 0.15);
            transition: box-shadow 0.3s ease-in-out;
        }

        form:hover {
            box-shadow: 0 10px 25px rgba(0, 121, 107, 0.3);
        }

        label {
            display: block;
            margin-top: 1.5rem;
            font-weight: 600;
            color: #004d40;
            font-size: 1.05rem;
        }

        select, textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            margin-top: 0.5rem;
            font-size: 1rem;
            border: 2px solid #b2dfdb;
            border-radius: 8px;
            background-color: #e0f2f1;
            transition: border-color 0.3s ease;
            resize: vertical;
        }

        select:focus, textarea:focus {
            outline: none;
            border-color: #00796b;
            background-color: #ffffff;
            box-shadow: 0 0 8px rgba(0, 121, 107, 0.3);
        }

        option {
            color: #004d40;
        }

        button {
            margin-top: 2rem;
            background-color: #00796b;
            color: white;
            border: none;
            padding: 0.85rem 2.5rem;
            font-weight: 700;
            font-size: 1.1rem;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0, 121, 107, 0.3);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            display: block;
            width: 100%;
            max-width: 250px;
            margin-left: auto;
            margin-right: auto;
        }

        button:hover {
            background-color: #004d40;
            box-shadow: 0 6px 18px rgba(0, 77, 64, 0.5);
        }

        /* Optional: add subtle star icons spacing */
        option[value="5"]::before { content: "⭐⭐⭐⭐⭐ "; }
        option[value="4"]::before { content: "⭐⭐⭐⭐ "; }
        option[value="3"]::before { content: "⭐⭐⭐ "; }
        option[value="2"]::before { content: "⭐⭐ "; }
        option[value="1"]::before { content: "⭐ "; }
        
        .container {
            max-width: 600px;
            width: 100%;
            margin: 2rem auto 3rem auto; /* less top margin */
            padding: 0 1rem;
        }
        
        .container h2 {
            text-align: center;
            margin-bottom: 1rem;
            font-weight: 700;
            color: #004d40;
        }
    </style>

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="container">
    <h2>Submit Your Review</h2>

    <form action="GiveReviewServlet" method="post">
        <input type="hidden" name="order_id" value="<%= orderId %>">

        <label for="rating">Rating:</label>
        <select name="rating" required>
            <option value="">-- Select Rating --</option>
            <option value="5">⭐⭐⭐⭐⭐</option>
            <option value="4">⭐⭐⭐⭐</option>
            <option value="3">⭐⭐⭐</option>
            <option value="2">⭐⭐</option>
            <option value="1">⭐</option>
        </select>

        <label for="feedback">Your Feedback:</label>
        <textarea name="feedback" rows="5" required placeholder="Write your comments here..."></textarea>

        <button type="submit">Submit Review</button>
    </form>
</div>

<script>
    window.onload = function () {
        <% if (success != null && !success.isEmpty()) { %>
            Swal.fire({
                icon: 'success',
                title: '<%= success.replace("\"", "\\\"") %>',
                timer: 3000,
                showConfirmButton: false,
                toast: true,
                position: 'top-end',
                timerProgressBar: true,
            });
        <% } else if (error != null && !error.isEmpty()) { %>
            Swal.fire({
                icon: 'error',
                title: '<%= error.replace("\"", "\\\"") %>',
                timer: 3000,
                showConfirmButton: false,
                toast: true,
                position: 'top-end',
                timerProgressBar: true,
            });
        <% } %>
    };
</script>

</body>
</html>
