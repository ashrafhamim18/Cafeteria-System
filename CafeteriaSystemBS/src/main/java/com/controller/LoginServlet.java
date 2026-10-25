package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import com.dao.UserDAO;
import com.model.User;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.validate(username, password);

            if (user != null) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("username", user.getUsername());
                session.setAttribute("fullname", user.getFullName());
                session.setAttribute("role", user.getRole());

                // Optional: Success message (you can show popup based on session attr)
                session.setAttribute("success", "Login successful. Welcome " + user.getFullName() + "!");

                switch (user.getRole()) {
                    case "admin":
                        res.sendRedirect("AdminDashboardServlet");
                        break;
                    case "staff":
                        res.sendRedirect("StaffDashboardServlet");
                        break;
                    case "customer":
                        res.sendRedirect("CustomerDashboardServlet1");
                        break;
                    default:
                        session.setAttribute("error", "Invalid user role.");
                        res.sendRedirect("login.jsp");
                        break;
                }
            } else {
                // Failed login
                HttpSession session = req.getSession();
                session.setAttribute("error", "Invalid username or password.");
                res.sendRedirect("login.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "System error occurred. Please try again.");
            res.sendRedirect("login.jsp");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.sendRedirect("login.jsp");
    }
}
