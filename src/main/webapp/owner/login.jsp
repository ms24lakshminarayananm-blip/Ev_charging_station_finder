<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 480px; margin-top: 40px; margin-bottom: 60px;">
    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 24px;">
            <div style="font-size: 2.2rem; color: var(--secondary); margin-bottom: 8px;">🔌</div>
            <h2>Station Owner Portal</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Manage your charging stations, set prices, and monitor bookings</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% if ("true".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success">Owner registered successfully! Please login with your email.</div>
        <% } %>

        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-info">Logged out from Station Owner portal.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/owner/login" method="POST">
            <div class="form-group">
                <label for="email">Owner Email</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="owner@gmail.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-secondary btn-block" style="padding: 12px; margin-top: 10px;">
                Sign In to Owner Portal
            </button>
        </form>

        <div style="margin-top: 20px; padding: 12px; background: #f8fafc; border-radius: 6px; font-size: 0.85rem; border: 1px dashed #cbd5e1;">
            <strong>Demo Owner Account:</strong><br>
            Email: <code>owner@gmail.com</code> | Password: <code>owner123</code><br>
            <button type="button" class="btn btn-sm btn-outline" style="margin-top: 6px;" onclick="document.getElementById('email').value='owner@gmail.com'; document.getElementById('password').value='owner123';">
                Auto-fill Demo Credentials
            </button>
        </div>

        <div style="text-align: center; margin-top: 20px; font-size: 0.9rem;">
            New station partner? <a href="<%= request.getContextPath() %>/owner/register.jsp" style="color: var(--secondary); font-weight: 600;">Register as Station Owner</a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
