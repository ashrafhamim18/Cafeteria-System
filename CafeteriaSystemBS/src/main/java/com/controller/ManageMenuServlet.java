package com.controller;

import com.dao.MenuDAO;
import com.dao.DBConnection;
import com.model.Menu;
import com.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class ManageMenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null || !"staff".equals(user.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            MenuDAO dao = new MenuDAO(conn);

            if (req.getParameter("delete") != null) {
                int id = Integer.parseInt(req.getParameter("delete"));
                dao.deleteMenu(id);
                session.setAttribute("message", "Menu item deleted successfully.");
                session.setAttribute("messageType", "success");
                res.sendRedirect("ManageMenuServlet");
                return;
            }

            List<Menu> menuList = dao.getAllMenu();
            req.setAttribute("menuList", menuList);

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("manage_menu.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();

        try (Connection conn = DBConnection.getConnection()) {
            MenuDAO dao = new MenuDAO(conn);

            String name = req.getParameter("name");
            String desc = req.getParameter("description");
            double price = Double.parseDouble(req.getParameter("price"));
            String category = req.getParameter("category");
            String image = req.getParameter("image");
            String availability = "available";

            Menu menu = new Menu();
            menu.setName(name);
            menu.setDescription(desc);
            menu.setPrice(price);
            menu.setCategory(category);
            menu.setImage(image);
            menu.setAvailability(availability);

            if (req.getParameter("id") != null && !req.getParameter("id").isEmpty()) {
                menu.setId(Integer.parseInt(req.getParameter("id")));
                dao.updateMenu(menu);
                session.setAttribute("message", "Menu item updated successfully.");
            } else {
                dao.addMenu(menu);
                session.setAttribute("message", "New menu item added successfully.");
            }

            session.setAttribute("messageType", "success");
            res.sendRedirect("ManageMenuServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Something went wrong.");
            session.setAttribute("messageType", "error");
            res.sendRedirect("ManageMenuServlet");
        }
    }
}
