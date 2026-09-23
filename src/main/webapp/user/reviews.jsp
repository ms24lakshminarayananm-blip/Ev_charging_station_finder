<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Station" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    Station station = (Station) request.getAttribute("station");
    List<Station> stations = (List<Station>) request.getAttribute("stations");
    String ctx = request.getContextPath();
%>

<div class="container" style="max-width: 600px; margin-top: 30px; margin-bottom: 60px;">
    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="margin-bottom: 20px;">
            <h2>Rate & Review EV Station</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Help the EV community by sharing your charging experience</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="<%= ctx %>/review" method="POST">
            <div class="form-group">
                <label for="stationId">Select Station *</label>
                <% if (station != null) { %>
                    <input type="hidden" name="stationId" value="<%= station.getId() %>">
                    <input type="text" class="form-control" value="<%= station.getName() %> (<%= station.getCity() %>)" readonly style="background:#f1f5f9;">
                <% } else { %>
                    <select id="stationId" name="stationId" class="form-control" required>
                        <option value="">-- Choose a charging station --</option>
                        <% if (stations != null) {
                            for (Station s : stations) {
                        %>
                            <option value="<%= s.getId() %>"><%= s.getName() %> - <%= s.getCity() %></option>
                        <%  }
                        } %>
                    </select>
                <% } %>
            </div>

            <div class="form-group">
                <label for="rating">Rating (1 to 5 Stars) *</label>
                <select id="rating" name="rating" class="form-control" required>
                    <option value="5" selected>★★★★★ - 5 Stars (Excellent charging speed & facility)</option>
                    <option value="4">★★★★☆ - 4 Stars (Good service & clean area)</option>
                    <option value="3">★★★☆☆ - 3 Stars (Average experience / moderate speed)</option>
                    <option value="2">★★☆☆☆ - 2 Stars (Slow charge or crowded)</option>
                    <option value="1">★☆☆☆☆ - 1 Star (Charger issue / bad experience)</option>
                </select>
            </div>

            <div class="form-group">
                <label for="reviewText">Your Review *</label>
                <textarea id="reviewText" name="reviewText" class="form-control" rows="4" placeholder="Write about charging speed, amenities, app connectivity, ease of parking, etc." required></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="padding: 12px; font-weight:700;">
                Submit Rating & Review
            </button>
        </form>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
