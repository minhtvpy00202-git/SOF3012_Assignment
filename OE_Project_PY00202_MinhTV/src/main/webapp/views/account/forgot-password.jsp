<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login-page.css">

<div class="login-container">
    <div class="login-title">FORGOT PASSWORD</div>

    <div class="login-form">
        <c:if test="${not empty message}">
            <div class="error">${message}</div>
        </c:if>

        <form method="post">
            <div class="form-row">
                <label>Username</label>
                <input type="text" name="username" value="${param.username}" placeholder="Enter your username">
            </div>
            <div class="form-row">
                <label>Email</label>
                <input type="email" name="email" value="${param.email}" placeholder="Enter your email">
            </div>
            <button class="btn-submit" type="submit">Retrieve Password</button>
        </form>

        <div class="account-links">
            Remember your password? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</div>
