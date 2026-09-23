<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 520px; margin-top: 30px; margin-bottom: 60px;">
    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 24px;">
            <div style="font-size: 2.2rem; color: var(--primary); margin-bottom: 8px;">⚡</div>
            <h2>Create EV User Account</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Register to locate stations, book slots, and make payments</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="POST">
            <div class="form-group">
                <label for="name">Full Name *</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="John Doe" required>
            </div>
            <div class="form-group">
                <label for="email">Email Address *</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="john@example.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Create a strong password" required minlength="4">
            </div>
            <div class="form-group">
                <label for="phone">Phone Number *</label>
                <input type="tel" id="phone" name="phone" class="form-control" placeholder="9876543210" required>
            </div>
            <div style="display: flex; gap: 12px;">
                <div class="form-group" style="flex: 1;">
                    <label for="vehicleNumber">Vehicle Number</label>
                    <input type="text" id="vehicleNumber" name="vehicleNumber" class="form-control" placeholder="KA-01-EV-2024">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="vehicleModel">Vehicle Model</label>
                    <input type="text" id="vehicleModel" name="vehicleModel" class="form-control" placeholder="Tata Nexon EV">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="padding: 12px; margin-top: 10px;">Register Account</button>
        </form>

        <div style="text-align: center; margin-top: 20px; font-size: 0.9rem;">
            Already have an account? <a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--primary); font-weight: 600;">Sign in here</a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
