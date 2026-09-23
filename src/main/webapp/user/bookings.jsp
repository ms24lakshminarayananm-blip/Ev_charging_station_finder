<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Booking" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String ctx = request.getContextPath();

    if (bookings == null) {
        response.sendRedirect(ctx + "/booking?action=list");
        return;
    }
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:10px;">
        <div>
            <h2>My Charging Bookings</h2>
            <p style="color: #64748b;">Manage your current and past charging reservations</p>
        </div>
        <a href="<%= ctx %>/search-stations" class="btn btn-primary">⚡ Book New Slot</a>
    </div>

    <% if ("true".equals(request.getParameter("cancelled"))) { %>
        <div class="alert alert-success">Booking was successfully cancelled.</div>
    <% } %>

    <% if ("cancel_failed".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">Unable to cancel this reservation. Only active bookings can be cancelled.</div>
    <% } %>

    <div class="card">
        <% if (bookings.isEmpty()) { %>
            <div style="text-align:center; padding: 40px; color:#64748b;">
                <h3>No bookings found</h3>
                <p style="margin: 10px 0 20px;">You have not made any slot bookings yet.</p>
                <a href="<%= ctx %>/search-stations" class="btn btn-primary">Find a Station Near You</a>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Booking #</th>
                            <th>Station & City</th>
                            <th>Slot / Connector</th>
                            <th>Date</th>
                            <th>Time Window</th>
                            <th>Amount Paid</th>
                            <th>Status</th>
                            <th>Actions</th>
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
                                <td>
                                    <%= b.getSlotNumber() %><br>
                                    <small style="color:#64748b;"><%= b.getChargerType() %></small>
                                </td>
                                <td><%= b.getBookingDate() %></td>
                                <td><%= b.getStartTime() %> - <%= b.getEndTime() %></td>
                                <td>
                                    <strong>₹<%= b.getFinalAmount() %></strong>
                                    <% if (b.getDiscountAmount() != null && b.getDiscountAmount().doubleValue() > 0) { %>
                                        <br><small style="color:#059669;">(Saved ₹<%= b.getDiscountAmount() %>)</small>
                                    <% } %>
                                </td>
                                <td>
                                    <% if ("BOOKED".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge badge-booked">BOOKED</span>
                                    <% } else if ("CANCELLED".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge badge-cancelled">CANCELLED</span>
                                    <% } else { %>
                                        <span class="badge badge-success"><%= b.getStatus() %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="display:flex; gap: 6px; align-items:center;">
                                        <% if ("BOOKED".equalsIgnoreCase(b.getStatus())) { %>
                                            <form action="<%= ctx %>/cancel-booking" method="POST" style="margin:0;" onsubmit="return confirmCancelBooking();">
                                                <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-danger">Cancel</button>
                                            </form>
                                        <% } %>
                                        <a href="<%= ctx %>/review?stationId=<%= b.getStationId() %>" class="btn btn-sm btn-outline">Review</a>
                                    </div>
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
