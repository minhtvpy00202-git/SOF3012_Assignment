<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .account-form-container {
        max-width: 600px;
        margin: 0 auto;
        background: var(--card-bg);
        padding: 32px;
        border-radius: 12px;
        border: 1px solid var(--border-color);
    }
    
    .account-form-title {
        font-size: 24px;
        font-weight: 500;
        margin-bottom: 24px;
        color: var(--text-primary);
    }
    
    .account-form-row {
        margin-bottom: 20px;
    }
    
    .account-form-row label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        font-size: 14px;
        color: var(--text-primary);
    }
    
    .account-form-row input {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid var(--input-border);
        border-radius: 8px;
        background: var(--input-bg);
        color: var(--text-primary);
        font-size: 14px;
        font-family: inherit;
        box-sizing: border-box;
    }
    
    .account-form-row input:focus {
        outline: none;
        border-color: var(--accent-color);
    }
    
    .account-form-row input:disabled,
    .account-form-row input[readonly] {
        opacity: 0.6;
        cursor: not-allowed;
    }
    
    .account-form-submit {
        width: 100%;
        background: var(--button-bg);
        color: var(--button-text);
        border: none;
        padding: 12px 24px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        border-radius: 8px;
        transition: all 0.2s ease;
    }
    
    .account-form-submit:hover {
        opacity: 0.9;
    }
    
    .account-form-message {
        padding: 12px 16px;
        margin-bottom: 20px;
        border-radius: 8px;
        font-size: 14px;
    }
    
    .account-form-message.error {
        background: var(--error-bg);
        color: var(--error-color);
        border: 1px solid var(--error-color);
    }
</style>

<div class="account-form-container">
    <h2 class="account-form-title"><fmt:message key="account.changePassword"/></h2>

    <c:if test="${not empty message}">
        <div class="account-form-message error">${message}</div>
    </c:if>

    <form method="post">
        <div class="account-form-row">
            <label><fmt:message key="login.username"/></label>
            <input type="text" name="username" value="${sessionScope.currentUser.id}" readonly>
        </div>
        <div class="account-form-row">
            <label><fmt:message key="change.currentPassword"/></label>
            <input type="password" name="currentPassword" placeholder="Enter current password">
        </div>
        <div class="account-form-row">
            <label><fmt:message key="change.newPassword"/></label>
            <input type="password" name="newPassword" placeholder="Enter new password">
        </div>
        <div class="account-form-row">
            <label><fmt:message key="change.confirmNew"/></label>
            <input type="password" name="confirm" placeholder="Confirm new password">
        </div>

        <button class="account-form-submit" type="submit"><fmt:message key="account.changePassword"/></button>
    </form>
</div>
