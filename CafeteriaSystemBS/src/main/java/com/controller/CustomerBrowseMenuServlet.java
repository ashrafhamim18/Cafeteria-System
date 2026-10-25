package com.controller;

import com.dao.MenuDAO;
import com.dao.DBConnection;
import com.model.Menu;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class CustomerBrowseMenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String category = req.getParameter("category");
        String availability = req.getParameter("availability");

        try (Connection conn = DBConnection.getConnection()) {
            MenuDAO dao = new MenuDAO(conn);
            List<Menu> menuList = dao.getFilteredMenu(category, availability);

            req.setAttribute("menuList", menuList);
            req.setAttribute("selectedCategory", category);
            req.setAttribute("selectedAvailability", availability);
            req.getRequestDispatcher("browse_menu.jsp").forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("error.jsp");
        }
    }
}
