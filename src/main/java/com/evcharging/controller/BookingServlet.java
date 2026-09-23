package com.evcharging.controller;

import com.evcharging.dao.BookingDAO;
import com.evcharging.dao.SlotDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.model.Booking;
import com.evcharging.model.ChargingSlot;
import com.evcharging.model.Station;
import com.evcharging.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final StationDAO stationDAO = new StationDAO();
    private final SlotDAO slotDAO = new SlotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        String action = request.getParameter("action");

        // Action: View booking confirmation
        if ("confirmation".equalsIgnoreCase(action)) {
            String bookingIdStr = request.getParameter("id");
            if (bookingIdStr != null && !bookingIdStr.trim().isEmpty()) {
                try {
                    int bookingId = Integer.parseInt(bookingIdStr.trim());
                    Booking booking = bookingDAO.getById(bookingId);
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/user/booking-confirmation.jsp").forward(request, response);
                    return;
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/booking?action=list");
            return;
        }

        // Action: Prepare book-slot page for a station
        String stationIdStr = request.getParameter("stationId");
        if (stationIdStr != null && !stationIdStr.trim().isEmpty()) {
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login?redirect=booking&stationId=" + stationIdStr);
                return;
            }
            try {
                int stationId = Integer.parseInt(stationIdStr.trim());
                Station station = stationDAO.getById(stationId);
                List<ChargingSlot> slots = slotDAO.getSlotsByStation(stationId);

                request.setAttribute("station", station);
                request.setAttribute("slots", slots);
                request.getRequestDispatcher("/user/book-slot.jsp").forward(request, response);
                return;
            } catch (NumberFormatException ignored) {}
        }

        // Action: View user's bookings list
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Booking> userBookings = bookingDAO.getByUserId(currentUser.getId());
        request.setAttribute("bookings", userBookings);
        request.getRequestDispatcher("/user/bookings.jsp").forward(request, response);
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
        String slotIdStr = request.getParameter("slotId");
        String bookingDateStr = request.getParameter("bookingDate");
        String startTime = request.getParameter("startTime");
        String hoursStr = request.getParameter("totalHours");

        if (stationIdStr == null || slotIdStr == null || bookingDateStr == null || startTime == null ||
            stationIdStr.isEmpty() || slotIdStr.isEmpty() || bookingDateStr.isEmpty() || startTime.isEmpty()) {
            request.setAttribute("errorMessage", "All booking parameters are required.");
            doGet(request, response);
            return;
        }

        try {
            int stationId = Integer.parseInt(stationIdStr);
            int slotId = Integer.parseInt(slotIdStr);
            Date bookingDate = Date.valueOf(bookingDateStr);
            double hours = (hoursStr != null && !hoursStr.isEmpty()) ? Double.parseDouble(hoursStr) : 1.0;
            if (hours <= 0) hours = 1.0;

            Station station = stationDAO.getById(stationId);
            ChargingSlot slot = slotDAO.getById(slotId);

            if (station == null || slot == null) {
                request.setAttribute("errorMessage", "Invalid station or slot selected.");
                response.sendRedirect(request.getContextPath() + "/search-stations");
                return;
            }

            // Check slot status and date/time conflict
            boolean isSlotAvailableInDB = "AVAILABLE".equalsIgnoreCase(slot.getStatus());
            boolean isTimeAvailable = bookingDAO.isSlotAvailable(slotId, bookingDate, startTime);

            if (!isSlotAvailableInDB || !isTimeAvailable) {
                request.setAttribute("slotUnavailable", true);
                request.setAttribute("errorMessage", "Slot unavailable for the selected date and time.");
                request.setAttribute("station", station);
                request.setAttribute("slots", slotDAO.getSlotsByStation(stationId));
                request.setAttribute("desiredStationId", stationId);
                request.setAttribute("desiredSlotId", slotId);
                request.setAttribute("desiredDate", bookingDateStr);
                request.setAttribute("desiredTime", startTime);
                request.getRequestDispatcher("/user/book-slot.jsp").forward(request, response);
                return;
            }

            // Calculate amounts
            BigDecimal rate = station.getPricePerUnit();
            BigDecimal totalAmount = rate.multiply(BigDecimal.valueOf(hours));

            // Calculate simple end time
            String endTime = calculateEndTime(startTime, hours);

            // Store in session for payment checkout
            session.setAttribute("checkout_station", station);
            session.setAttribute("checkout_slot", slot);
            session.setAttribute("checkout_date", bookingDateStr);
            session.setAttribute("checkout_startTime", startTime);
            session.setAttribute("checkout_endTime", endTime);
            session.setAttribute("checkout_hours", hours);
            session.setAttribute("checkout_totalAmount", totalAmount);

            response.sendRedirect(request.getContextPath() + "/payment");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Booking request failed: " + e.getMessage());
            doGet(request, response);
        }
    }

    private String calculateEndTime(String startTime, double hours) {
        try {
            // Examples: "10:00 AM", "02:30 PM", "14:00"
            String cleaned = startTime.trim();
            boolean isPM = cleaned.toUpperCase().contains("PM");
            boolean isAM = cleaned.toUpperCase().contains("AM");
            String timePart = cleaned.replaceAll("[^0-9:]", "");
            String[] parts = timePart.split(":");
            int hour = Integer.parseInt(parts[0]);
            int minute = parts.length > 1 ? Integer.parseInt(parts[1]) : 0;

            if (isPM && hour < 12) hour += 12;
            if (isAM && hour == 12) hour = 0;

            int totalMinutes = (int) Math.round((hour * 60 + minute) + (hours * 60));
            int endHour24 = (totalMinutes / 60) % 24;
            int endMinute = totalMinutes % 60;

            String ampm = endHour24 >= 12 ? "PM" : "AM";
            int endHour12 = endHour24 % 12;
            if (endHour12 == 0) endHour12 = 12;

            return String.format("%02d:%02d %s", endHour12, endMinute, ampm);
        } catch (Exception e) {
            return "Next Hour";
        }
    }
}
