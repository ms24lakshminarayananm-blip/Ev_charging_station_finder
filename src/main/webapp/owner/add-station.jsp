<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.StationOwner" %>
<jsp:include page="/includes/header.jsp" />

<%
    StationOwner owner = (StationOwner) session.getAttribute("owner");
    if (owner == null) {
        response.sendRedirect(request.getContextPath() + "/owner/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>

<div class="container" style="max-width: 750px; margin-top: 30px; margin-bottom: 60px;">
    <div style="margin-bottom: 20px;">
        <a href="<%= ctx %>/owner/dashboard" style="color: #64748b; text-decoration: none; font-size: 0.9rem;">
            &larr; Back to Owner Dashboard
        </a>
    </div>

    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="margin-bottom: 20px; border-bottom: 1px solid #e2e8f0; padding-bottom: 16px;">
            <h2>Register New Charging Station</h2>
            <p style="color: #64748b; font-size: 0.9rem;">
                Newly created stations will have status <strong>PENDING</strong> until approved by the System Administrator.
            </p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="<%= ctx %>/owner/add-station" method="POST">
            <div class="form-group">
                <label for="name">Station Name *</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="e.g. SparkVolt Supercharge Hub" required>
            </div>

            <div class="form-group">
                <label for="address">Street Address / Landmark *</label>
                <input type="text" id="address" name="address" class="form-control" placeholder="Opposite Metro Station, Outer Ring Road" required>
            </div>

            <div class="grid-3">
                <div class="form-group">
                    <label for="city">City *</label>
                    <input type="text" id="city" name="city" class="form-control" placeholder="e.g. Bengaluru" required>
                </div>
                <div class="form-group">
                    <label for="state">State *</label>
                    <input type="text" id="state" name="state" class="form-control" placeholder="e.g. Karnataka" required>
                </div>
                <div class="form-group">
                    <label for="pincode">Pincode *</label>
                    <input type="text" id="pincode" name="pincode" class="form-control" placeholder="560100" required>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="chargerTypes">Supported Connectors *</label>
                    <input type="text" id="chargerTypes" name="chargerTypes" class="form-control" value="CCS2 Fast DC, Type 2 AC" placeholder="CCS2, Type 2, CHAdeMO" required>
                </div>
                <div class="form-group">
                    <label for="powerRating">Power Rating *</label>
                    <input type="text" id="powerRating" name="powerRating" class="form-control" value="60 kW Fast DC" placeholder="e.g. 50 kW, 120 kW" required>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="pricePerUnit">Charging Price (₹ per Unit / kWh) *</label>
                    <input type="number" step="0.5" id="pricePerUnit" name="pricePerUnit" class="form-control" placeholder="18.50" value="18.00" required>
                </div>
                <div class="form-group">
                    <label for="totalSlots">Total Physical Charging Slots *</label>
                    <input type="number" id="totalSlots" name="totalSlots" class="form-control" min="1" max="20" value="4" required>
                </div>
            </div>

            <div class="form-group">
                <label for="amenities">Station Amenities & Highlights</label>
                <input type="text" id="amenities" name="amenities" class="form-control" placeholder="Cafe, Free WiFi, Clean Restroom, 24/7 Security, Air Pump" value="Cafe, Restroom, WiFi, Parking">
            </div>

            <div style="background:#eff6ff; border:1px solid #bfdbfe; padding:12px 16px; border-radius:6px; margin: 20px 0; font-size:0.85rem; color:#1e40af;">
                ℹ️ <strong>Approval Workflow:</strong> Once submitted, default bays/slots will be initialized automatically. The station will be submitted for verification and will become publicly visible as soon as the Admin approves it.
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="padding: 12px; font-weight:700;">
                Submit Station for Admin Approval
            </button>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
