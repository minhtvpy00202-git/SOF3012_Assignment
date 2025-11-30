<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OE Online Entertainment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/youtube-style.css">
</head>
<body data-theme="light">

<div class="top-bar">
    <span>OE Online Entertainment</span>
    <div class="theme-toggle">
        <button id="themeToggle" type="button">🌙 Dark</button>
    </div>
</div>

<div class="menu">
    <a href="${pageContext.request.contextPath}/home">Home Page</a>
    <a href="${pageContext.request.contextPath}/my-favorites">My Favorites</a>

    

    <!-- Khu My Account (tùy theo đã đăng nhập hay chưa) -->
    <c:choose>
        <c:when test="${not empty sessionScope.currentUser}">
            <!-- đã login -->
            <c:if test="${sessionScope.currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/home">Admin Dashboard</a>
            </c:if>
            <span class="dropdown">
                <span class="dropdown-toggle">My Account</span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/account/edit-profile">Edit Profile</a>
                    <a href="${pageContext.request.contextPath}/account/change-password">Change Password</a>
                    <a href="${pageContext.request.contextPath}/account/logoff">Logoff</a>
                </div>
            </span>
            <span class="right greet">Hello, ${sessionScope.currentUser.fullname != null && sessionScope.currentUser.fullname != '' ? sessionScope.currentUser.fullname : sessionScope.currentUser.id}</span>
        </c:when>
        <c:otherwise>
            <!-- chưa login -->
            <span class="dropdown">
                <span class="dropdown-toggle">Account</span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                    <a href="${pageContext.request.contextPath}/account/forgot-password">Forgot Password</a>
                    <a href="${pageContext.request.contextPath}/account/registration">Registration</a>
                </div>
            </span>
            <span class="right greet">Hello, Guest</span>
        </c:otherwise>
    </c:choose>
</div>

<c:if test="${empty hideSearch}">
    <div class="searchbar">
        <div class="searchbar-inner">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" name="q" value="${fn:escapeXml(param.q)}" placeholder="Search videos..." />
                <button type="submit">Search</button>
            </form>
        </div>
    </div>
</c:if>




<div class="container">
    <!-- NỘI DUNG TỪ TRANG CON -->
    <jsp:include page="${view}" />
</div>

</body>
<script>
    (function(){
        var t = localStorage.getItem('theme');
        if(!t){ t = 'light'; }
        document.body.setAttribute('data-theme', t);
        var btn = document.getElementById('themeToggle');
        if(btn){ 
            btn.textContent = t === 'dark' ? '☀️ Light' : '🌙 Dark';
            btn.addEventListener('click', function(){ 
                var nt = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark'; 
                document.body.setAttribute('data-theme', nt); 
                localStorage.setItem('theme', nt); 
                btn.textContent = nt === 'dark' ? '☀️ Light' : '🌙 Dark';
            }); 
        }
    })();
</script>
</html>
