<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>OE Online Entertainment</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
        }

        .top-bar {
            background: #f37b1f;
            color: #fff;
            padding: 10px 30px;
            font-size: 20px;
            font-weight: bold;
        }

        .menu {
            background: #333;
            color: #fff;
            padding: 8px 30px;
        }

        .menu a {
            color: #fff;
            text-decoration: none;
            margin-right: 20px;
            font-weight: bold;
        }

        .menu a:hover {
            text-decoration: underline;
        }

        .container {
            max-width: 1100px;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 5px rgba(0,0,0,.2);
        }
    </style>
</head>
<body>

<div class="top-bar">
    OE Online Entertainment
</div>

<div class="menu">
    <a href="${pageContext.request.contextPath}/home">Online Entertainment</a>
    <a href="${pageContext.request.contextPath}/my-favorites">My Favorites</a>

    <!-- Khu My Account (tùy theo đã đăng nhập hay chưa) -->
    <c:choose>
        <c:when test="${not empty sessionScope.currentUser}">
            <!-- đã login -->
            <a href="${pageContext.request.contextPath}/account/edit-profile">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/account/change-password">Change Password</a>
            <a href="${pageContext.request.contextPath}/account/logoff">Logoff</a>
        </c:when>
        <c:otherwise>
            <!-- chưa login -->
            <a href="${pageContext.request.contextPath}/login">Login</a>
            <a href="${pageContext.request.contextPath}/account/registration">Registration</a>
            <a href="${pageContext.request.contextPath}/account/forgot-password">Forgot Password</a>
        </c:otherwise>
    </c:choose>
</div>




<div class="container">
    <!-- NỘI DUNG TỪ TRANG CON -->
    <jsp:include page="${view}" />
</div>

</body>
</html>
