<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.dao.StationDAO" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    StationDAO stationDAO = new StationDAO();
    List<Station> featuredStations = stationDAO.getAllApprovedStations();
    String ctx = request.getContextPath();
%>

<!-- Hero Section -->
<section class="hero">
    <div class="container">
        <h1>EV Charging Station Finder</h1>
        <p>Locate nearby electric vehicle charging points, check live slot availability in real time, reserve your spot, and enjoy seamless charging.</p>
        <div class="hero-actions">
            <a href="<%= ctx %>/search-stations" class="btn btn-primary" style="background:#10b981; font-size:1.05rem; padding: 12px 24px;">⚡ Find Stations Now</a>
            <% if (session.getAttribute("user") == null && session.getAttribute("owner") == null && session.getAttribute("admin") == null) { %>
                <a href="<%= ctx %>/login.jsp" class="btn btn-outline" style="background:rgba(255,255,255,0.15); color:#fff; border-color:rgba(255,255,255,0.4); padding: 12px 24px;">User Login</a>
                <a href="<%= ctx %>/register.jsp" class="btn btn-outline" style="background:rgba(255,255,255,0.15); color:#fff; border-color:rgba(255,255,255,0.4); padding: 12px 24px;">Register</a>
            <% } %>
        </div>
    </div>
</section>

<!-- Search Section Banner -->
<div class="container">
    <div class="search-banner">
        <form action="<%= ctx %>/search-stations" method="GET" class="search-form">
            <input type="text" name="query" class="form-control" placeholder="Search by City, Station Name, or Area...">
            <select name="chargerType" class="form-control">
                <option value="ALL">All Charger Types</option>
                <option value="CCS2">CCS2 Fast DC</option>
                <option value="Type 2">Type 2 AC</option>
                <option value="CHAdeMO">CHAdeMO</option>
                <option value="Bharat">Bharat DC001</option>
            </select>
            <input type="number" step="0.5" name="maxPrice" class="form-control" placeholder="Max Price (₹/unit)">
            <button type="submit" class="btn btn-primary">Search Stations</button>
        </form>
    </div>

    <!-- How It Works Section -->
    <section class="how-it-works">
        <h2>How It Works</h2>
        <div class="grid-4">
            <div class="step-card">
                <div class="step-number">1</div>
                <h3>Search</h3>
                <p>Discover fast charging stations in your city or along your planned highway route.</p>
            </div>
            <div class="step-card">
                <div class="step-number">2</div>
                <h3>Select</h3>
                <p>Compare connector types (CCS2, Type 2), power outputs, pricing, and live slots.</p>
            </div>
            <div class="step-card">
                <div class="step-number">3</div>
                <h3>Book</h3>
                <p>Reserve your preferred date and time slot with promo coupons and instant simulation.</p>
            </div>
            <div class="step-card">
                <div class="step-number">4</div>
                <h3>Charge</h3>
                <p>Drive up to the station, plug in with your confirmed booking ID, and power up!</p>
            </div>
        </div>
    </section>

    <!-- Featured Verified Stations -->
    <section style="margin: 40px 0;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
            <h2>Featured Charging Stations</h2>
            <a href="<%= ctx %>/search-stations" class="btn btn-sm btn-outline">View All &rarr;</a>
        </div>

        <div class="grid-3">
            <%
                int count = 0;
                for (Station s : featuredStations) {
                    if (count++ >= 6) break;
            %>
            <div class="station-card">
                <div>
                    <div style="display:flex; justify-content:space-between; align-items:start;">
                        <h3><%= s.getName() %></h3>
                        <span class="badge badge-approved"><%= s.getApprovalStatus() %></span>
                    </div>
                    <p style="color:#64748b; font-size:0.9rem; margin: 4px 0 10px;">📍 <%= s.getAddress() %>, <%= s.getCity() %></p>
                    <div style="margin-bottom: 10px;">
                        <span style="font-size:0.85rem; background:#f1f5f9; padding: 3px 8px; border-radius:4px; margin-right:5px;">🔌 <%= s.getChargerTypes() %></span>
                        <span style="font-size:0.85rem; background:#f1f5f9; padding: 3px 8px; border-radius:4px;">⚡ <%= s.getPowerRating() %></span>
                    </div>
                    <div class="price">₹<%= s.getPricePerUnit() %> <span style="font-size:0.85rem; font-weight:normal; color:#64748b;">/ unit</span></div>
                    <div class="rating">
                        ★ <%= s.getAverageRating() > 0 ? s.getAverageRating() : "New" %> 
                        <span style="color:#64748b; font-size:0.8rem;">(<%= s.getTotalReviews() %> reviews)</span>
                    </div>
                </div>
                <div style="margin-top: 18px; display:flex; gap: 8px;">
                    <a href="<%= ctx %>/search-stations?action=details&id=<%= s.getId() %>" class="btn btn-outline btn-block btn-sm">View Details</a>
                    <a href="<%= ctx %>/booking?stationId=<%= s.getId() %>" class="btn btn-primary btn-block btn-sm">Book Slot</a>
                </div>
            </div>
            <%  } %>
        </div>
    </section>

    <!-- Demo Accounts Quick Reference Card -->
    <section class="card" style="border-left: 4px solid var(--primary); background: #f0fdf4; margin: 30px 0;">
        <h3 style="color: #065f46; margin-bottom: 8px;">🎓 Project Demo Login Accounts</h3>
        <p style="font-size: 0.95rem; color: #166534; margin-bottom: 12px;">This project includes pre-configured demo credentials for rapid demonstration:</p>
        <div class="grid-3" style="font-size: 0.9rem;">
            <div style="background:#fff; padding:12px; border-radius:6px; border:1px solid #bbf7d0;">
                <strong>EV User</strong><br>
                Email: <code>user@gmail.com</code><br>
                Password: <code>user123</code><br>
                <a href="<%= ctx %>/login.jsp" style="color:var(--primary); font-weight:600;">Login as User &rarr;</a>
            </div>
            <div style="background:#fff; padding:12px; border-radius:6px; border:1px solid #bbf7d0;">
                <strong>Station Owner</strong><br>
                Email: <code>owner@gmail.com</code><br>
                Password: <code>owner123</code><br>
                <a href="<%= ctx %>/owner/login.jsp" style="color:var(--primary); font-weight:600;">Login as Owner &rarr;</a>
            </div>
            <div style="background:#fff; padding:12px; border-radius:6px; border:1px solid #bbf7d0;">
                <strong>Administrator</strong><br>
                Username: <code>admin</code><br>
                Password: <code>admin123</code><br>
                <a href="<%= ctx %>/admin/login.jsp" style="color:var(--primary); font-weight:600;">Login as Admin &rarr;</a>
            </div>
        </div>
    </section>
</div>

<jsp:include page="/includes/footer.jsp" />
