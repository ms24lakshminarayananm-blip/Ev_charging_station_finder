<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
        <div>
            <h2>All Charging Stations</h2>
            <p style="color: #64748b;">Manage verification status, approval lifecycle, and station visibility</p>
        </div>
        <a href="<%= ctx %>/admin/dashboard" class="btn btn-outline">&larr; Admin Dashboard</a>
    </div>

    <% if ("true".equals(request.getParameter("approved"))) { %>
        <div class="alert alert-success">Station status updated to APPROVED. It is now live in public search.</div>
    <% } %>

    <% if ("true".equals(request.getParameter("rejected"))) { %>
        <div class="alert alert-error">Station status updated to REJECTED.</div>
    <% } %>

    <div class="card">
        <% if (stations == null || stations.isEmpty()) { %>
            <p style="text-align:center; padding:30px; color:#64748b;">No stations found.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Station ID</th>
                            <th>Station Name</th>
                            <th>Host / Business</th>
                            <th>City & State</th>
                            <th>Connectors</th>
                            <th>Price / unit</th>
                            <th>Slots</th>
                            <th>Status</th>
                            <th>Admin Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Station s : stations) { %>
                            <tr>
                                <td>#<%= s.getId() %></td>
                                <td>
                                    <strong><%= s.getName() %></strong><br>
                                    <small style="color:#64748b;"><%= s.getAddress() %></small>
                                </td>
                                <td><%= s.getOwnerBusinessName() != null ? s.getOwnerBusinessName() : s.getOwnerName() %></td>
                                <td><%= s.getCity() %>, <%= s.getState() %></td>
                                <td><%= s.getChargerTypes() %> (<%= s.getPowerRating() %>)</td>
                                <td><strong>₹<%= s.getPricePerUnit() %></strong></td>
                                <td><%= s.getTotalSlots() %> Bays</td>
                                <td>
                                    <% if ("APPROVED".equalsIgnoreCase(s.getApprovalStatus())) { %>
                                        <span class="badge badge-approved">APPROVED</span>
                                    <% } else if ("PENDING".equalsIgnoreCase(s.getApprovalStatus())) { %>
                                        <span class="badge badge-pending">PENDING</span>
                                    <% } else { %>
                                        <span class="badge badge-rejected">REJECTED</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="display:flex; gap: 6px;">
                                        <% if (!"APPROVED".equalsIgnoreCase(s.getApprovalStatus())) { %>
                                            <form action="<%= ctx %>/admin/approve-station" method="POST" style="margin:0;">
                                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-success" style="background:#059669;">Approve</button>
                                            </form>
                                        <% } %>
                                        <% if (!"REJECTED".equalsIgnoreCase(s.getApprovalStatus())) { %>
                                            <form action="<%= ctx %>/admin/reject-station" method="POST" style="margin:0;">
                                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                            </form>
                                        <% } %>
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
