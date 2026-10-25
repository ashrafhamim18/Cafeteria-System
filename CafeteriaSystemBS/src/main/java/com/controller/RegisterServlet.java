package com.controller;

import com.dao.UserDAO;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;


public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username     = request.getParameter("username");
        String password     = request.getParameter("password");
        String confirmPass  = request.getParameter("confirm_password");
        String email        = request.getParameter("email");
        String fullName     = request.getParameter("full_name");
        String role         = request.getParameter("role");

        if (!password.equals(confirmPass)) {
            response.sendRedirect("register.jsp?msg=Passwords do not match.");
            return;
        }

        if (!role.equals("customer") && !role.equals("staff")) {
            response.sendRedirect("register.jsp?msg=Invalid role selected.");
            return;
        }

        UserDAO userDAO = new UserDAO();

        if (userDAO.checkUsernameExists(username)) {
            response.sendRedirect("register.jsp?msg=Username already taken.");
        } else {
            User newUser = new User(username, password, email, fullName, role);
            boolean success = userDAO.registerUser(newUser);

            if (success) {
            	response.sendRedirect("register.jsp?msg=Registration successful!&status=success");
            } else {
                response.sendRedirect("register.jsp?msg=Database error. Please try again.");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}
