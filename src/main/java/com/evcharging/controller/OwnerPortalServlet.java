package com.evcharging.controller;

import com.evcharging.dao.BookingDAO;
import com.evcharging.dao.SlotDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.model.Booking;
import com.evcharging.model.ChargingSlot;
import com.evcharging.model.Station;
import com.evcharging.model.StationOwner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/owner/dashboard", "/owner/manage-stations", "/owner/bookings", "/owner/live-status"})
public class OwnerPortalServlet extends HttpServlet {
    private final StationDAO stationDAO = new StationDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final SlotDAO slotDAO = new SlotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        StationOwner owner = (session != null) ? (StationOwner) session.getAttribute("owner") : null;

        if (owner == null) {
            response.sendRedirect(request.getContextPath() + "/owner/login");
            return;
        }

        String path = request.getServletPath();
        List<Station> stations = stationDAO.getStationsByOwner(owner.getId());

        if ("/owner/manage-stations".equals(path)) {
            request.setAttribute("stations", stations);
            request.getRequestDispatcher("/owner/manage-stations.jsp").forward(request, response);
            return;
        }

        if ("/owner/bookings".equals(path)) {
            List<Booking> bookings = bookingDAO.getByOwnerId(owner.getId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/owner/bookings.jsp").forward(request, response);
            return;
        }

        if ("/owner/live-status".equals(path)) {
            Map<Integer, List<ChargingSlot>> stationSlotsMap = new HashMap<>();
            for (Station s : stations) {
                stationSlotsMap.put(s.getId(), slotDAO.getSlotsByStation(s.getId()));
            }
            request.setAttribute("stations", stations);
            request.setAttribute("stationSlotsMap", stationSlotsMap);
            request.getRequestDispatcher("/owner/live-status.jsp").forward(request, response);
            return;
        }

        // Default: /owner/dashboard
        List<Booking> bookings = bookingDAO.getByOwnerId(owner.getId());
        double totalEarnings = 0.0;
        int activeBookings = 0;
        for (Booking b : bookings) {
            if ("BOOKED".equalsIgnoreCase(b.getStatus()) || "COMPLETED".equalsIgnoreCase(b.getStatus())) {
                totalEarnings += b.getFinalAmount().doubleValue();
            }
            if ("BOOKED".equalsIgnoreCase(b.getStatus())) {
                activeBookings++;
            }
        }

        request.setAttribute("stations", stations);
        request.setAttribute("recentBookings", bookings);
        request.setAttribute("totalStations", stations.size());
        request.setAttribute("totalBookings", bookings.size());
        request.setAttribute("activeBookings", activeBookings);
        request.setAttribute("totalEarnings", totalEarnings);

        request.getRequestDispatcher("/owner/dashboard.jsp").forward(request, response);
    }
}
