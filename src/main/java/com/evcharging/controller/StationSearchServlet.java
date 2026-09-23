package com.evcharging.controller;

import com.evcharging.dao.ReviewDAO;
import com.evcharging.dao.SlotDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.model.ChargingSlot;
import com.evcharging.model.Review;
import com.evcharging.model.Station;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search-stations")
public class StationSearchServlet extends HttpServlet {
    private final StationDAO stationDAO = new StationDAO();
    private final SlotDAO slotDAO = new SlotDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("details".equalsIgnoreCase(action)) {
            viewStationDetails(request, response);
            return;
        }

        String query = request.getParameter("query");
        String chargerType = request.getParameter("chargerType");
        String maxPriceStr = request.getParameter("maxPrice");
        Double maxPrice = null;

        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Station> stations;
        if ((query != null && !query.trim().isEmpty()) ||
            (chargerType != null && !chargerType.trim().isEmpty() && !chargerType.equalsIgnoreCase("ALL")) ||
            maxPrice != null) {
            stations = stationDAO.searchStations(query, chargerType, maxPrice);
        } else {
            stations = stationDAO.getAllApprovedStations();
        }

        request.setAttribute("stations", stations);
        request.setAttribute("paramQuery", query);
        request.setAttribute("paramChargerType", chargerType);
        request.setAttribute("paramMaxPrice", maxPriceStr);

        request.getRequestDispatcher("/user/search-stations.jsp").forward(request, response);
    }

    private void viewStationDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-stations");
            return;
        }

        try {
            int stationId = Integer.parseInt(idStr.trim());
            Station station = stationDAO.getById(stationId);
            if (station == null) {
                request.setAttribute("errorMessage", "Station not found.");
                response.sendRedirect(request.getContextPath() + "/search-stations");
                return;
            }

            List<ChargingSlot> slots = slotDAO.getSlotsByStation(stationId);
            List<Review> reviews = reviewDAO.getByStationId(stationId);
            double avgRating = reviewDAO.getAverageRating(stationId);

            request.setAttribute("station", station);
            request.setAttribute("slots", slots);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);

            request.getRequestDispatcher("/user/station-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/search-stations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
