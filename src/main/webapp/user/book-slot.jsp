<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="com.evcharging.model.ChargingSlot" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    Station station = (Station) request.getAttribute("station");
    List<ChargingSlot> slots = (List<ChargingSlot>) request.getAttribute("slots");
    Boolean slotUnavailable = (Boolean) request.getAttribute("slotUnavailable");
    String desiredDate = (String) request.getAttribute("desiredDate");
    String desiredTime = (String) request.getAttribute("desiredTime");
    Integer desiredStationId = (Integer) request.getAttribute("desiredStationId");
    String ctx = request.getContextPath();

    if (station == null) {
        response.sendRedirect(ctx + "/search-stations");
        return;
    }
%>

<div class="container" style="max-width: 760px; margin-top: 30px; margin-bottom: 60px;">
    <div style="margin-bottom: 20px;">
        <a href="<%= ctx %>/search-stations?action=details&id=<%= station.getId() %>" style="color: #64748b; text-decoration: none; font-size: 0.9rem;">
            &larr; Back to <%= station.getName() %>
        </a>
    </div>

    <!-- Unavailable Slot & Waiting List Promotion -->
    <% if (Boolean.TRUE.equals(slotUnavailable)) { %>
        <div class="alert alert-error" style="display:block;">
            <div style="font-weight:700; font-size:1.1rem; margin-bottom: 4px;">⚠️ Slot Unavailable!</div>
            <p>The slot you selected is currently unavailable or booked for <%= desiredDate %> at <%= desiredTime %>.</p>
        </div>

        <div class="card" style="border: 2px dashed #f59e0b; background: #fffbeb;">
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                <div>
                    <h3 style="color:#b45309; margin-bottom:4px;">Join Waiting List for this Slot</h3>
                    <p style="color:#78350f; font-size:0.9rem;">
                        Get queued automatically! When a slot opens for <%= desiredDate %> at <%= desiredTime %>, your spot is priority flagged.
                    </p>
                </div>
                <form action="<%= ctx %>/waiting-list" method="POST">
                    <input type="hidden" name="stationId" value="<%= station.getId() %>">
                    <input type="hidden" name="desiredDate" value="<%= desiredDate %>">
                    <input type="hidden" name="desiredTime" value="<%= desiredTime %>">
                    <button type="submit" class="btn btn-warning" style="background:#f59e0b; color:#fff; font-weight:700;">
                        📋 Join Waiting List
                    </button>
                </form>
            </div>
        </div>
    <% } %>

    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="margin-bottom: 20px;">
            <h2>Book Charging Slot</h2>
            <p style="color: #64748b;">
                Reserve a fast charging bay at <strong><%= station.getName() %></strong> (<%= station.getCity() %>)
            </p>
        </div>

        <div style="background: #f8fafc; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; display:flex; justify-content:space-between; align-items:center;">
            <div>
                <span style="font-size:0.85rem; color:#64748b;">Base Rate:</span>
                <div style="font-weight:700; color:var(--primary); font-size:1.2rem;">₹<%= station.getPricePerUnit() %> / unit</div>
            </div>
            <div style="text-align:right;">
                <span style="font-size:0.85rem; color:#64748b;">Supported Connectors:</span>
                <div style="font-weight:600; color:#334155; font-size:0.9rem;"><%= station.getChargerTypes() %></div>
            </div>
        </div>

        <form action="<%= ctx %>/booking" method="POST">
            <input type="hidden" name="stationId" value="<%= station.getId() %>">

            <div class="grid-2">
                <div class="form-group">
                    <label for="bookingDate">Date of Charging *</label>
                    <input type="date" id="bookingDate" name="bookingDate" class="form-control" value="<%= desiredDate != null ? desiredDate : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="startTime">Preferred Start Time *</label>
                    <select id="startTime" name="startTime" class="form-control" required>
                        <option value="08:00 AM">08:00 AM</option>
                        <option value="09:00 AM">09:00 AM</option>
                        <option value="10:00 AM" selected>10:00 AM</option>
                        <option value="11:00 AM">11:00 AM</option>
                        <option value="12:00 PM">12:00 PM</option>
                        <option value="01:00 PM">01:00 PM</option>
                        <option value="02:00 PM">02:00 PM</option>
                        <option value="03:00 PM">03:00 PM</option>
                        <option value="04:00 PM">04:00 PM</option>
                        <option value="05:00 PM">05:00 PM</option>
                        <option value="06:00 PM">06:00 PM</option>
                        <option value="07:00 PM">07:00 PM</option>
                        <option value="08:00 PM">08:00 PM</option>
                        <option value="09:00 PM">09:00 PM</option>
                    </select>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="slotId">Select Charging Slot / Bay *</label>
                    <select id="slotId" name="slotId" class="form-control" required>
                        <% if (slots != null) {
                            for (ChargingSlot s : slots) {
                        %>
                            <option value="<%= s.getId() %>" <%= !"AVAILABLE".equalsIgnoreCase(s.getStatus()) ? "style='color:#991b1b;'" : "" %>>
                                <%= s.getSlotNumber() %> (<%= s.getChargerType() %> - <%= s.getPowerOutput() %>) [<%= s.getStatus() %>]
                            </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="totalHours">Estimated Charging Duration</label>
                    <select id="totalHours" name="totalHours" class="form-control">
                        <option value="0.5">30 Minutes (Quick Top-up)</option>
                        <option value="1.0" selected>1 Hour (Standard Charge)</option>
                        <option value="2.0">2 Hours (Deep Charge)</option>
                        <option value="3.0">3 Hours (Full Cycle)</option>
                    </select>
                </div>
            </div>

            <!-- Price estimation box -->
            <div style="background:#ecfdf5; border:1px solid #a7f3d0; padding:16px; border-radius:6px; margin: 20px 0; display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <span style="color:#065f46; font-size:0.9rem; font-weight:600;">Estimated Subtotal:</span>
                    <span id="pricePerUnitRate" data-rate="<%= station.getPricePerUnit() %>" style="display:none;"></span>
                    <div style="font-size:0.8rem; color:#047857;">Calculated based on duration & station rate. Coupons applied at next step!</div>
                </div>
                <div id="calculatedBookingTotal" style="font-size:1.6rem; font-weight:800; color:#065f46;">
                    ₹<%= station.getPricePerUnit() %>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="padding: 14px; font-size: 1.05rem;">
                Proceed to Payment & Review Coupons &rarr;
            </button>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
