<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login-page.css">

<div class="login-container">
    <div class="login-title">REGISTRATION</div>

    <div class="login-form">
        <c:if test="${not empty message}">
            <div class="error">${message}</div>
        </c:if>

        <form method="post">
            <div class="form-row">
                <label>Username</label>
                <input type="text" name="username" value="${param.username}" placeholder="Choose a username">
            </div>
            <div class="form-row">
                <label>Password</label>
                <input type="password" name="password" placeholder="Create a password">
            </div>
            <div class="form-row">
                <label>Full Name</label>
                <input type="text" name="fullname" value="${param.fullname}" placeholder="Enter your full name">
            </div>
            <div class="form-row">
                <label>Email Address</label>
                <input type="email" name="email" value="${param.email}" placeholder="Enter your email">
            </div>

            <button class="btn-submit" type="submit">Sign Up</button>
        </form>

        <div class="account-links">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</div>
