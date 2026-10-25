package com.controller;

import com.dao.UserDAO;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

    private UserDAO dao = new UserDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User cur = (s != null) ? (User) s.getAttribute("user") : null;
        if (cur == null || !"admin".equals(cur.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        String kw = req.getParameter("search") != null ? req.getParameter("search") : "";
        String flt = req.getParameter("filter") != null ? req.getParameter("filter") : "";

        try {
            List<User> list = dao.searchAndFilter(kw.trim(), flt.trim());
            int total = list.size(), a = 0, st = 0, cu = 0;
            for (User u : list) {
                switch (u.getRole()) {
                    case "admin": a++; break;
                    case "staff": st++; break;
                    default: cu++;
                }
            }

            req.setAttribute("users", list);
            req.setAttribute("total_users", total);
            req.setAttribute("admins", a);
            req.setAttribute("staff", st);
            req.setAttribute("customers", cu);
            req.setAttribute("search", kw);
            req.setAttribute("filter", flt);

            // Show success message if any
            String msg = req.getParameter("msg");
            if (msg != null) req.setAttribute("msg", msg);

            req.getRequestDispatcher("admin_dashboard.jsp").forward(req, res);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String message = "";
        try {
            if ("add".equals(action)) {
                User u = new User();
                u.setFullName(req.getParameter("full_name"));
                u.setUsername(req.getParameter("username"));
                u.setPassword(req.getParameter("password"));
                u.setEmail(req.getParameter("email"));
                u.setRole(req.getParameter("role"));
                dao.add(u);
                message = "User added successfully!";
            } else if ("update".equals(action)) {
                User u = new User();
                u.setId(Integer.parseInt(req.getParameter("id")));
                u.setFullName(req.getParameter("full_name"));
                u.setUsername(req.getParameter("username"));
                u.setPassword(req.getParameter("password"));
                u.setEmail(req.getParameter("email"));
                u.setRole(req.getParameter("role"));
                dao.update(u);
                message = "User updated successfully!";
            } else if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(req.getParameter("id")));
                message = "User deleted successfully!";
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        // Redirect with success message
        res.sendRedirect("AdminDashboardServlet?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}
