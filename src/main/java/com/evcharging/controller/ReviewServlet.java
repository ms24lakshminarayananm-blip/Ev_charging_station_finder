package com.evcharging.controller;

import com.evcharging.dao.ReviewDAO;
import com.evcharging.dao.StationDAO;
import com.evcharging.model.Review;
import com.evcharging.model.Station;
import com.evcharging.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final StationDAO stationDAO = new StationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String stationIdStr = request.getParameter("stationId");
        if (stationIdStr != null && !stationIdStr.isEmpty()) {
            try {
                int stationId = Integer.parseInt(stationIdStr);
                Station station = stationDAO.getById(stationId);
                request.setAttribute("station", station);
            } catch (NumberFormatException ignored) {}
        }

        List<Station> approvedStations = stationDAO.getAllApprovedStations();
        request.setAttribute("stations", approvedStations);
        request.getRequestDispatcher("/user/reviews.jsp").forward(request, response);
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
        String ratingStr = request.getParameter("rating");
        String reviewText = request.getParameter("reviewText");

        if (stationIdStr == null || ratingStr == null || reviewText == null ||
            stationIdStr.isEmpty() || ratingStr.isEmpty() || reviewText.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Rating and review text are required.");
            doGet(request, response);
            return;
        }

        try {
            int stationId = Integer.parseInt(stationIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                request.setAttribute("errorMessage", "Rating must be between 1 and 5.");
                doGet(request, response);
                return;
            }

            Review review = new Review();
            review.setStationId(stationId);
            review.setUserId(currentUser.getId());
            review.setRating(rating);
            review.setReviewText(reviewText.trim());

            boolean success = reviewDAO.addReview(review);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/search-stations?action=details&id=" + stationId + "&reviewed=true");
            } else {
                request.setAttribute("errorMessage", "Failed to submit review.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error submitting review: " + e.getMessage());
            doGet(request, response);
        }
    }
}
