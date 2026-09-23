package com.evcharging.controller;

import com.evcharging.dao.SlotDAO;
import com.evcharging.dao.StationDAO;
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
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/owner/update-station")
public class UpdateStationServlet extends HttpServlet {
    private final StationDAO stationDAO = new StationDAO();
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

        String stationIdStr = request.getParameter("id");
        if (stationIdStr == null || stationIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/manage-stations");
            return;
        }

        try {
            int stationId = Integer.parseInt(stationIdStr);
            Station station = stationDAO.getById(stationId);
            if (station != null && station.getOwnerId() == owner.getId()) {
                List<ChargingSlot> slots = slotDAO.getSlotsByStation(stationId);
                request.setAttribute("station", station);
                request.setAttribute("slots", slots);
                request.getRequestDispatcher("/owner/manage-stations.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/owner/manage-stations");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/manage-stations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        StationOwner owner = (session != null) ? (StationOwner) session.getAttribute("owner") : null;

        if (owner == null) {
            response.sendRedirect(request.getContextPath() + "/owner/login");
            return;
        }

        String action = request.getParameter("action");

        // Action: Update individual slot status (AVAILABLE / OCCUPIED / MAINTENANCE)
        if ("updateSlot".equalsIgnoreCase(action)) {
            String slotIdStr = request.getParameter("slotId");
            String newStatus = request.getParameter("slotStatus");
            if (slotIdStr != null && newStatus != null) {
                try {
                    int slotId = Integer.parseInt(slotIdStr);
                    slotDAO.updateStatus(slotId, newStatus);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/owner/live-status?updated=true");
            return;
        }

        // Action: Update station details and price
        String stationIdStr = request.getParameter("id");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String chargerTypes = request.getParameter("chargerTypes");
        String powerRating = request.getParameter("powerRating");
        String priceStr = request.getParameter("pricePerUnit");
        String slotsStr = request.getParameter("totalSlots");
        String amenities = request.getParameter("amenities");

        if (stationIdStr == null || name == null || priceStr == null) {
            response.sendRedirect(request.getContextPath() + "/owner/manage-stations");
            return;
        }

        try {
            int stationId = Integer.parseInt(stationIdStr);
            Station existing = stationDAO.getById(stationId);
            if (existing == null || existing.getOwnerId() != owner.getId()) {
                response.sendRedirect(request.getContextPath() + "/owner/manage-stations");
                return;
            }

            existing.setName(name.trim());
            if (address != null) existing.setAddress(address.trim());
            if (city != null) existing.setCity(city.trim());
            if (state != null) existing.setState(state.trim());
            if (pincode != null) existing.setPincode(pincode.trim());
            if (chargerTypes != null) existing.setChargerTypes(chargerTypes.trim());
            if (powerRating != null) existing.setPowerRating(powerRating.trim());
            if (priceStr != null) existing.setPricePerUnit(new BigDecimal(priceStr.trim()));
            if (slotsStr != null) existing.setTotalSlots(Integer.parseInt(slotsStr.trim()));
            if (amenities != null) existing.setAmenities(amenities.trim());

            stationDAO.updateStation(existing);
            response.sendRedirect(request.getContextPath() + "/owner/manage-stations?updated=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/owner/manage-stations?error=update_failed");
        }
    }
}
