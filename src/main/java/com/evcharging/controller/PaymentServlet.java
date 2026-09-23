package com.evcharging.controller;

import com.evcharging.dao.BookingDAO;
import com.evcharging.dao.PaymentDAO;
import com.evcharging.model.Booking;
import com.evcharging.model.ChargingSlot;
import com.evcharging.model.Coupon;
import com.evcharging.model.Payment;
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
import java.text.SimpleDateFormat;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Station station = (Station) session.getAttribute("checkout_station");
        ChargingSlot slot = (ChargingSlot) session.getAttribute("checkout_slot");
        BigDecimal totalAmount = (BigDecimal) session.getAttribute("checkout_totalAmount");

        if (station == null || slot == null || totalAmount == null) {
            response.sendRedirect(request.getContextPath() + "/search-stations");
            return;
        }

        BigDecimal discount = (BigDecimal) session.getAttribute("coupon_discount");
        if (discount == null) {
            discount = BigDecimal.ZERO;
        }

        BigDecimal finalAmount = totalAmount.subtract(discount);
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }

        request.setAttribute("station", station);
        request.setAttribute("slot", slot);
        request.setAttribute("originalAmount", totalAmount);
        request.setAttribute("discountAmount", discount);
        request.setAttribute("finalAmount", finalAmount);
        request.setAttribute("appliedCoupon", session.getAttribute("applied_coupon"));

        // Handle error parameters
        String error = request.getParameter("error");
        if ("invalid_coupon".equals(error)) {
            request.setAttribute("couponError", "Invalid or expired coupon code.");
        } else if ("empty_coupon".equals(error)) {
            request.setAttribute("couponError", "Please enter a valid coupon code.");
        } else if ("min_amount".equals(error)) {
            request.setAttribute("couponError", "Minimum order amount not met for this coupon.");
        }

        request.getRequestDispatcher("/user/payment.jsp").forward(request, response);
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

        Station station = (Station) session.getAttribute("checkout_station");
        ChargingSlot slot = (ChargingSlot) session.getAttribute("checkout_slot");
        String dateStr = (String) session.getAttribute("checkout_date");
        String startTime = (String) session.getAttribute("checkout_startTime");
        String endTime = (String) session.getAttribute("checkout_endTime");
        Double hours = (Double) session.getAttribute("checkout_hours");
        BigDecimal totalAmount = (BigDecimal) session.getAttribute("checkout_totalAmount");
        BigDecimal discountAmount = (BigDecimal) session.getAttribute("coupon_discount");

        if (station == null || slot == null || dateStr == null || totalAmount == null) {
            response.sendRedirect(request.getContextPath() + "/search-stations");
            return;
        }

        if (discountAmount == null) {
            discountAmount = BigDecimal.ZERO;
        }
        BigDecimal finalAmount = totalAmount.subtract(discountAmount);
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "UPI";
        }

        try {
            // Generate unique booking number: EVBK-YYYY-XXXXX
            String datePrefix = new SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
            String randomSuffix = String.format("%04d", (int) (Math.random() * 10000));
            String bookingNumber = "EVBK-" + datePrefix + "-" + randomSuffix;

            // 1. Create booking record
            Booking booking = new Booking();
            booking.setBookingNumber(bookingNumber);
            booking.setUserId(currentUser.getId());
            booking.setStationId(station.getId());
            booking.setSlotId(slot.getId());
            booking.setBookingDate(Date.valueOf(dateStr));
            booking.setStartTime(startTime);
            booking.setEndTime(endTime);
            booking.setTotalHours(BigDecimal.valueOf(hours != null ? hours : 1.0));
            booking.setTotalAmount(totalAmount);
            booking.setDiscountAmount(discountAmount);
            booking.setFinalAmount(finalAmount);
            booking.setStatus("BOOKED");

            int bookingId = bookingDAO.createBooking(booking);

            if (bookingId > 0) {
                // 2. Generate simulated payment record with fake transaction ID
                String fakeTxnId = "TXN-EV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

                Payment payment = new Payment();
                payment.setBookingId(bookingId);
                payment.setUserId(currentUser.getId());
                payment.setTransactionId(fakeTxnId);
                payment.setPaymentMethod(paymentMethod.toUpperCase());
                payment.setAmount(finalAmount);
                payment.setPaymentStatus("SUCCESS");

                paymentDAO.createPayment(payment);

                // Clean checkout session data
                session.removeAttribute("checkout_station");
                session.removeAttribute("checkout_slot");
                session.removeAttribute("checkout_date");
                session.removeAttribute("checkout_startTime");
                session.removeAttribute("checkout_endTime");
                session.removeAttribute("checkout_hours");
                session.removeAttribute("checkout_totalAmount");
                session.removeAttribute("applied_coupon");
                session.removeAttribute("coupon_discount");

                // Redirect to booking confirmation view
                response.sendRedirect(request.getContextPath() + "/booking?action=confirmation&id=" + bookingId);
            } else {
                request.setAttribute("errorMessage", "Payment simulation succeeded but booking creation failed.");
                request.getRequestDispatcher("/user/payment.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Payment processing error: " + e.getMessage());
            request.getRequestDispatcher("/user/payment.jsp").forward(request, response);
        }
    }
}
