<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    Station editStation = (Station) request.getAttribute("station");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:10px;">
        <div>
            <h2>Manage Stations & Pricing</h2>
            <p style="color: #64748b;">Configure tariffs, amenities, and details for your charging infrastructure</p>
        </div>
        <a href="<%= ctx %>/owner/add-station" class="btn btn-primary">+ Add New Station</a>
    </div>

    <% if ("true".equals(request.getParameter("created"))) { %>
        <div class="alert alert-success">Station successfully registered! It is now pending admin review.</div>
    <% } %>

    <% if ("true".equals(request.getParameter("updated"))) { %>
        <div class="alert alert-success">Station details and pricing updated successfully!</div>
    <% } %>

    <!-- Edit Form if a specific station is selected -->
    <% if (editStation != null) { %>
        <div class="card" style="border: 2px solid var(--secondary); margin-bottom: 30px; box-shadow: var(--shadow-lg);">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
                <h3>Edit Station & Set Price: <%= editStation.getName() %></h3>
                <a href="<%= ctx %>/owner/manage-stations" class="btn btn-sm btn-outline">&times; Close Edit</a>
            </div>

            <form action="<%= ctx %>/owner/update-station" method="POST">
                <input type="hidden" name="id" value="<%= editStation.getId() %>">

                <div class="grid-2">
                    <div class="form-group">
                        <label>Station Name *</label>
                        <input type="text" name="name" class="form-control" value="<%= editStation.getName() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Charging Price (₹ per unit / kWh) *</label>
                        <input type="number" step="0.5" name="pricePerUnit" class="form-control" value="<%= editStation.getPricePerUnit() %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Address *</label>
                    <input type="text" name="address" class="form-control" value="<%= editStation.getAddress() %>" required>
                </div>

                <div class="grid-3">
                    <div class="form-group">
                        <label>City *</label>
                        <input type="text" name="city" class="form-control" value="<%= editStation.getCity() %>" required>
                    </div>
                    <div class="form-group">
                        <label>State *</label>
                        <input type="text" name="state" class="form-control" value="<%= editStation.getState() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Pincode *</label>
                        <input type="text" name="pincode" class="form-control" value="<%= editStation.getPincode() %>" required>
                    </div>
                </div>

                <div class="grid-3">
                    <div class="form-group">
                        <label>Connector Types</label>
                        <input type="text" name="chargerTypes" class="form-control" value="<%= editStation.getChargerTypes() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Power Output</label>
                        <input type="text" name="powerRating" class="form-control" value="<%= editStation.getPowerRating() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Total Bays / Slots</label>
                        <input type="number" name="totalSlots" class="form-control" value="<%= editStation.getTotalSlots() %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Amenities</label>
                    <input type="text" name="amenities" class="form-control" value="<%= editStation.getAmenities() != null ? editStation.getAmenities() : "" %>">
                </div>

                <button type="submit" class="btn btn-secondary" style="padding: 10px 20px;">Save Station Changes</button>
                <a href="<%= ctx %>/owner/manage-stations" class="btn btn-outline" style="margin-left: 8px;">Cancel</a>
            </form>
        </div>
    <% } %>

    <!-- Stations List Table -->
    <div class="card">
        <h3>All Registered Stations</h3>
        <% if (stations == null || stations.isEmpty()) { %>
            <div style="text-align:center; padding: 40px; color:#64748b;">
                <p>No stations found.</p>
                <a href="<%= ctx %>/owner/add-station" class="btn btn-primary" style="margin-top: 10px;">Register New Station</a>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Station Name</th>
                            <th>Location</th>
                            <th>Connectors</th>
                            <th>Current Price</th>
                            <th>Bays</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Station s : stations) { %>
                            <tr>
                                <td><strong><%= s.getName() %></strong></td>
                                <td><%= s.getAddress() %>, <%= s.getCity() %></td>
                                <td><%= s.getChargerTypes() %> (<%= s.getPowerRating() %>)</td>
                                <td><strong style="color:var(--primary); font-size:1.05rem;">₹<%= s.getPricePerUnit() %></strong> / unit</td>
                                <td><%= s.getTotalSlots() %> Slots</td>
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
                                        <a href="<%= ctx %>/owner/update-station?id=<%= s.getId() %>" class="btn btn-sm btn-outline">Edit / Set Price</a>
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
</div>

<jsp:include page="/includes/footer.jsp" />
