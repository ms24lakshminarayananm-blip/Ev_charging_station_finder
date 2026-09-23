package com.evcharging.controller;

import com.evcharging.dao.StationDAO;
import com.evcharging.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/reject-station")
public class RejectStationServlet extends HttpServlet {
    private final StationDAO stationDAO = new StationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String stationIdStr = request.getParameter("id");
        if (stationIdStr != null && !stationIdStr.isEmpty()) {
            try {
                int stationId = Integer.parseInt(stationIdStr.trim());
                stationDAO.updateApprovalStatus(stationId, "REJECTED");
            } catch (NumberFormatException ignored) {}
        }

        String redirect = request.getParameter("redirect");
        if ("dashboard".equalsIgnoreCase(redirect)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?rejected=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/stations?rejected=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
