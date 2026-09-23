<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 520px; margin-top: 30px; margin-bottom: 60px;">
    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 24px;">
            <div style="font-size: 2.2rem; color: var(--secondary); margin-bottom: 8px;">🔌</div>
            <h2>Station Owner Registration</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Register your business to list EV charging stations</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/owner/register" method="POST">
            <div class="form-group">
                <label for="name">Contact Person / Full Name *</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Jane Doe" required>
            </div>
            <div class="form-group">
                <label for="email">Business Email *</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="owner@company.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required minlength="4">
            </div>
            <div class="form-group">
                <label for="phone">Phone Number *</label>
                <input type="tel" id="phone" name="phone" class="form-control" placeholder="9876543210" required>
            </div>
            <div class="form-group">
                <label for="businessName">Company / Business Name *</label>
                <input type="text" id="businessName" name="businessName" class="form-control" placeholder="VoltGrid Infrastructure Ltd." required>
            </div>
            <div class="form-group">
                <label for="address">Registered Business Address</label>
                <textarea id="address" name="address" class="form-control" rows="2" placeholder="Corporate office or business address"></textarea>
            </div>

            <button type="submit" class="btn btn-secondary btn-block" style="padding: 12px; margin-top: 10px;">
                Register Business
            </button>
        </form>

        <div style="text-align: center; margin-top: 20px; font-size: 0.9rem;">
            Already registered? <a href="<%= request.getContextPath() %>/owner/login.jsp" style="color: var(--secondary); font-weight: 600;">Login here</a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
