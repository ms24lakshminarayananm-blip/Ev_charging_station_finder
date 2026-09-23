<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.User" %>
<%@ page import="com.evcharging.model.StationOwner" %>
<%@ page import="com.evcharging.model.Admin" %>
<%
    User currentUser = (User) session.getAttribute("user");
    StationOwner currentOwner = (StationOwner) session.getAttribute("owner");
    Admin currentAdmin = (Admin) session.getAttribute("admin");
    String role = (String) session.getAttribute("role");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EV Charging Station Finder System</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= ctx %>/" class="nav-brand">
            ⚡ <span>EV Station Finder</span>
        </a>
        <ul class="nav-links">
            <li><a href="<%= ctx %>/">Home</a></li>
            <li><a href="<%= ctx %>/search-stations">Find Stations</a></li>

            <% if (currentUser != null) { %>
                <li><a href="<%= ctx %>/user/dashboard">Dashboard</a></li>
                <li><a href="<%= ctx %>/booking?action=list">My Bookings</a></li>
                <li><a href="<%= ctx %>/waiting-list">Waiting List</a></li>
                <li><span class="role-badge">User: <%= currentUser.getName() %></span></li>
                <li><a href="<%= ctx %>/logout" class="btn btn-sm btn-outline">Logout</a></li>

            <% } else if (currentOwner != null) { %>
                <li><a href="<%= ctx %>/owner/dashboard">Dashboard</a></li>
                <li><a href="<%= ctx %>/owner/add-station">Add Station</a></li>
                <li><a href="<%= ctx %>/owner/manage-stations">My Stations</a></li>
                <li><a href="<%= ctx %>/owner/bookings">Bookings</a></li>
                <li><a href="<%= ctx %>/owner/live-status">Live Status</a></li>
                <li><span class="role-badge">Owner: <%= currentOwner.getName() %></span></li>
                <li><a href="<%= ctx %>/logout" class="btn btn-sm btn-outline">Logout</a></li>

            <% } else if (currentAdmin != null) { %>
                <li><a href="<%= ctx %>/admin/dashboard">Admin Dashboard</a></li>
                <li><a href="<%= ctx %>/admin/stations">Stations</a></li>
                <li><a href="<%= ctx %>/admin/users">Users</a></li>
                <li><a href="<%= ctx %>/admin/owners">Owners</a></li>
                <li><a href="<%= ctx %>/admin/bookings">Bookings</a></li>
                <li><a href="<%= ctx %>/admin/reviews">Reviews</a></li>
                <li><span class="role-badge" style="background:#fee2e2; color:#991b1b;">Admin</span></li>
                <li><a href="<%= ctx %>/logout" class="btn btn-sm btn-outline">Logout</a></li>

            <% } else { %>
                <li><a href="<%= ctx %>/login.jsp">Login</a></li>
                <li><a href="<%= ctx %>/register.jsp" class="btn btn-sm btn-primary">Register</a></li>
                <li><a href="<%= ctx %>/owner/login.jsp" style="font-size: 0.85rem; color:#64748b;">Owner Portal</a></li>
                <li><a href="<%= ctx %>/admin/login.jsp" style="font-size: 0.85rem; color:#64748b;">Admin</a></li>
            <% } %>
        </ul>
    </div>
</nav>
