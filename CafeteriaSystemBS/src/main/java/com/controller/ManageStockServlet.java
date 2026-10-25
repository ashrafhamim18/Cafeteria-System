package com.controller;

import com.dao.DBConnection;
import com.dao.MenuDAO;
import com.dao.StockDAO;
import com.model.Menu;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class ManageStockServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            MenuDAO menuDAO = new MenuDAO(conn);
            List<Menu> menuList = menuDAO.getAllMenu();
            request.setAttribute("menuList", menuList);

            // No need to forward session message to request here
            RequestDispatcher rd = request.getRequestDispatcher("manage_stock.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error loading stock page.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try (Connection conn = DBConnection.getConnection()) {
            StockDAO stockDAO = new StockDAO(conn);
            MenuDAO menuDAO = new MenuDAO(conn);

            String[] menuIds = request.getParameterValues("menu_id");
            String[] quantities = request.getParameterValues("stock_quantity");

            if (menuIds == null || quantities == null || menuIds.length != quantities.length) {
                session.setAttribute("error", "Invalid form submission.");
                response.sendRedirect("ManageStockServlet");
                return;
            }

            for (int i = 0; i < menuIds.length; i++) {
                int menuId = Integer.parseInt(menuIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                if (stockDAO.exists(menuId)) {
                    stockDAO.updateStock(menuId, quantity);
                } else {
                    stockDAO.insertStock(menuId, quantity);
                }

                String availability = (quantity > 0) ? "available" : "unavailable";
                menuDAO.updateAvailability(menuId, availability);
            }

            session.setAttribute("success", "Stock updated successfully.");
            response.sendRedirect("ManageStockServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to update stock. Please try again.");
            response.sendRedirect("ManageStockServlet");
        }
    }
}
