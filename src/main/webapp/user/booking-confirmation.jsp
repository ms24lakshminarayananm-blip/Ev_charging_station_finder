<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Booking" %>
<%@ page import="com.evcharging.dao.PaymentDAO" %>
<%@ page import="com.evcharging.model.Payment" %>
<jsp:include page="/includes/header.jsp" />

<%
    Booking booking = (Booking) request.getAttribute("booking");
    String ctx = request.getContextPath();

    if (booking == null) {
        response.sendRedirect(ctx + "/booking?action=list");
        return;
    }

    PaymentDAO paymentDAO = new PaymentDAO();
    Payment payment = paymentDAO.getByBookingId(booking.getId());
%>

<div class="container" style="max-width: 650px; margin-top: 40px; margin-bottom: 60px;">
    <div class="card" style="text-align:center; padding: 36px; box-shadow: var(--shadow-lg); border-top: 5px solid var(--primary);">
        <div style="width: 70px; height: 70px; background: #d1fae5; color: #059669; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 16px;">
            ✓
        </div>

        <h2 style="color: #065f46; margin-bottom: 6px;">Payment Successful!</h2>
        <p style="color: #475569; font-size: 1rem; margin-bottom: 24px;">Your EV charging slot has been reserved successfully.</p>

        <!-- Booking & Transaction Info Card -->
        <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; text-align: left; margin-bottom: 24px; font-size: 0.95rem;">
            <div style="display:flex; justify-content:space-between; margin-bottom: 10px; border-bottom: 1px dashed #cbd5e1; padding-bottom: 8px;">
                <span style="color:#64748b;">Booking Number:</span>
                <strong style="color:var(--primary); font-size:1.1rem;"><%= booking.getBookingNumber() %></strong>
            </div>

            <% if (payment != null) { %>
                <div style="display:flex; justify-content:space-between; margin-bottom: 10px; border-bottom: 1px dashed #cbd5e1; padding-bottom: 8px;">
                    <span style="color:#64748b;">Simulated Transaction ID:</span>
                    <code style="font-weight:700; color:#0284c7;"><%= payment.getTransactionId() %></code>
                </div>
                <div style="display:flex; justify-content:space-between; margin-bottom: 10px;">
                    <span style="color:#64748b;">Payment Method:</span>
                    <span class="badge badge-success"><%= payment.getPaymentMethod() %> (SUCCESS)</span>
                </div>
            <% } %>

            <div style="display:flex; justify-content:space-between; margin-bottom: 10px;">
                <span style="color:#64748b;">Station:</span>
                <strong><%= booking.getStationName() %></strong>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 10px;">
                <span style="color:#64748b;">Location:</span>
                <span><%= booking.getStationAddress() %>, <%= booking.getStationCity() %></span>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 10px;">
                <span style="color:#64748b;">Slot / Bay:</span>
                <span><%= booking.getSlotNumber() %> (<%= booking.getChargerType() %>)</span>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom: 10px;">
                <span style="color:#64748b;">Date & Time:</span>
                <span><%= booking.getBookingDate() %> &bull; <%= booking.getStartTime() %> - <%= booking.getEndTime() %></span>
            </div>
            <div style="display:flex; justify-content:space-between; border-top: 1px solid #cbd5e1; padding-top: 10px; margin-top: 10px;">
                <span style="color:#0f172a; font-weight:700;">Final Amount Paid:</span>
                <strong style="color:var(--primary); font-size:1.2rem;">₹<%= booking.getFinalAmount() %></strong>
            </div>
        </div>

        <div style="display:flex; gap: 12px; justify-content:center;">
            <a href="<%= ctx %>/booking?action=list" class="btn btn-primary">View My Bookings</a>
            <a href="<%= ctx %>/review?stationId=<%= booking.getStationId() %>" class="btn btn-outline">Rate Station</a>
            <a href="<%= ctx %>/user/dashboard" class="btn btn-outline">Dashboard</a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
