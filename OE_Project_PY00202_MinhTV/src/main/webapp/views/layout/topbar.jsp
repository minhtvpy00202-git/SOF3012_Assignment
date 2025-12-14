<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- 
    Topbar Component - Reusable for both Customer and Admin
    Parameters:
    - isAdmin: true for admin layout, false for customer layout
--%>

<c:set var="isAdmin" value="${param.isAdmin == 'true'}" />

<div class="${isAdmin ? 'admin-top-bar' : 'top-bar'}">
    <div style="display: flex; align-items: center; gap: 12px;">
        <img src="${pageContext.request.contextPath}/assets/images/Logo.png" alt="Logo" class="site-logo">
        <span>
            <fmt:message key="app.title"/>
            <c:if test="${isAdmin}"> - Admin</c:if>
        </span>
    </div>
    <div style="display: flex; gap: 10px; align-items: center;">
        <div class="${isAdmin ? 'admin-theme-toggle' : 'theme-toggle'}">
            <button id="${isAdmin ? 'adminThemeToggle' : 'themeToggle'}" type="button">🌙 Dark</button>
        </div>
        <div class="lang-switch">
            <a href="#" data-lang="en">EN</a> | <a href="#" data-lang="vi">VI</a>
        </div>
    </div>
</div>
