<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h1 class="admin-title">Báo cáo - Thống kê</h1>

<!-- 1. Thống kê yêu thích -->
<h2 class="admin-subtitle">1. Thống kê số người yêu thích từng tiểu phẩm</h2>

<table class="admin-table">
    <thead>
    <tr>
        <th>Video Title</th>
        <th>Favorite Count</th>
        <th>Latest Date</th>
        <th>Oldest Date</th>
    </tr>
    </thead>

    <tbody>
    <c:forEach var="r" items="${favoriteReports}">
        <tr>
            <td>${r[0]}</td>
            <td>${r[1]}</td>
            <td>${r[2]}</td>
            <td>${r[3]}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 2. User yêu thích theo từng video -->
<h2 class="admin-subtitle">2. Lọc người dùng yêu thích theo tiểu phẩm</h2>

<form class="admin-form" method="get" action="${pageContext.request.contextPath}/admin/reports">
    <div class="admin-form-row">
        <label>Chọn Video:</label>
        <select name="videoId">
            <c:forEach var="v" items="${videos}">
                <option value="${v.id}" ${param.videoId == v.id ? "selected" : ""}>
                    ${v.title}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="admin-form-actions">
        <button class="btn btn-primary" type="submit">Lọc</button>
    </div>
</form>

<table class="admin-table">
    <thead>
    <tr>
        <th>Username</th>
        <th>Fullname</th>
        <th>Email</th>
        <th>Favorite Date</th>
    </tr>
    </thead>

    <tbody>
    <c:forEach var="f" items="${favoriteUsers}">
        <tr>
            <td>${f.user.id}</td>
            <td>${f.user.fullname}</td>
            <td>${f.user.email}</td>
            <td>${f.likeDate}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- 3. Báo cáo chia sẻ -->
<h2 class="admin-subtitle">3. Lọc người chia sẻ theo tiểu phẩm</h2>

<form class="admin-form" method="get" action="${pageContext.request.contextPath}/admin/reports">
    <div class="admin-form-row">
        <label>Chọn Video:</label>
        <select name="shareVideoId">
            <c:forEach var="v" items="${videosShare}">
                <option value="${v.id}" ${param.shareVideoId == v.id ? "selected" : ""}>
                    ${v.title}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="admin-form-actions">
        <button class="btn btn-primary" type="submit">Lọc</button>
    </div>
</form>

<table class="admin-table">
    <thead>
    <tr>
        <th>Sender Username</th>
        <th>Sender Email</th>
        <th>Receiver Email</th>
        <th>Sent Date</th>
    </tr>
    </thead>

    <tbody>
    <c:forEach var="s" items="${shareReports}">
        <tr>
            <td>${s.user.id}</td>
            <td>${s.user.email}</td>
            <td>${s.email}</td>
            <td>${s.shareDate}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
