<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="com.evcharging.model.ChargingSlot" %>
<%@ page import="com.evcharging.model.Review" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    Station station = (Station) request.getAttribute("station");
    List<ChargingSlot> slots = (List<ChargingSlot>) request.getAttribute("slots");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double avgRating = (Double) request.getAttribute("avgRating");
    String ctx = request.getContextPath();

    if (station == null) {
        response.sendRedirect(ctx + "/search-stations");
        return;
    }
%>

<div class="container">
    <div style="margin-bottom: 20px;">
        <a href="<%= ctx %>/search-stations" style="color: #64748b; text-decoration: none; font-size: 0.9rem;">&larr; Back to Stations</a>
    </div>

    <% if ("true".equals(request.getParameter("reviewed"))) { %>
        <div class="alert alert-success">Thank you! Your rating and review have been recorded.</div>
    <% } %>

    <div class="grid-2" style="grid-template-columns: 2fr 1fr; align-items: start;">
        <!-- Left: Station Info & Slots -->
        <div>
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:start;">
                    <div>
                        <h2><%= station.getName() %></h2>
                        <p style="color: #64748b; font-size: 0.95rem; margin-top: 4px;">
                            📍 <%= station.getAddress() %>, <%= station.getCity() %>, <%= station.getState() %> - <%= station.getPincode() %>
                        </p>
                    </div>
                    <span class="badge badge-approved" style="font-size:0.85rem;"><%= station.getApprovalStatus() %></span>
                </div>

                <hr style="margin: 16px 0; border: none; border-top: 1px solid #e2e8f0;">

                <div class="grid-3" style="font-size: 0.9rem; margin-bottom: 16px;">
                    <div>
                        <span style="color: #64748b; display:block;">Operator / Owner:</span>
                        <strong><%= station.getOwnerBusinessName() != null ? station.getOwnerBusinessName() : station.getOwnerName() %></strong>
                    </div>
                    <div>
                        <span style="color: #64748b; display:block;">Supported Connectors:</span>
                        <strong><%= station.getChargerTypes() %></strong>
                    </div>
                    <div>
                        <span style="color: #64748b; display:block;">Power Output:</span>
                        <strong><%= station.getPowerRating() %></strong>
                    </div>
                </div>

                <div style="background:#f8fafc; padding: 14px; border-radius: 6px; margin-bottom: 16px;">
                    <strong style="color:#0f172a; font-size:0.9rem;">Station Amenities:</strong>
                    <p style="color: #475569; font-size:0.9rem; margin-top: 4px;">
                        <%= (station.getAmenities() != null && !station.getAmenities().isEmpty()) ? station.getAmenities() : "Parking, Restrooms, 24/7 Access" %>
                    </p>
                </div>

                <div style="display:flex; justify-content:space-between; align-items:center; background:#ecfdf5; padding: 16px; border-radius: 8px; border:1px solid #a7f3d0;">
                    <div>
                        <span style="color:#065f46; font-size:0.85rem; font-weight:600; text-transform:uppercase;">Charging Rate</span>
                        <div style="font-size: 1.6rem; font-weight: 800; color: #065f46;">
                            ₹<%= station.getPricePerUnit() %> <span style="font-size:0.85rem; font-weight:normal;">/ unit</span>
                        </div>
                    </div>
                    <a href="<%= ctx %>/booking?stationId=<%= station.getId() %>" class="btn btn-primary" style="padding: 12px 24px; font-size: 1.05rem;">
                        ⚡ Book Charging Slot
                    </a>
                </div>
            </div>

            <!-- Live Slots Status -->
            <div class="card">
                <h3>Charging Slots Availability</h3>
                <p style="color:#64748b; font-size:0.85rem; margin-bottom: 16px;">Live availability of physical charging bays at this station</p>

                <% if (slots == null || slots.isEmpty()) { %>
                    <p style="color:#64748b;">No slot information registered for this station.</p>
                <% } else { %>
                    <div class="grid-2">
                        <% for (ChargingSlot slot : slots) { %>
                            <div style="border: 1px solid #e2e8f0; border-radius: 6px; padding: 14px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="font-weight:700; color:#0f172a;"><%= slot.getSlotNumber() %></div>
                                    <div style="font-size:0.85rem; color:#64748b;"><%= slot.getChargerType() %> &bull; <%= slot.getPowerOutput() %></div>
                                </div>
                                <div>
                                    <% if ("AVAILABLE".equalsIgnoreCase(slot.getStatus())) { %>
                                        <span class="badge badge-available">AVAILABLE</span>
                                    <% } else if ("OCCUPIED".equalsIgnoreCase(slot.getStatus())) { %>
                                        <span class="badge badge-occupied">IN USE</span>
                                    <% } else { %>
                                        <span class="badge badge-maintenance">MAINTENANCE</span>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- Customer Reviews -->
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
                    <h3>Driver Ratings & Reviews</h3>
                    <a href="<%= ctx %>/review?stationId=<%= station.getId() %>" class="btn btn-sm btn-outline">Write a Review</a>
                </div>

                <% if (reviews == null || reviews.isEmpty()) { %>
                    <p style="color:#64748b; font-size:0.9rem;">No reviews yet. Be the first to share your experience!</p>
                <% } else { %>
                    <% for (Review r : reviews) { %>
                        <div style="padding: 12px 0; border-bottom: 1px solid #e2e8f0;">
                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <strong style="font-size:0.95rem; color:#0f172a;"><%= r.getUserName() %></strong>
                                <span class="rating">★ <%= r.getRating() %> / 5</span>
                            </div>
                            <p style="color:#475569; font-size:0.9rem; margin-top: 6px;"><%= r.getReviewText() %></p>
                            <span style="color:#94a3b8; font-size:0.75rem;"><%= r.getCreatedAt() %></span>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>

        <!-- Right: Action Sidebar -->
        <div>
            <div class="card" style="position: sticky; top: 80px;">
                <h3 style="margin-bottom: 12px;">Quick Reservation</h3>
                <p style="color: #64748b; font-size: 0.9rem; margin-bottom: 16px;">
                    Lock your charging time slot in advance to avoid waiting in highway lines.
                </p>
                <div style="margin-bottom: 16px; font-size: 0.9rem;">
                    <div style="display:flex; justify-content:space-between; padding: 6px 0;">
                        <span style="color: #64748b;">Rate:</span>
                        <strong>₹<%= station.getPricePerUnit() %> / unit</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; padding: 6px 0;">
                        <span style="color: #64748b;">Available Bays:</span>
                        <strong style="color: #059669;"><%= station.getAvailableSlotsCount() %> Free</strong>
                    </div>
                    <div style="display:flex; justify-content:space-between; padding: 6px 0;">
                        <span style="color: #64748b;">Rating:</span>
                        <strong style="color: #f59e0b;">★ <%= avgRating != null && avgRating > 0 ? avgRating : "5.0" %></strong>
                    </div>
                </div>

                <a href="<%= ctx %>/booking?stationId=<%= station.getId() %>" class="btn btn-primary btn-block" style="padding: 12px;">
                    Proceed to Slot Booking &rarr;
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
