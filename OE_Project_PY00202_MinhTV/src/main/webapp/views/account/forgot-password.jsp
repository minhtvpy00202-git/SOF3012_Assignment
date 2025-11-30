<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login-page.css">

<div class="login-container">
    <div class="login-title"><fmt:message key="account.forgotPassword"/></div>

    <div class="login-form">
        <c:if test="${not empty message}">
            <div class="error">${message}</div>
        </c:if>

        <form method="post">
            <div class="form-row">
                <label><fmt:message key="login.username"/></label>
                <input type="text" name="username" value="${param.username}" placeholder="Enter your username">
            </div>
            <div class="form-row">
                <label><fmt:message key="account.email"/></label>
                <input type="email" name="email" value="${param.email}" placeholder="Enter your email">
            </div>
            <button class="btn-submit" type="submit"><fmt:message key="forgot.retrieve"/></button>
        </form>

        <div class="account-links">
            <fmt:message key="forgot.remember"/> <a href="${pageContext.request.contextPath}/login"><fmt:message key="account.login"/></a>
        </div>
    </div>
</div>
