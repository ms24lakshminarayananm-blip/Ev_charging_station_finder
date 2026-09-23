<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.WaitingList" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<WaitingList> list = (List<WaitingList>) request.getAttribute("waitingList");
    String ctx = request.getContextPath();

    if (list == null) {
        response.sendRedirect(ctx + "/waiting-list");
        return;
    }
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:10px;">
        <div>
            <h2>My Charging Waiting List</h2>
            <p style="color: #64748b;">Stations and slots where you are queued for priority notification</p>
        </div>
        <a href="<%= ctx %>/search-stations" class="btn btn-primary">Find Other Available Stations</a>
    </div>

    <% if ("true".equals(request.getParameter("joined"))) { %>
        <div class="alert alert-success">You have been added to the waiting list! You will receive priority when a slot opens.</div>
    <% } %>

    <div class="card">
        <% if (list.isEmpty()) { %>
            <div style="text-align:center; padding: 40px; color:#64748b;">
                <h3>Your waiting list is currently empty</h3>
                <p style="margin: 10px 0 20px;">When a desired slot is occupied, you can join its waiting list directly from the booking screen.</p>
                <a href="<%= ctx %>/search-stations" class="btn btn-outline">Explore Charging Stations</a>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Station Name</th>
                            <th>City</th>
                            <th>Desired Date</th>
                            <th>Desired Time</th>
                            <th>Status</th>
                            <th>Date Requested</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (WaitingList w : list) { %>
                            <tr>
                                <td><strong><%= w.getStationName() %></strong></td>
                                <td><%= w.getStationCity() %></td>
                                <td><%= w.getDesiredDate() %></td>
                                <td><%= w.getDesiredTime() %></td>
                                <td>
                                    <% if ("WAITING".equalsIgnoreCase(w.getStatus())) { %>
                                        <span class="badge badge-pending">WAITING IN QUEUE</span>
                                    <% } else if ("NOTIFIED".equalsIgnoreCase(w.getStatus())) { %>
                                        <span class="badge badge-success">SLOT OPENED / NOTIFIED</span>
                                    <% } else { %>
                                        <span class="badge badge-cancelled"><%= w.getStatus() %></span>
                                    <% } %>
                                </td>
                                <td><%= w.getCreatedAt() %></td>
                                <td>
                                    <div style="display:flex; gap: 6px;">
                                        <a href="<%= ctx %>/booking?stationId=<%= w.getStationId() %>" class="btn btn-sm btn-primary">Check Availability</a>
                                        <a href="<%= ctx %>/waiting-list?action=delete&id=<%= w.getId() %>" class="btn btn-sm btn-outline" style="color:#ef4444;" onclick="return confirm('Remove from waiting list?');">Remove</a>
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
