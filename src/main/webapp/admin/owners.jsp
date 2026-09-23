<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.StationOwner" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<StationOwner> owners = (List<StationOwner>) request.getAttribute("owners");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
        <div>
            <h2>Station Partners & Owners</h2>
            <p style="color: #64748b;">Directory of charging network operators and station hosts</p>
        </div>
        <a href="<%= ctx %>/admin/dashboard" class="btn btn-outline">&larr; Admin Dashboard</a>
    </div>

    <div class="card">
        <% if (owners == null || owners.isEmpty()) { %>
            <p style="text-align:center; padding:30px; color:#64748b;">No station owners registered yet.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Owner ID</th>
                            <th>Partner / Contact Name</th>
                            <th>Company / Business Name</th>
                            <th>Email Address</th>
                            <th>Phone</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Registered On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (StationOwner o : owners) { %>
                            <tr>
                                <td>#<%= o.getId() %></td>
                                <td><strong><%= o.getName() %></strong></td>
                                <td><strong style="color:var(--secondary);"><%= o.getBusinessName() != null ? o.getBusinessName() : "-" %></strong></td>
                                <td><%= o.getEmail() %></td>
                                <td><%= o.getPhone() %></td>
                                <td><small><%= o.getAddress() != null ? o.getAddress() : "-" %></small></td>
                                <td><span class="badge badge-success"><%= o.getStatus() %></span></td>
                                <td><%= o.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
