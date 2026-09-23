<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Booking" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
        <div>
            <h2>All System Reservations</h2>
            <p style="color: #64748b;">Global record of charging bookings and financial settlements</p>
        </div>
        <a href="<%= ctx %>/admin/dashboard" class="btn btn-outline">&larr; Admin Dashboard</a>
    </div>

    <div class="card">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <p style="text-align:center; padding:30px; color:#64748b;">No bookings placed on the platform yet.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Booking #</th>
                            <th>Station & City</th>
                            <th>Bay</th>
                            <th>Customer & Vehicle</th>
                            <th>Date & Time</th>
                            <th>Total</th>
                            <th>Discount</th>
                            <th>Net Paid</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Booking b : bookings) { %>
                            <tr>
                                <td><strong><%= b.getBookingNumber() %></strong></td>
                                <td>
                                    <strong><%= b.getStationName() %></strong><br>
                                    <small style="color:#64748b;"><%= b.getStationCity() %></small>
                                </td>
                                <td><%= b.getSlotNumber() %></td>
                                <td>
                                    <%= b.getUserName() %><br>
                                    <small style="color:#64748b;"><%= b.getUserVehicleNumber() %></small>
                                </td>
                                <td><%= b.getBookingDate() %><br><small><%= b.getStartTime() %> - <%= b.getEndTime() %></small></td>
                                <td>₹<%= b.getTotalAmount() %></td>
                                <td><%= (b.getDiscountAmount() != null && b.getDiscountAmount().doubleValue() > 0) ? "₹" + b.getDiscountAmount() : "-" %></td>
                                <td><strong style="color:var(--primary);">₹<%= b.getFinalAmount() %></strong></td>
                                <td>
                                    <% if ("BOOKED".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge badge-booked">BOOKED</span>
                                    <% } else if ("CANCELLED".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge badge-cancelled">CANCELLED</span>
                                    <% } else { %>
                                        <span class="badge badge-success"><%= b.getStatus() %></span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
