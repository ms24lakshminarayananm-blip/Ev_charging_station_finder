<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    String query = (String) request.getAttribute("paramQuery");
    String chargerType = (String) request.getAttribute("paramChargerType");
    String maxPrice = (String) request.getAttribute("paramMaxPrice");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="margin-bottom: 24px;">
        <h2>Find EV Charging Stations</h2>
        <p style="color: #64748b;">Search by city, address, or connector type across all approved charging networks</p>
    </div>

    <!-- Search and Filters Form -->
    <div class="card" style="padding: 20px; margin-bottom: 25px;">
        <form action="<%= ctx %>/search-stations" method="GET" class="search-form">
            <div style="flex: 2; min-width: 220px;">
                <label style="font-size:0.85rem; font-weight:600; color:#475569;">Location or Station Name</label>
                <input type="text" name="query" class="form-control" placeholder="City (e.g. Bengaluru, Pune, Hyderabad)" value="<%= query != null ? query : "" %>">
            </div>
            <div style="flex: 1; min-width: 160px;">
                <label style="font-size:0.85rem; font-weight:600; color:#475569;">Charger Type</label>
                <select name="chargerType" class="form-control">
                    <option value="ALL">All Types</option>
                    <option value="CCS2" <%= "CCS2".equalsIgnoreCase(chargerType) ? "selected" : "" %>>CCS2 Fast DC</option>
                    <option value="Type 2" <%= "Type 2".equalsIgnoreCase(chargerType) ? "selected" : "" %>>Type 2 AC</option>
                    <option value="CHAdeMO" <%= "CHAdeMO".equalsIgnoreCase(chargerType) ? "selected" : "" %>>CHAdeMO</option>
                    <option value="Bharat" <%= "Bharat".equalsIgnoreCase(chargerType) ? "selected" : "" %>>Bharat DC001</option>
                </select>
            </div>
            <div style="flex: 1; min-width: 130px;">
                <label style="font-size:0.85rem; font-weight:600; color:#475569;">Max Price (₹/unit)</label>
                <input type="number" step="0.5" name="maxPrice" class="form-control" placeholder="e.g. 20" value="<%= maxPrice != null ? maxPrice : "" %>">
            </div>
            <div style="display:flex; align-items:flex-end;">
                <button type="submit" class="btn btn-primary" style="height: 42px;">Filter Stations</button>
            </div>
        </form>
    </div>

    <!-- Results Count -->
    <div style="margin-bottom: 16px; color: #475569; font-weight: 500;">
        Showing <%= stations != null ? stations.size() : 0 %> approved station(s)
    </div>

    <!-- Stations Grid -->
    <% if (stations == null || stations.isEmpty()) { %>
        <div class="card" style="text-align: center; padding: 40px; color: #64748b;">
            <h3>No charging stations found matching your criteria.</h3>
            <p style="margin: 10px 0 20px;">Try adjusting your search filters or clearing the price threshold.</p>
            <a href="<%= ctx %>/search-stations" class="btn btn-outline">Clear All Filters</a>
        </div>
    <% } else { %>
        <div class="grid-3">
            <% for (Station s : stations) { %>
                <div class="station-card">
                    <div>
                        <div style="display:flex; justify-content:space-between; align-items:start; margin-bottom: 6px;">
                            <h3><%= s.getName() %></h3>
                            <span class="badge badge-approved">VERIFIED</span>
                        </div>
                        <p style="color: #64748b; font-size: 0.9rem; margin-bottom: 8px;">
                            📍 <%= s.getAddress() %>, <strong><%= s.getCity() %></strong> (<%= s.getPincode() %>)
                        </p>
                        <div style="margin-bottom: 12px; display:flex; flex-wrap:wrap; gap: 5px;">
                            <span style="font-size:0.8rem; background:#f1f5f9; padding: 3px 8px; border-radius:4px;">🔌 <%= s.getChargerTypes() %></span>
                            <span style="font-size:0.8rem; background:#ecfdf5; color:#065f46; padding: 3px 8px; border-radius:4px;">⚡ <%= s.getPowerRating() %></span>
                        </div>
                        <div class="price">
                            ₹<%= s.getPricePerUnit() %> <span style="font-size:0.85rem; font-weight:normal; color:#64748b;">/ unit (kWh)</span>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-top: 8px;">
                            <span class="badge <%= s.getAvailableSlotsCount() > 0 ? "badge-available" : "badge-occupied" %>">
                                <%= s.getAvailableSlotsCount() %> of <%= s.getTotalSlots() %> Slots Free
                            </span>
                            <span class="rating">
                                ★ <%= s.getAverageRating() > 0 ? s.getAverageRating() : "New" %>
                                <span style="color:#64748b; font-size:0.75rem;">(<%= s.getTotalReviews() %>)</span>
                            </span>
                        </div>
                    </div>

                    <div style="margin-top: 20px; display:flex; gap: 8px;">
                        <a href="<%= ctx %>/search-stations?action=details&id=<%= s.getId() %>" class="btn btn-outline btn-block btn-sm">View Details</a>
                        <a href="<%= ctx %>/booking?stationId=<%= s.getId() %>" class="btn btn-primary btn-block btn-sm">Book Slot</a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<jsp:include page="/includes/footer.jsp" />
