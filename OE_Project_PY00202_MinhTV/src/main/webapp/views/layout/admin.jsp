<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OE - Administration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>

<c:if test="${not empty param.lang}">
    <c:set var="siteLang" value="${param.lang}" scope="session" />
</c:if>
<fmt:setLocale value="${sessionScope.siteLang != null ? sessionScope.siteLang : 'vi'}" scope="request" />
<fmt:setBundle basename="messages" scope="request" />

<!-- Top Bar - Similar to Customer -->
<div class="admin-top-bar">
    <span><fmt:message key="app.title"/> - Admin</span>
    <div class="admin-theme-toggle">
        <button id="adminThemeToggle" type="button">🌙 Dark</button>
    </div>
    <div class="lang-switch">
        <a href="#" data-lang="en">EN</a> | <a href="#" data-lang="vi">VI</a>
    </div>
</div>

<!-- Menu Bar - Similar to Customer -->
<div class="admin-menu">
    <a href="${pageContext.request.contextPath}/admin/home"><fmt:message key="menu.adminDashboard"/></a>
    <a href="${pageContext.request.contextPath}/home"><fmt:message key="admin.menu.customerHome"/></a>
    <a href="${pageContext.request.contextPath}/admin/videos"><fmt:message key="admin.menu.videos"/></a>
    <a href="${pageContext.request.contextPath}/admin/users"><fmt:message key="admin.menu.users"/></a>
    <a href="${pageContext.request.contextPath}/admin/reports"><fmt:message key="admin.menu.reports"/></a>
    <a href="${pageContext.request.contextPath}/account/logoff"><fmt:message key="admin.menu.logoff"/></a>
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
        var ls = document.querySelector('.lang-switch');
        if(ls){
            ls.addEventListener('click', function(e){
                var a = e.target.closest('a[data-lang]');
                if(!a) return;
                e.preventDefault();
                var lang = a.getAttribute('data-lang');
                var url = new URL(window.location.href);
                url.searchParams.set('lang', lang);
                window.location.assign(url.toString());
            });
        }
    })();
</script>
</html>
