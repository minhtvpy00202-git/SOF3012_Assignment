<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login-page.css">

<div class="login-container">
    <div class="login-title"><fmt:message key="login.title"/></div>

    <div class="login-form">
        <c:if test="${not empty message}">
            <div class="error">${message}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-row">
                <label><fmt:message key="login.username"/></label>
                <input type="text" name="username" value="${param.username != null ? param.username : cookie.username.value}" placeholder="Enter your username">
            </div>
            <div class="form-row">
                <label><fmt:message key="login.password"/></label>
                <input type="password" name="password" value="${cookie.password.value}" placeholder="Enter your password">
            </div>
            <div class="remember">
                <input type="checkbox" id="remember" name="remember" ${cookie.username.value != null ? "checked" : ""}>
                <label for="remember"><fmt:message key="login.remember"/></label>
            </div>
            <button type="submit" class="btn-login"><fmt:message key="login.button"/></button>
        </form>

        <div class="account-links">
            <a href="${pageContext.request.contextPath}/account/forgot-password"><fmt:message key="login.forgotPassword"/></a> | 
            <a href="${pageContext.request.contextPath}/account/registration"><fmt:message key="login.createAccount"/></a> | 
            <a href="${pageContext.request.contextPath}/home"><fmt:message key="login.guestMode"/></a>
        </div>
    </div>
</div>
