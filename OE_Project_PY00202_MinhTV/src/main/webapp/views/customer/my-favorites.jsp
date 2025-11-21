<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .home-title {
        font-size: 22px;
        font-weight: bold;
        margin-bottom: 15px;
    }

    .video-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
    }

    .video-card {
        border: 2px solid #f4a460;
        padding: 10px;
    }

    .poster-box {
        border: 1px solid #f4a460;
        height: 180px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 5px;
        overflow: hidden;
    }

    .poster-box img {
        max-height: 100%;
    }

    .video-title-bar {
        background: #e4f5d2;
        padding: 5px 8px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .btn-row {
        text-align: left;
    }

    .btn-unlike, .btn-share {
        border: none;
        padding: 5px 18px;
        font-weight: bold;
        cursor: pointer;
        margin-right: 6px;
        border-radius: 3px;
    }

    .btn-unlike  { background: #d9534f; color: #fff; }
    .btn-share   { background: #ff7f27; color: #fff; }
</style>

<div class="home-title">My Favorites</div>

<c:if test="${empty favorites}">
    <p>Bạn chưa thích tiểu phẩm nào.</p>
</c:if>

<div class="video-grid">
    <c:forEach var="f" items="${favorites}">
        <c:set var="v" value="${f.video}"/>
        <div class="video-card">
            <a class="poster-box"
               href="${pageContext.request.contextPath}/video/detail?id=${v.id}">
                <img src="${pageContext.request.contextPath}/${v.poster}"
                     alt="${v.title}">
            </a>

            <div class="video-title-bar">
                ${v.title}
            </div>

            <div class="btn-row">
                <!-- Unlike -->
                <form action="${pageContext.request.contextPath}/video/unlike"
                      method="post" style="display:inline;">
                    <input type="hidden" name="videoId" value="${v.id}">
                    <button type="submit" class="btn-unlike">Unlike</button>
                </form>

                <!-- Share -->
                <form action="${pageContext.request.contextPath}/share"
                      method="get" style="display:inline;">
                    <input type="hidden" name="videoId" value="${v.id}">
                    <button type="submit" class="btn-share">Share</button>
                </form>
            </div>
        </div>
    </c:forEach>
</div>
