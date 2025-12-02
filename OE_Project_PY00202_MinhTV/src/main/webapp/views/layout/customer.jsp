<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OE Online Entertainment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/youtube-style.css">
</head>
<body data-theme="light">

<c:if test="${not empty param.lang}">
    <c:set var="siteLang" value="${param.lang}" scope="session" />
    </c:if>
<fmt:setLocale value="${sessionScope.siteLang != null ? sessionScope.siteLang : 'vi'}" scope="request" />
<fmt:setBundle basename="messages" scope="request" />

<div class="top-bar">
    <span><fmt:message key="app.title"/></span>
    <div class="theme-toggle">
        <button id="themeToggle" type="button">🌙 Dark</button>
    </div>
    <div class="lang-switch">
        <a href="#" data-lang="en">EN</a> | <a href="#" data-lang="vi">VI</a>
    </div>
</div>

<div class="menu">
    <a href="${pageContext.request.contextPath}/home"><fmt:message key="menu.home"/></a>
    <a href="${pageContext.request.contextPath}/my-favorites"><fmt:message key="menu.favorites"/></a>

    

    <!-- Khu My Account (tùy theo đã đăng nhập hay chưa) -->
    <c:choose>
        <c:when test="${not empty sessionScope.currentUser}">
            <!-- đã login -->
            <c:if test="${sessionScope.currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/home"><fmt:message key="menu.adminDashboard"/></a>
            </c:if>
            <span class="dropdown">
                <span class="dropdown-toggle"><fmt:message key="menu.account"/></span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/account/edit-profile"><fmt:message key="account.editProfile"/></a>
                    <a href="${pageContext.request.contextPath}/account/change-password"><fmt:message key="account.changePassword"/></a>
                    <a href="${pageContext.request.contextPath}/account/logoff"><fmt:message key="account.logoff"/></a>
                </div>
            </span>
            <span class="right greet"><fmt:message key="greet.loggedInPrefix"/> <b style="color: red;"> ${sessionScope.currentUser.fullname != null && sessionScope.currentUser.fullname != '' ? sessionScope.currentUser.fullname : sessionScope.currentUser.id} </b></span>
        </c:when>
        <c:otherwise>
            <!-- chưa login -->
            <span class="dropdown">
                <span class="dropdown-toggle"><fmt:message key="menu.account"/></span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/login"><fmt:message key="account.login"/></a>
                    <a href="${pageContext.request.contextPath}/account/forgot-password"><fmt:message key="account.forgotPassword"/></a>
                    <a href="${pageContext.request.contextPath}/account/registration"><fmt:message key="account.registration"/></a>
                </div>
            </span>
            <span class="right greet"><fmt:message key="greet.guest"/></span>
        </c:otherwise>
    </c:choose>
</div>

<c:if test="${empty hideSearch}">
    <div class="searchbar">
        <div class="searchbar-inner">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" name="q" value="${fn:escapeXml(param.q)}" placeholder="<fmt:message key='search.placeholder'/>" />
                <button type="submit"><fmt:message key="search.button"/></button>
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
