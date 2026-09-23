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
            <h2>Station Bookings & Charging Sessions</h2>
            <p style="color: #64748b;">Comprehensive log of all reservations placed at your stations</p>
        </div>
        <a href="<%= ctx %>/owner/dashboard" class="btn btn-outline">&larr; Dashboard</a>
    </div>

    <div class="card">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div style="text-align:center; padding: 40px; color:#64748b;">
                <h3>No bookings recorded yet</h3>
                <p>When drivers reserve slots at your approved stations, they will show up here.</p>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Booking #</th>
                            <th>Station Name</th>
                            <th>Slot / Connector</th>
                            <th>Driver & Vehicle</th>
                            <th>Contact Phone</th>
                            <th>Date</th>
                            <th>Time Window</th>
                            <th>Final Revenue</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Booking b : bookings) { %>
                            <tr>
                                <td><strong><%= b.getBookingNumber() %></strong></td>
                                <td><%= b.getStationName() %></td>
                                <td><%= b.getSlotNumber() %> (<%= b.getChargerType() %>)</td>
                                <td>
                                    <strong><%= b.getUserName() %></strong><br>
                                    <small style="color:#64748b;"><%= b.getUserVehicleNumber() %></small>
                                </td>
                                <td><%= b.getUserPhone() %></td>
                                <td><%= b.getBookingDate() %></td>
                                <td><%= b.getStartTime() %> - <%= b.getEndTime() %></td>
                                <td><strong style="color:var(--primary);">₹<%= b.getFinalAmount() %></strong></td>
                                <td>
                                    <% if ("BOOKED".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge badge-booked">ACTIVE</span>
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
