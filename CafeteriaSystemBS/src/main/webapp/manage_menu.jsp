<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.model.Menu, java.util.*" %>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Menu</title>
    <style>
        /* [All your existing CSS remains unchanged] */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #fbeaff, #e4f9f5);
            margin: 0;
            padding: 4rem 2rem 2rem;
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
            width: auto;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .home-btn img:hover {
            transform: scale(1.05);
        }
        h2, h3 {
            color: #6c5b7b;
        }
        button {
            background-color: #a8e6cf;
            color: #333;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #dcedc1;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        th, td {
            padding: 0.8rem;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #fdfbff;
            color: #6c5b7b;
        }
        .edit-btn, .delete-btn {
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            color: #fff;
        }
        .edit-btn {
            background-color: #8ecae6;
        }
        .edit-btn:hover {
            background-color: #219ebc;
        }
        .delete-btn {
            background-color: #e76f51;
        }
        .delete-btn:hover {
            background-color: #c1442c;
        }
        .img-preview {
            height: 40px;
            border-radius: 6px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background-color: #fff6fb;
            margin: auto;
            padding: 2rem;
            border: 1px solid #888;
            width: 400px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            position: relative;
        }
        .modal-content input[type="text"],
        .modal-content input[type="number"],
        .modal-content textarea,
        .modal-content select {
            width: 100%;
            padding: 0.6rem;
            margin-bottom: 1rem;
            border: 1px solid #d3cce3;
            border-radius: 8px;
            font-size: 1rem;
            background-color: #fdfbff;
        }
    </style>
    <!-- ✅ SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<a href="StaffDashboardServlet" class="home-btn">
    <img src="images/logo1.png" alt="Home" class="logo">
</a>

<h2>Manage Menu</h2>
<button onclick="openModal()">+ Add New Menu</button>

<h3>All Menu Items</h3>
<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Image</th>
        <th>Price (RM)</th>
        <th>Category</th>
        <th>Action</th>
    </tr>
    <% if (menuList != null) {
        for (Menu m : menuList) {
    %>
    <tr>
        <td><%= m.getId() %></td>
        <td><%= m.getName() %></td>
        <td>
            <% if (m.getImage() != null && !m.getImage().isEmpty()) { %>
                <img src="images/<%= m.getImage() %>" class="img-preview" alt="">
            <% } else { %> - <% } %>
        </td>
        <td>RM<%= String.format("%.2f", m.getPrice()) %></td>
        <td><%= m.getCategory() %></td>
        <td>
            <a href="javascript:void(0);" class="edit-btn" onclick='openModal({
                id: "<%= m.getId() %>",
                name: "<%= m.getName() %>",
                description: "<%= m.getDescription() %>",
                price: "<%= m.getPrice() %>",
                category: "<%= m.getCategory() %>",
                image: "<%= m.getImage() %>"
            })'>Edit</a>
            <a href="ManageMenuServlet?delete=<%= m.getId() %>" class="delete-btn" onclick="return confirm('Delete this item?')">Delete</a>
        </td>
    </tr>
    <% }} %>
</table>

<!-- Modal -->
<div id="menuModal" class="modal">
    <div class="modal-content">
        <h3 id="modalTitle">Add Menu Item</h3>
        <form method="post" action="ManageMenuServlet">
            <input type="hidden" name="id" id="menuId">

            <label>Name</label>
            <input type="text" name="name" id="menuName" required>

            <label>Description</label>
            <textarea name="description" id="menuDesc"></textarea>

            <label>Price (RM)</label>
            <input type="number" step="0.01" name="price" id="menuPrice" required>

            <label>Category</label>
            <select name="category" id="menuCat" required>
                <option value="food">Food</option>
                <option value="drink">Drink</option>
            </select>

            <label>Image Filename</label>
            <input type="text" name="image" id="menuImg">

            <div style="margin-top: 1rem;">
                <button type="submit">Save</button>
                <button type="button" onclick="closeModal()" style="margin-left:10px;">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(data = null) {
        document.getElementById("menuModal").style.display = "flex";
        document.getElementById("modalTitle").innerText = data ? "Edit Menu Item" : "Add Menu Item";

        document.getElementById("menuId").value = data ? data.id : "";
        document.getElementById("menuName").value = data ? data.name : "";
        document.getElementById("menuDesc").value = data ? data.description : "";
        document.getElementById("menuPrice").value = data ? data.price : "";
        document.getElementById("menuCat").value = data ? data.category : "food";
        document.getElementById("menuImg").value = data ? data.image : "";
    }

    function closeModal() {
        document.getElementById("menuModal").style.display = "none";
    }

    window.onclick = function(event) {
        const modal = document.getElementById("menuModal");
        if (event.target === modal) {
            closeModal();
        }
    };
</script>

<%
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType"); // success or error
    if (message != null && messageType != null) {
%>
<script>
    Swal.fire({
        toast: true,
        position: 'top-end',
        icon: '<%= messageType %>', // success or error
        title: '<%= message %>',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });
</script>
<%
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

</body>
</html>
