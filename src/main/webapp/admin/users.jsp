<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.User" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<User> users = (List<User>) request.getAttribute("users");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
        <div>
            <h2>Registered EV Users</h2>
            <p style="color: #64748b;">Manage customer accounts, vehicles, and status</p>
        </div>
        <a href="<%= ctx %>/admin/dashboard" class="btn btn-outline">&larr; Admin Dashboard</a>
    </div>

    <div class="card">
        <% if (users == null || users.isEmpty()) { %>
            <p style="text-align:center; padding:30px; color:#64748b;">No registered users found.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Phone</th>
                            <th>Vehicle Details</th>
                            <th>Account Status</th>
                            <th>Registered On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : users) { %>
                            <tr>
                                <td>#<%= u.getId() %></td>
                                <td><strong><%= u.getName() %></strong></td>
                                <td><%= u.getEmail() %></td>
                                <td><%= u.getPhone() %></td>
                                <td>
                                    <%= u.getVehicleModel() != null ? u.getVehicleModel() : "-" %><br>
                                    <small style="color:#64748b;"><%= u.getVehicleNumber() != null ? u.getVehicleNumber() : "" %></small>
                                </td>
                                <td><span class="badge badge-success"><%= u.getStatus() %></span></td>
                                <td><%= u.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
