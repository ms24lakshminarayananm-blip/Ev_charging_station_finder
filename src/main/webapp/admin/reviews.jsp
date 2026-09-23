<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.evcharging.model.Review" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px;">
        <div>
            <h2>Customer Reviews & Content Moderation</h2>
            <p style="color: #64748b;">Review feedback and remove inappropriate content or spam ratings</p>
        </div>
        <a href="<%= ctx %>/admin/dashboard" class="btn btn-outline">&larr; Admin Dashboard</a>
    </div>

    <% if ("true".equals(request.getParameter("deleted"))) { %>
        <div class="alert alert-success">Review has been permanently removed from the system.</div>
    <% } %>

    <div class="card">
        <% if (reviews == null || reviews.isEmpty()) { %>
            <p style="text-align:center; padding:30px; color:#64748b;">No customer reviews submitted yet.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Review ID</th>
                            <th>Station Name</th>
                            <th>User / Driver</th>
                            <th>Rating</th>
                            <th>Review Content</th>
                            <th>Date</th>
                            <th>Moderation Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Review r : reviews) { %>
                            <tr>
                                <td>#<%= r.getId() %></td>
                                <td>
                                    <strong><%= r.getStationName() %></strong><br>
                                    <small style="color:#64748b;"><%= r.getStationCity() %></small>
                                </td>
                                <td><strong><%= r.getUserName() %></strong></td>
                                <td><span class="rating">★ <%= r.getRating() %> / 5</span></td>
                                <td style="max-width:320px;"><%= r.getReviewText() %></td>
                                <td><small><%= r.getCreatedAt() %></small></td>
                                <td>
                                    <form action="<%= ctx %>/admin/manage-reviews" method="POST" style="margin:0;" onsubmit="return confirmDeleteReview();">
                                        <input type="hidden" name="id" value="<%= r.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            Delete Review
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
