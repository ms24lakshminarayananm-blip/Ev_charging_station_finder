package com.evcharging.controller;

import com.evcharging.dao.BookingDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.dao.WaitingListDAO;
import com.evcharging.model.Booking;
import com.evcharging.model.User;
import com.evcharging.model.WaitingList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final WaitingListDAO waitingListDAO = new WaitingListDAO();
    private final StationDAO stationDAO = new StationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Booking> bookings = bookingDAO.getByUserId(user.getId());
        List<WaitingList> waitingList = waitingListDAO.getByUserId(user.getId());
        int activeBookingsCount = 0;
        for (Booking b : bookings) {
            if ("BOOKED".equalsIgnoreCase(b.getStatus())) {
                activeBookingsCount++;
            }
        }

        request.setAttribute("recentBookings", bookings);
        request.setAttribute("waitingList", waitingList);
        request.setAttribute("totalBookings", bookings.size());
        request.setAttribute("activeBookingsCount", activeBookingsCount);
        request.setAttribute("totalStationsCount", stationDAO.getTotalStationCount());

        request.getRequestDispatcher("/user/dashboard.jsp").forward(request, response);
    }
}
