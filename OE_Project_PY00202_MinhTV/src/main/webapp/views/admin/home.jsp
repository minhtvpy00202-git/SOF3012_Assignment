<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="admin-page">
    <h1 class="admin-title">Trang chủ quản trị</h1>

    <!-- Ô thống kê nhanh -->
    <div class="admin-stat-grid">
        <div class="stat-box">
            <div class="stat-label">Tổng số tiểu phẩm</div>
            <div class="stat-value">${videoCount}</div>
        </div>
        <div class="stat-box">
            <div class="stat-label">Tổng số người dùng</div>
            <div class="stat-value">${userCount}</div>
        </div>
    </div>

    <!-- Lối tắt -->
    <div class="admin-shortcuts">
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/videos">Quản lý Video</a>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/users">Quản lý Người dùng</a>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/admin/reports">Báo cáo – Thống kê</a>
    </div>

    <!-- Bảng vài video mới nhất / nhiều view -->
    <h2 class="admin-subtitle">Các tiểu phẩm nổi bật</h2>
    <table class="admin-table">
        <thead>
        <tr>
            <th>Mã</th>
            <th>Tiêu đề</th>
            <th>Lượt xem</th>
            <th>Trạng thái</th>
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
                        <c:when test="${v.active}">Đang hiển thị</c:when>
                        <c:otherwise>Ẩn</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
