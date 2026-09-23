package com.evcharging.controller;

import com.evcharging.dao.WaitingListDAO;
import com.evcharging.model.User;
import com.evcharging.model.WaitingList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/waiting-list")
public class WaitingListServlet extends HttpServlet {
    private final WaitingListDAO waitingListDAO = new WaitingListDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    waitingListDAO.delete(id, currentUser.getId());
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/waiting-list");
            return;
        }

        List<WaitingList> list = waitingListDAO.getByUserId(currentUser.getId());
        request.setAttribute("waitingList", list);
        request.getRequestDispatcher("/user/waiting-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String stationIdStr = request.getParameter("stationId");
        String desiredDateStr = request.getParameter("desiredDate");
        String desiredTime = request.getParameter("desiredTime");

        if (stationIdStr == null || desiredDateStr == null || desiredTime == null ||
            stationIdStr.isEmpty() || desiredDateStr.isEmpty() || desiredTime.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-stations");
            return;
        }

        try {
            int stationId = Integer.parseInt(stationIdStr);
            Date desiredDate = Date.valueOf(desiredDateStr);

            WaitingList wl = new WaitingList();
            wl.setUserId(currentUser.getId());
            wl.setStationId(stationId);
            wl.setDesiredDate(desiredDate);
            wl.setDesiredTime(desiredTime);

            boolean added = waitingListDAO.addWaiting(wl);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/waiting-list?joined=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/waiting-list?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/waiting-list?error=invalid_data");
        }
    }
}
