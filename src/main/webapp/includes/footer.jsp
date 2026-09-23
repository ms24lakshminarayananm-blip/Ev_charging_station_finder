<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String footerCtx = request.getContextPath();
%>
<footer>
    <div class="container">
        <p><strong>EV Charging Station Finder System</strong> &bull; 3rd Year CSE Software Engineering Project</p>
        <p style="margin-top: 6px; font-size: 0.8rem; opacity: 0.75;">Local Windows Tomcat 9 & MySQL Deployment &bull; Built with Servlet, JSP, JDBC</p>
    </div>
</footer>
<script src="<%= footerCtx %>/js/main.js"></script>
</body>
</html>
