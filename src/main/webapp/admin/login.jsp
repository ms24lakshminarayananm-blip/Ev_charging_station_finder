<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 460px; margin-top: 40px; margin-bottom: 60px;">
    <div class="card" style="box-shadow: var(--shadow-lg); border-top: 4px solid #ef4444;">
        <div style="text-align: center; margin-bottom: 24px;">
            <div style="font-size: 2.2rem; color: #ef4444; margin-bottom: 8px;">🛡️</div>
            <h2>System Administrator</h2>
            <p style="color: #64748b; font-size: 0.9rem;">Administrative control and station approval panel</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-info">Logged out from Admin portal.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin/login" method="POST">
            <div class="form-group">
                <label for="username">Admin Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="admin" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="background:#0f172a; padding: 12px; margin-top: 10px;">
                Enter Admin Console
            </button>
        </form>

        <div style="margin-top: 20px; padding: 12px; background: #fef2f2; border-radius: 6px; font-size: 0.85rem; border: 1px dashed #fca5a5;">
            <strong>Demo Admin Account:</strong><br>
            Username: <code>admin</code> | Password: <code>admin123</code><br>
            <button type="button" class="btn btn-sm btn-outline" style="margin-top: 6px;" onclick="document.getElementById('username').value='admin'; document.getElementById('password').value='admin123';">
                Auto-fill Demo Credentials
            </button>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
