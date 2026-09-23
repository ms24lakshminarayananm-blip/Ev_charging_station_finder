<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.User" %>
<%@ page import="com.evcharging.model.Booking" %>
<%@ page import="com.evcharging.model.WaitingList" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    if (recentBookings == null) {
        response.sendRedirect(request.getContextPath() + "/user/dashboard");
        return;
    }

    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer activeBookingsCount = (Integer) request.getAttribute("activeBookingsCount");
    Integer totalStationsCount = (Integer) request.getAttribute("totalStationsCount");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:10px;">
        <div>
            <h2>Welcome back, <%= currentUser.getName() %>! 👋</h2>
            <p style="color: #64748b;">Vehicle: <%= (currentUser.getVehicleModel() != null && !currentUser.getVehicleModel().isEmpty()) ? currentUser.getVehicleModel() : "Electric Vehicle" %> (<%= (currentUser.getVehicleNumber() != null && !currentUser.getVehicleNumber().isEmpty()) ? currentUser.getVehicleNumber() : "No Number Added" %>)</p>
        </div>
        <div style="display:flex; gap:10px;">
            <a href="<%= ctx %>/search-stations" class="btn btn-primary">⚡ Find Charging Stations</a>
            <a href="<%= ctx %>/waiting-list" class="btn btn-outline">My Waiting List</a>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="grid-3" style="margin-bottom: 30px;">
        <div class="stat-box">
            <div class="number"><%= activeBookingsCount != null ? activeBookingsCount : 0 %></div>
            <div class="label">Active Bookings</div>
        </div>
        <div class="stat-box">
            <div class="number"><%= totalBookings != null ? totalBookings : 0 %></div>
            <div class="label">Total Lifetime Bookings</div>
        </div>
        <div class="stat-box">
            <div class="number"><%= totalStationsCount != null ? totalStationsCount : 5 %></div>
            <div class="label">Verified Stations Available</div>
        </div>
    </div>

    <!-- Recent Bookings Section -->
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
            <h3>My Recent Slot Bookings</h3>
            <a href="<%= ctx %>/booking?action=list" class="btn btn-sm btn-outline">View All Bookings &rarr;</a>
        </div>

        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
            <div style="text-align:center; padding: 30px; color:#64748b;">
                <p style="font-size:1.1rem; margin-bottom: 12px;">You haven't made any charging reservations yet.</p>
                <a href="<%= ctx %>/search-stations" class="btn btn-primary">Explore Stations & Book a Slot</a>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Booking #</th>
                            <th>Station Name</th>
                            <th>Slot</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int limit = 0;
                            for (Booking b : recentBookings) {
                                if (limit++ >= 5) break;
                        %>
                        <tr>
                            <td><strong><%= b.getBookingNumber() %></strong></td>
                            <td><%= b.getStationName() %></td>
                            <td><%= b.getSlotNumber() %> (<%= b.getChargerType() %>)</td>
                            <td><%= b.getBookingDate() %></td>
                            <td><%= b.getStartTime() %> - <%= b.getEndTime() %></td>
                            <td><strong>₹<%= b.getFinalAmount() %></strong></td>
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
                                <% if ("BOOKED".equalsIgnoreCase(b.getStatus())) { %>
                                    <form action="<%= ctx %>/cancel-booking" method="POST" style="display:inline;" onsubmit="return confirmCancelBooking();">
                                        <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger">Cancel</button>
                                    </form>
                                <% } else { %>
                                    <a href="<%= ctx %>/review?stationId=<%= b.getStationId() %>" class="btn btn-sm btn-outline">Rate Station</a>
                                <% } %>
                            </td>
                        </tr>
                        <%  } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
