<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Admin" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:include page="/includes/header.jsp" />

<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Station> pendingStations = (List<Station>) request.getAttribute("pendingStations");
    if (stats == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:10px;">
        <div>
            <h2>Administrator Overview 🛡️</h2>
            <p style="color: #64748b;">System Governance, Compliance & Station Approval Management</p>
        </div>
        <div style="display:flex; gap:10px;">
            <a href="<%= ctx %>/admin/stations" class="btn btn-outline">All Stations</a>
            <a href="<%= ctx %>/admin/users" class="btn btn-outline">Users</a>
            <a href="<%= ctx %>/admin/owners" class="btn btn-outline">Owners</a>
        </div>
    </div>

    <% if ("true".equals(request.getParameter("approved"))) { %>
        <div class="alert alert-success">Station has been APPROVED and is now immediately visible to EV drivers!</div>
    <% } %>

    <% if ("true".equals(request.getParameter("rejected"))) { %>
        <div class="alert alert-error">Station has been marked as REJECTED.</div>
    <% } %>

    <!-- System Stats Grid -->
    <div class="grid-3" style="margin-bottom: 30px;">
        <div class="stat-box" style="border-top: 3px solid #059669;">
            <div class="number" style="color: #059669;"><%= stats.get("totalStations") %></div>
            <div class="label">Approved Active Stations</div>
        </div>
        <div class="stat-box" style="border-top: 3px solid #f59e0b;">
            <div class="number" style="color: #f59e0b;"><%= stats.get("pendingStations") %></div>
            <div class="label">Pending Approval Requests</div>
        </div>
        <div class="stat-box" style="border-top: 3px solid #0284c7;">
            <div class="number" style="color: #0284c7;"><%= stats.get("totalUsers") %></div>
            <div class="label">Registered EV Drivers</div>
        </div>
        <div class="stat-box">
            <div class="number"><%= stats.get("totalOwners") %></div>
            <div class="label">Registered Station Owners</div>
        </div>
        <div class="stat-box">
            <div class="number"><%= stats.get("totalBookings") %></div>
            <div class="label">Total Reservations</div>
        </div>
        <div class="stat-box" style="border-top: 3px solid #10b981;">
            <div class="number" style="color: #047857;">₹<%= stats.get("totalRevenue") %></div>
            <div class="label">Total Platform Volume</div>
        </div>
    </div>

    <!-- PENDING STATIONS APPROVAL WORKFLOW -->
    <div class="card" style="border: 2px solid #fbbf24; box-shadow: var(--shadow-lg);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
            <div>
                <h3 style="color:#b45309;">⚠️ Stations Awaiting Approval</h3>
                <p style="color:#78350f; font-size:0.85rem;">Review compliance details and approve stations to make them live for EV drivers.</p>
            </div>
            <span class="badge badge-pending"><%= pendingStations != null ? pendingStations.size() : 0 %> Pending</span>
        </div>

        <% if (pendingStations == null || pendingStations.isEmpty()) { %>
            <div style="text-align:center; padding: 25px; color:#64748b;">
                <p>✓ All stations are processed. No pending approval requests!</p>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Station Name</th>
                            <th>Owner / Business</th>
                            <th>City / Location</th>
                            <th>Connectors</th>
                            <th>Price</th>
                            <th>Bays</th>
                            <th>Approval Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Station s : pendingStations) { %>
                            <tr>
                                <td><strong><%= s.getName() %></strong></td>
                                <td><%= s.getOwnerBusinessName() != null ? s.getOwnerBusinessName() : s.getOwnerName() %></td>
                                <td><%= s.getAddress() %>, <strong><%= s.getCity() %></strong></td>
                                <td><%= s.getChargerTypes() %> (<%= s.getPowerRating() %>)</td>
                                <td>₹<%= s.getPricePerUnit() %>/unit</td>
                                <td><%= s.getTotalSlots() %> Bays</td>
                                <td>
                                    <div style="display:flex; gap: 8px;">
                                        <form action="<%= ctx %>/admin/approve-station" method="POST" style="margin:0;">
                                            <input type="hidden" name="id" value="<%= s.getId() %>">
                                            <input type="hidden" name="redirect" value="dashboard">
                                            <button type="submit" class="btn btn-sm btn-success" style="background:#059669;">
                                                ✓ Approve
                                            </button>
                                        </form>

                                        <form action="<%= ctx %>/admin/reject-station" method="POST" style="margin:0;">
                                            <input type="hidden" name="id" value="<%= s.getId() %>">
                                            <input type="hidden" name="redirect" value="dashboard">
                                            <button type="submit" class="btn btn-sm btn-danger">
                                                ✕ Reject
                                            </button>
                                        </form>
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
