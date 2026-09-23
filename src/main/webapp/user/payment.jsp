<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="com.evcharging.model.ChargingSlot" %>
<%@ page import="com.evcharging.model.Coupon" %>
<%@ page import="java.math.BigDecimal" %>
<jsp:include page="/includes/header.jsp" />

<%
    Station station = (Station) request.getAttribute("station");
    ChargingSlot slot = (ChargingSlot) request.getAttribute("slot");
    BigDecimal originalAmount = (BigDecimal) request.getAttribute("originalAmount");
    BigDecimal discountAmount = (BigDecimal) request.getAttribute("discountAmount");
    BigDecimal finalAmount = (BigDecimal) request.getAttribute("finalAmount");
    Coupon appliedCoupon = (Coupon) request.getAttribute("appliedCoupon");
    String couponError = (String) request.getAttribute("couponError");
    String ctx = request.getContextPath();

    if (station == null || slot == null || originalAmount == null) {
        response.sendRedirect(ctx + "/search-stations");
        return;
    }
%>

<div class="container" style="max-width: 720px; margin-top: 30px; margin-bottom: 60px;">
    <div style="margin-bottom: 20px;">
        <a href="<%= ctx %>/booking?stationId=<%= station.getId() %>" style="color: #64748b; text-decoration: none; font-size: 0.9rem;">
            &larr; Back to Slot Selection
        </a>
    </div>

    <% if (couponError != null) { %>
        <div class="alert alert-error"><%= couponError %></div>
    <% } %>

    <% if ("true".equals(request.getParameter("couponApplied"))) { %>
        <div class="alert alert-success">Coupon applied successfully! You saved money on your charge.</div>
    <% } %>

    <% if ("true".equals(request.getParameter("couponRemoved"))) { %>
        <div class="alert alert-info">Coupon removed.</div>
    <% } %>

    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="margin-bottom: 20px; border-bottom: 1px solid #e2e8f0; padding-bottom: 16px;">
            <h2>Simulated Checkout & Payment</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Review your booking summary, apply discounts, and complete payment</p>
        </div>

        <!-- Booking Summary Details -->
        <div style="background: #f8fafc; padding: 16px; border-radius: 6px; margin-bottom: 20px; font-size: 0.9rem;">
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;">
                <span style="color:#64748b;">Charging Station:</span>
                <strong><%= station.getName() %></strong>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;">
                <span style="color:#64748b;">Location:</span>
                <span><%= station.getAddress() %>, <%= station.getCity() %></span>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 8px;">
                <span style="color:#64748b;">Bay & Charger Type:</span>
                <span><%= slot.getSlotNumber() %> (<%= slot.getChargerType() %>)</span>
            </div>
            <div style="display:flex; justify-content:space-between;">
                <span style="color:#64748b;">Scheduled Slot:</span>
                <span><%= session.getAttribute("checkout_date") %> &bull; <%= session.getAttribute("checkout_startTime") %> to <%= session.getAttribute("checkout_endTime") %></span>
            </div>
        </div>

        <!-- Coupon Application Section -->
        <div style="background: #fdf4ff; border: 1px solid #f0abfc; padding: 16px; border-radius: 6px; margin-bottom: 20px;">
            <label style="font-weight: 700; color: #86198f; font-size: 0.95rem; display:block; margin-bottom: 6px;">
                🎟️ Have a Promo Coupon?
            </label>

            <% if (appliedCoupon != null) { %>
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <span class="badge badge-success" style="font-size:0.9rem; padding: 6px 12px;">
                            <%= appliedCoupon.getCode() %> (<%= appliedCoupon.getDiscountPercentage() %>% OFF Applied)
                        </span>
                        <span style="color:#065f46; font-size:0.85rem; margin-left: 8px;">
                            - ₹<%= discountAmount %> saved!
                        </span>
                    </div>
                    <form action="<%= ctx %>/coupon" method="POST" style="margin:0;">
                        <input type="hidden" name="action" value="remove">
                        <button type="submit" class="btn btn-sm btn-outline" style="color:#991b1b; border-color:#fecaca;">Remove</button>
                    </form>
                </div>
            <% } else { %>
                <form action="<%= ctx %>/coupon" method="POST" style="display:flex; gap: 10px;">
                    <input type="text" name="couponCode" class="form-control" placeholder="Enter coupon code (e.g. EV10, SAVE20)" style="text-transform:uppercase;" required>
                    <button type="submit" class="btn btn-secondary" style="white-space: nowrap;">Apply Coupon</button>
                </form>
                <div style="margin-top: 8px; font-size: 0.8rem; color: #701a75;">
                    Try available demo coupons: <strong>EV10</strong> (10% discount) or <strong>SAVE20</strong> (20% discount)
                </div>
            <% } %>
        </div>

        <!-- Amount Breakdown -->
        <div class="checkout-box" style="margin-bottom: 24px; padding: 18px;">
            <div class="checkout-row">
                <span>Original Amount</span>
                <span>₹<%= originalAmount %></span>
            </div>
            <div class="checkout-row" style="color: #059669;">
                <span>Coupon Discount</span>
                <span>- ₹<%= discountAmount %></span>
            </div>
            <div class="checkout-row total">
                <span>Final Payable Amount</span>
                <span style="color: var(--primary);">₹<%= finalAmount %></span>
            </div>
        </div>

        <!-- Simulated Payment Method Selection -->
        <div style="margin-bottom: 24px;">
            <label style="font-weight: 700; color: #0f172a; font-size: 0.95rem; display:block; margin-bottom: 8px;">
                Select Simulated Payment Method
            </label>
            <div class="payment-tab-group">
                <div class="payment-tab active" data-method="UPI">
                    📱 UPI (GPay / PhonePe)
                </div>
                <div class="payment-tab" data-method="WALLET">
                    👛 EV Wallet
                </div>
                <div class="payment-tab" data-method="CARD">
                    💳 Credit / Debit Card
                </div>
            </div>

            <!-- Dynamic simulated inputs container -->
            <div id="paymentMethodDetails" style="background:#f8fafc; padding: 14px; border-radius: 6px; border: 1px solid #e2e8f0; margin-top: 10px;">
                <div class="form-group" style="margin-bottom: 0;">
                    <label>UPI ID (Google Pay / PhonePe / Paytm)</label>
                    <input type="text" class="form-control" placeholder="user@upi / mobile@okhdfcbank" value="user@okhdfcbank" required>
                    <small style="color: #64748b; font-size:0.75rem;">Simulated UPI verification - no real money will be charged.</small>
                </div>
            </div>
        </div>

        <!-- Final Pay Button -->
        <form action="<%= ctx %>/payment" method="POST">
            <input type="hidden" id="selectedPaymentMethod" name="paymentMethod" value="UPI">
            <button type="submit" class="btn btn-primary btn-block" style="padding: 16px; font-size: 1.15rem; font-weight:700; box-shadow: 0 4px 12px rgba(5,150,105,0.3);">
                🔒 Pay ₹<%= finalAmount %> & Confirm Reservation
            </button>
        </form>

        <p style="text-align:center; font-size:0.8rem; color:#94a3b8; margin-top: 12px;">
            Demo Mode: Instant simulated transaction confirmation with generated transaction ID.
        </p>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
