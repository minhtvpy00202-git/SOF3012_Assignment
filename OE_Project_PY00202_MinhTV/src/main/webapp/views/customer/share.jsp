<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .share-box {
        border: 2px solid #f4a460;
        padding: 15px;
    }

    .share-title {
        font-size: 20px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .form-row {
        margin-bottom: 10px;
    }

    label {
        display: block;
        margin-bottom: 4px;
    }

    input[type=text], textarea {
        width: 100%;
        box-sizing: border-box;
        padding: 6px;
    }

    .btn-send {
        background: #ff7f27;
        border: none;
        color: #fff;
        padding: 6px 20px;
        cursor: pointer;
        font-weight: bold;
    }

    .message {
        margin-top: 10px;
        color: green;
        font-weight: bold;
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
