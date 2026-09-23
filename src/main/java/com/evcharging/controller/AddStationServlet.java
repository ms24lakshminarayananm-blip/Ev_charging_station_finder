package com.evcharging.controller;

import com.evcharging.dao.SlotDAO;
import com.evcharging.dao.StationDAO;
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

@WebServlet("/owner/add-station")
public class AddStationServlet extends HttpServlet {
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

        request.getRequestDispatcher("/owner/add-station.jsp").forward(request, response);
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

        if (name == null || address == null || city == null || state == null || pincode == null ||
            priceStr == null || slotsStr == null || name.trim().isEmpty() || address.trim().isEmpty() ||
            city.trim().isEmpty() || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All required station fields must be filled.");
            request.getRequestDispatcher("/owner/add-station.jsp").forward(request, response);
            return;
        }

        try {
            BigDecimal pricePerUnit = new BigDecimal(priceStr.trim());
            int totalSlots = Integer.parseInt(slotsStr.trim());
            if (totalSlots < 1) totalSlots = 1;

            Station s = new Station();
            s.setOwnerId(owner.getId());
            s.setName(name.trim());
            s.setAddress(address.trim());
            s.setCity(city.trim());
            s.setState(state.trim());
            s.setPincode(pincode.trim());
            s.setLatitude(new BigDecimal("0.00000000"));
            s.setLongitude(new BigDecimal("0.00000000"));
            s.setChargerTypes(chargerTypes != null && !chargerTypes.trim().isEmpty() ? chargerTypes.trim() : "Type 2, CCS2");
            s.setPowerRating(powerRating != null && !powerRating.trim().isEmpty() ? powerRating.trim() : "50 kW");
            s.setPricePerUnit(pricePerUnit);
            s.setTotalSlots(totalSlots);
            s.setAmenities(amenities != null ? amenities.trim() : "Parking, Restroom");
            s.setApprovalStatus("PENDING");

            int generatedStationId = stationDAO.addStation(s);
            if (generatedStationId > 0) {
                // Initialize default slots for this new station
                slotDAO.createDefaultSlotsForStation(generatedStationId, totalSlots, s.getChargerTypes(), s.getPowerRating());
                response.sendRedirect(request.getContextPath() + "/owner/manage-stations?created=true");
            } else {
                request.setAttribute("errorMessage", "Failed to register station. Please try again.");
                request.getRequestDispatcher("/owner/add-station.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid numeric inputs for price or slots: " + e.getMessage());
            request.getRequestDispatcher("/owner/add-station.jsp").forward(request, response);
        }
    }
}
