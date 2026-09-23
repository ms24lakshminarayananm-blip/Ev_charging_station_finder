<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 480px; margin-top: 40px; margin-bottom: 60px;">
    <div class="card" style="box-shadow: var(--shadow-lg);">
        <div style="text-align: center; margin-bottom: 24px;">
            <div style="font-size: 2.2rem; color: var(--primary); margin-bottom: 8px;">⚡</div>
            <h2>EV User Login</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Sign in to search stations, reserve slots, and charge</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% if ("true".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success">Registration successful! Please login with your credentials.</div>
        <% } %>

        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-info">You have been logged out safely.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="POST">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="user@gmail.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="padding: 12px; margin-top: 10px;">Sign In</button>
        </form>

        <div style="margin-top: 20px; padding: 12px; background: #f8fafc; border-radius: 6px; font-size: 0.85rem; border: 1px dashed #cbd5e1;">
            <strong>Demo User Account:</strong><br>
            Email: <code>user@gmail.com</code> | Password: <code>user123</code><br>
            <button type="button" class="btn btn-sm btn-outline" style="margin-top: 6px;" onclick="document.getElementById('email').value='user@gmail.com'; document.getElementById('password').value='user123';">
                Auto-fill Demo Credentials
            </button>
        </div>

        <div style="text-align: center; margin-top: 20px; font-size: 0.9rem;">
            Don't have an account? <a href="<%= request.getContextPath() %>/register.jsp" style="color: var(--primary); font-weight: 600;">Register here</a>
        </div>
        <hr style="margin: 20px 0; border: none; border-top: 1px solid #e2e8f0;">
        <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
            <a href="<%= request.getContextPath() %>/owner/login.jsp" style="color: #64748b;">Station Owner Login &rarr;</a>
            <a href="<%= request.getContextPath() %>/admin/login.jsp" style="color: #64748b;">Admin Login &rarr;</a>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
