<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OE - Administration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>

<!-- Top Bar - Similar to Customer -->
<div class="admin-top-bar">
    <span>Online Entertainment - Admin</span>
    <div class="admin-theme-toggle">
        <button id="adminThemeToggle" type="button">🌙 Dark</button>
    </div>
</div>

<!-- Menu Bar - Similar to Customer -->
<div class="admin-menu">
    <a href="${pageContext.request.contextPath}/admin/home">Admin Dashboard</a>
    <a href="${pageContext.request.contextPath}/home">Customer Home</a>
    <a href="${pageContext.request.contextPath}/admin/videos">Videos</a>
    <a href="${pageContext.request.contextPath}/admin/users">Users</a>
    <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
    <a href="${pageContext.request.contextPath}/account/logoff">Logoff</a>
</div>

<main>
    <jsp:include page="${view}" />
</main>
</body>
<script>
    (function(){
        var t = localStorage.getItem('adminTheme');
        if(!t){ t = 'light'; }
        document.body.setAttribute('data-theme', t);
        var btn = document.getElementById('adminThemeToggle');
        if(btn){
            btn.textContent = t === 'dark' ? '☀️ Light' : '🌙 Dark';
            btn.addEventListener('click', function(){
                var nt = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
                document.body.setAttribute('data-theme', nt);
                localStorage.setItem('adminTheme', nt);
                btn.textContent = nt === 'dark' ? '☀️ Light' : '🌙 Dark';
            });
        }
    })();
</script>
</html>
