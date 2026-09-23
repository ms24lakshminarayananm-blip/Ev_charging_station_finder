package com.evcharging.controller;

import com.evcharging.dao.OwnerDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.dao.UserDAO;
import com.evcharging.model.Admin;
import com.evcharging.model.Station;
import com.evcharging.model.StationOwner;
import com.evcharging.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/manage-users", "/admin/users", "/admin/owners", "/admin/stations", "/admin/bookings"})
public class ManageUsersServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final OwnerDAO ownerDAO = new OwnerDAO();
    private final StationDAO stationDAO = new StationDAO();
    private final com.evcharging.dao.BookingDAO bookingDAO = new com.evcharging.dao.BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/bookings".equals(path)) {
            List<com.evcharging.model.Booking> bookings = bookingDAO.getAllBookings();
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
            return;
        }

        if ("/admin/owners".equals(path)) {
            List<StationOwner> owners = ownerDAO.getAllOwners();
            request.setAttribute("owners", owners);
            request.getRequestDispatcher("/admin/owners.jsp").forward(request, response);
            return;
        }

        if ("/admin/stations".equals(path)) {
            List<Station> stations = stationDAO.getAllStations();
            request.setAttribute("stations", stations);
            request.getRequestDispatcher("/admin/stations.jsp").forward(request, response);
            return;
        }

        // Default or /admin/users or /admin/manage-users
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
