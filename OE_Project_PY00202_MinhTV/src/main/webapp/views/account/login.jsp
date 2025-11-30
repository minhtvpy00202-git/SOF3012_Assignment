<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login-page.css">

<div class="login-container">
    <div class="login-title">LOGIN</div>

    <div class="login-form">
        <c:if test="${not empty message}">
            <div class="error">${message}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-row">
                <label>Username</label>
                <input type="text" name="username" value="${param.username != null ? param.username : cookie.username.value}" placeholder="Enter your username">
            </div>
            <div class="form-row">
                <label>Password</label>
                <input type="password" name="password" value="${cookie.password.value}" placeholder="Enter your password">
            </div>
            <div class="remember">
                <input type="checkbox" id="remember" name="remember" ${cookie.username.value != null ? "checked" : ""}>
                <label for="remember">Remember me</label>
            </div>
            <button type="submit" class="btn-login">Login</button>
        </form>

        <div class="account-links">
            <a href="${pageContext.request.contextPath}/account/forgot-password">Forgot Password?</a> | 
            <a href="${pageContext.request.contextPath}/account/registration">Create Account</a> | 
            <a href="${pageContext.request.contextPath}/home">Guest Mode</a>
        </div>
    </div>
</div>
