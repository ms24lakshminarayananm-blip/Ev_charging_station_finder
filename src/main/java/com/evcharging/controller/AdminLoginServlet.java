package com.evcharging.controller;

import com.evcharging.dao.AdminDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.model.Admin;
import com.evcharging.model.Station;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet({"/admin/login", "/admin/dashboard"})
public class AdminLoginServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();
    private final StationDAO stationDAO = new StationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path)) {
            HttpSession session = request.getSession(false);
            Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            Map<String, Object> stats = adminDAO.getDashboardStats();
            List<Station> pendingStations = stationDAO.getPendingStations();

            request.setAttribute("stats", stats);
            request.setAttribute("pendingStations", pendingStations);
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.login(username.trim(), password.trim());
        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setAttribute("role", "admin");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid administrator credentials.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
