<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>OE - Administration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<header>
    <h2>Online Entertainment - Admin</h2>
    <nav>
        <!-- Home trong khu admin (dashboard / danh sách video) -->
        <a href="${pageContext.request.contextPath}/admin/home">Admin Home</a>

        <!-- Nút sang giao diện khách -->
        <a href="${pageContext.request.contextPath}/home">Customer Home</a>

        <!-- Các chức năng quản trị -->
            <a href="${pageContext.request.contextPath}/admin/videos">Videos</a>
            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
            <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
            <a href="${pageContext.request.contextPath}/account/logoff">Logoff</a>


    </nav>
</header>

<main>
    <jsp:include page="${view}" />
</main>
</body>
</html>
