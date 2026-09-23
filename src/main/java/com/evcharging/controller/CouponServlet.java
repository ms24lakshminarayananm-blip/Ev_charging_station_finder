package com.evcharging.controller;

import com.evcharging.dao.CouponDAO;
import com.evcharging.model.Coupon;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/coupon")
public class CouponServlet extends HttpServlet {
    private final CouponDAO couponDAO = new CouponDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        String code = request.getParameter("couponCode");

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("remove".equalsIgnoreCase(action)) {
            session.removeAttribute("applied_coupon");
            session.removeAttribute("coupon_discount");
            response.sendRedirect(request.getContextPath() + "/payment?couponRemoved=true");
            return;
        }

        BigDecimal totalAmount = (BigDecimal) session.getAttribute("checkout_totalAmount");
        if (totalAmount == null) {
            response.sendRedirect(request.getContextPath() + "/search-stations");
            return;
        }

        if (code == null || code.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/payment?error=empty_coupon");
            return;
        }

        Coupon coupon = couponDAO.getByCode(code.trim());
        if (coupon == null) {
            response.sendRedirect(request.getContextPath() + "/payment?error=invalid_coupon");
            return;
        }

        if (totalAmount.compareTo(coupon.getMinAmount()) < 0) {
            response.sendRedirect(request.getContextPath() + "/payment?error=min_amount&min=" + coupon.getMinAmount());
            return;
        }

        // Calculate discount
        BigDecimal discount = totalAmount.multiply(BigDecimal.valueOf(coupon.getDiscountPercentage()))
                                         .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
        if (discount.compareTo(coupon.getMaxDiscount()) > 0) {
            discount = coupon.getMaxDiscount();
        }

        session.setAttribute("applied_coupon", coupon);
        session.setAttribute("coupon_discount", discount);

        response.sendRedirect(request.getContextPath() + "/payment?couponApplied=true");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/payment");
    }
}
