<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="admin-page">
    <h1 class="admin-title"><fmt:message key="admin.home.title"/></h1>

    <!-- Ô thống kê nhanh -->
    <div class="admin-stat-grid">
        <div class="stat-box">
            <div class="stat-label"><fmt:message key="admin.stats.videos"/></div>
            <div class="stat-value">${videoCount}</div>
        </div>
        <div class="stat-box">
            <div class="stat-label"><fmt:message key="admin.stats.users"/></div>
            <div class="stat-value">${userCount}</div>
        </div>
    </div>

    <!-- Lối tắt -->
    <div class="admin-shortcuts">
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/videos"><fmt:message key="admin.shortcuts.videos"/></a>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/users"><fmt:message key="admin.shortcuts.users"/></a>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/reports"><fmt:message key="admin.shortcuts.reports"/></a>
    </div>

    <!-- Bảng vài video mới nhất / nhiều view -->
    <h2 class="admin-subtitle"><fmt:message key="admin.featured.title"/></h2>
    <table class="admin-table">
        <thead>
        <tr>
            <th><fmt:message key="table.id"/></th>
            <th><fmt:message key="table.title"/></th>
            <th><fmt:message key="table.views"/></th>
            <th><fmt:message key="table.status"/></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="v" items="${topVideos}">
            <tr>
                <td>${v.id}</td>
                <td>${v.title}</td>
                <td>${v.views}</td>
                <td>
                    <c:choose>
                        <c:when test="${v.active}"><fmt:message key="status.active"/></c:when>
                        <c:otherwise><fmt:message key="status.inactive"/></c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
