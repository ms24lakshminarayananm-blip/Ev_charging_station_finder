<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.StationOwner" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="com.evcharging.model.Booking" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    StationOwner owner = (StationOwner) session.getAttribute("owner");
    if (owner == null) {
        response.sendRedirect(request.getContextPath() + "/owner/login.jsp");
        return;
    }

    List<Station> stations = (List<Station>) request.getAttribute("stations");
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    if (stations == null) {
        response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        return;
    }

    Integer totalStations = (Integer) request.getAttribute("totalStations");
    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer activeBookings = (Integer) request.getAttribute("activeBookings");
    Double totalEarnings = (Double) request.getAttribute("totalEarnings");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:10px;">
        <div>
            <h2><%= owner.getBusinessName() != null ? owner.getBusinessName() : owner.getName() %> ⚡</h2>
            <p style="color: #64748b;">Station Owner Management Dashboard &bull; <%= owner.getEmail() %></p>
        </div>
        <div style="display:flex; gap:10px;">
            <a href="<%= ctx %>/owner/add-station" class="btn btn-primary">+ Add New Station</a>
            <a href="<%= ctx %>/owner/live-status" class="btn btn-outline">Live Bay Status</a>
        </div>
    </div>

    <!-- Metrics Stats -->
    <div class="grid-4" style="margin-bottom: 30px;">
        <div class="stat-box">
            <div class="number"><%= totalStations != null ? totalStations : 0 %></div>
            <div class="label">Owned Stations</div>
        </div>
        <div class="stat-box">
            <div class="number"><%= totalBookings != null ? totalBookings : 0 %></div>
            <div class="label">Total Reservations</div>
        </div>
        <div class="stat-box">
            <div class="number" style="color:#0284c7;"><%= activeBookings != null ? activeBookings : 0 %></div>
            <div class="label">Active Slots Booked</div>
        </div>
        <div class="stat-box">
            <div class="number" style="color:#059669;">₹<%= totalEarnings != null ? Math.round(totalEarnings) : 0 %></div>
            <div class="label">Total Revenue</div>
        </div>
    </div>

    <!-- My Stations Overview -->
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
            <h3>My Charging Stations</h3>
            <a href="<%= ctx %>/owner/manage-stations" class="btn btn-sm btn-outline">Manage All &rarr;</a>
        </div>

        <% if (stations.isEmpty()) { %>
            <div style="text-align:center; padding: 30px; color:#64748b;">
                <p style="font-size:1.05rem; margin-bottom: 12px;">You haven't listed any charging stations yet.</p>
                <a href="<%= ctx %>/owner/add-station" class="btn btn-primary">Register Your First Station</a>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Station Name</th>
                            <th>City</th>
                            <th>Connectors</th>
                            <th>Pricing (₹/unit)</th>
                            <th>Total Slots</th>
                            <th>Approval Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Station s : stations) { %>
                            <tr>
                                <td><strong><%= s.getName() %></strong></td>
                                <td><%= s.getCity() %></td>
                                <td><%= s.getChargerTypes() %></td>
                                <td><strong>₹<%= s.getPricePerUnit() %></strong></td>
                                <td><%= s.getTotalSlots() %> Bays</td>
                                <td>
                                    <% if ("APPROVED".equalsIgnoreCase(s.getApprovalStatus())) { %>
                                        <span class="badge badge-approved">APPROVED</span>
                                    <% } else if ("PENDING".equalsIgnoreCase(s.getApprovalStatus())) { %>
                                        <span class="badge badge-pending">PENDING APPROVAL</span>
                                    <% } else { %>
                                        <span class="badge badge-rejected">REJECTED</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="display:flex; gap: 6px;">
                                        <a href="<%= ctx %>/owner/update-station?id=<%= s.getId() %>" class="btn btn-sm btn-outline">Edit / Price</a>
                                        <a href="<%= ctx %>/owner/live-status" class="btn btn-sm btn-primary">Slots</a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <!-- Recent Bookings Table -->
    <div class="card" style="margin-top: 24px;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
            <h3>Recent Bookings at My Stations</h3>
            <a href="<%= ctx %>/owner/bookings" class="btn btn-sm btn-outline">All Bookings &rarr;</a>
        </div>

        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
            <p style="color:#64748b; padding: 15px 0;">No bookings recorded for your stations yet.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Booking #</th>
                            <th>Station</th>
                            <th>Bay</th>
                            <th>Driver</th>
                            <th>Date & Time</th>
                            <th>Revenue</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int count = 0;
                            for (Booking b : recentBookings) {
                                if (count++ >= 5) break;
                        %>
                            <tr>
                                <td><strong><%= b.getBookingNumber() %></strong></td>
                                <td><%= b.getStationName() %></td>
                                <td><%= b.getSlotNumber() %></td>
                                <td><%= b.getUserName() %> (<%= b.getUserVehicleNumber() %>)</td>
                                <td><%= b.getBookingDate() %> &bull; <%= b.getStartTime() %></td>
                                <td><strong>₹<%= b.getFinalAmount() %></strong></td>
                                <td><span class="badge badge-booked"><%= b.getStatus() %></span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
