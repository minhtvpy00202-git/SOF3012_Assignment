<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .share-box {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 24px;
        max-width: 600px;
        margin: 0 auto;
    }

    .share-title {
        font-size: 20px;
        font-weight: 500;
        margin-bottom: 16px;
        color: var(--text-primary);
    }

    .share-box p {
        margin-bottom: 20px;
        color: var(--text-secondary);
        line-height: 1.6;
    }

    .share-box a {
        color: var(--accent-color);
        word-break: break-all;
    }

    .form-row {
        margin-bottom: 16px;
    }

    .form-row label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--text-primary);
        font-size: 14px;
    }

    .form-row textarea {
        width: 100%;
        box-sizing: border-box;
        padding: 12px;
        border: 1px solid var(--input-border);
        border-radius: 8px;
        background: var(--input-bg);
        color: var(--text-primary);
        font-family: inherit;
        font-size: 14px;
        resize: vertical;
    }

    .form-row textarea:focus {
        outline: none;
        border-color: var(--accent-color);
    }

    .btn-send {
        background: var(--share-button);
        border: none;
        color: #ffffff;
        padding: 10px 24px;
        cursor: pointer;
        font-weight: 500;
        border-radius: 8px;
        font-size: 14px;
        transition: opacity 0.2s ease;
    }

    .btn-send:hover {
        opacity: 0.9;
    }

    .message {
        margin-top: 16px;
        padding: 12px;
        background: #f0fdf4;
        color: #15803d;
        border: 1px solid #15803d;
        border-radius: 8px;
        font-weight: 500;
    }

    body[data-theme="dark"] .message {
        background: #1a3a1a;
        color: #4ade80;
        border-color: #4ade80;
    }
</style>

<div class="share-box">
    <div class="share-title">Share: ${video.title}</div>

    <p>Link video:
        <a href="${pageContext.request.contextPath}/video/detail?id=${video.id}">
            ${pageContext.request.contextPath}/video/detail?id=${video.id}
        </a>
    </p>

    <form method="post" action="${pageContext.request.contextPath}/video/share">
        <input type="hidden" name="videoId" value="${video.id}">

        <div class="form-row">
            <label>Emails (ngăn cách bằng dấu phẩy hoặc chấm phẩy):</label>
            <textarea name="emails" rows="3">${param.emails}</textarea>
        </div>

        <button type="submit" class="btn-send">Send</button>
    </form>

    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
</div>
