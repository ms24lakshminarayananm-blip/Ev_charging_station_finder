<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="com.evcharging.model.ChargingSlot" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    Map<Integer, List<ChargingSlot>> stationSlotsMap = (Map<Integer, List<ChargingSlot>>) request.getAttribute("stationSlotsMap");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
        <div>
            <h2>Live Bay & Slot Status Monitor</h2>
            <p style="color: #64748b;">Monitor real-time bay occupancy and toggle maintenance status</p>
        </div>
        <a href="<%= ctx %>/owner/dashboard" class="btn btn-outline">&larr; Dashboard</a>
    </div>

    <% if ("true".equals(request.getParameter("updated"))) { %>
        <div class="alert alert-success">Slot status successfully updated!</div>
    <% } %>

    <% if (stations == null || stations.isEmpty()) { %>
        <div class="card" style="text-align:center; padding: 40px; color:#64748b;">
            <p>No stations registered yet.</p>
            <a href="<%= ctx %>/owner/add-station" class="btn btn-primary" style="margin-top:10px;">Add Station</a>
        </div>
    <% } else { %>
        <% for (Station s : stations) {
            List<ChargingSlot> slots = (stationSlotsMap != null) ? stationSlotsMap.get(s.getId()) : null;
        %>
            <div class="card" style="margin-bottom: 24px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px; border-bottom: 1px solid #e2e8f0; padding-bottom: 12px;">
                    <div>
                        <h3 style="color:var(--dark);"><%= s.getName() %></h3>
                        <p style="color:#64748b; font-size:0.85rem;">📍 <%= s.getAddress() %>, <%= s.getCity() %> &bull; Rate: ₹<%= s.getPricePerUnit() %>/unit</p>
                    </div>
                    <span class="badge <%= "APPROVED".equalsIgnoreCase(s.getApprovalStatus()) ? "badge-approved" : "badge-pending" %>">
                        <%= s.getApprovalStatus() %>
                    </span>
                </div>

                <% if (slots == null || slots.isEmpty()) { %>
                    <p style="color:#64748b; font-size:0.9rem;">No slots initialized for this station.</p>
                <% } else { %>
                    <div class="grid-3">
                        <% for (ChargingSlot slot : slots) { %>
                            <div style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; background:#f8fafc;">
                                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 8px;">
                                    <strong style="font-size:1.05rem; color:#0f172a;"><%= slot.getSlotNumber() %></strong>
                                    <% if ("AVAILABLE".equalsIgnoreCase(slot.getStatus())) { %>
                                        <span class="badge badge-available">AVAILABLE</span>
                                    <% } else if ("OCCUPIED".equalsIgnoreCase(slot.getStatus())) { %>
                                        <span class="badge badge-occupied">OCCUPIED</span>
                                    <% } else { %>
                                        <span class="badge badge-maintenance">MAINTENANCE</span>
                                    <% } %>
                                </div>
                                <div style="font-size:0.85rem; color:#64748b; margin-bottom: 14px;">
                                    Connector: <%= slot.getChargerType() %><br>
                                    Power: <%= slot.getPowerOutput() %>
                                </div>

                                <!-- Slot status toggle form -->
                                <form action="<%= ctx %>/owner/update-station" method="POST">
                                    <input type="hidden" name="action" value="updateSlot">
                                    <input type="hidden" name="slotId" value="<%= slot.getId() %>">
                                    <label style="font-size:0.8rem; font-weight:600; color:#475569; display:block; margin-bottom:4px;">Change Live Status:</label>
                                    <div style="display:flex; gap: 6px;">
                                        <select name="slotStatus" class="form-control" style="padding: 6px 10px; font-size:0.85rem;">
                                            <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(slot.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
                                            <option value="OCCUPIED" <%= "OCCUPIED".equalsIgnoreCase(slot.getStatus()) ? "selected" : "" %>>OCCUPIED</option>
                                            <option value="MAINTENANCE" <%= "MAINTENANCE".equalsIgnoreCase(slot.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-outline" style="white-space:nowrap;">Update</button>
                                    </div>
                                </form>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    <% } %>
</div>

<jsp:include page="/includes/footer.jsp" />
