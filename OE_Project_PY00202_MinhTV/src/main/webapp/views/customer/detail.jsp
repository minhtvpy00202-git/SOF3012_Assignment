<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .detail-layout {
        display: grid;
        grid-template-columns: 3fr 1.2fr;
        gap: 25px;
    }

    .video-box {
        border: 2px solid #f4a460;
        padding: 10px;
        margin-bottom: 10px;
    }

    .detail-title-bar {
        background: #e4f5d2;
        padding: 6px 10px;
        font-weight: bold;
        margin-top: 10px;
    }

    .detail-desc {
        padding: 8px 10px;
        border-top: 1px solid #eee;
    }

    .detail-actions {
        margin-top: 10px;
        text-align: right;
    }

    .btn-like, .btn-share {
        border: none;
        padding: 5px 18px;
        font-weight: bold;
        cursor: pointer;
        margin-left: 6px;
        border-radius: 3px;
    }

    .btn-like  { background: #4caf50; color: #fff; }
    .btn-share { background: #ff7f27; color: #fff; }

    .sidebar-item {
        display: grid;
        grid-template-columns: 80px auto;
        border: 1px solid #8bc34a;
        margin-bottom: 10px;
    }

    .sidebar-poster {
        border-right: 1px solid #8bc34a;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }

    .sidebar-poster img {
        max-width: 100%;
    }

    .sidebar-title {
        padding: 8px;
        font-size: 14px;
    }

    .sidebar-title a {
        text-decoration: none;
        color: #000;
        font-weight: bold;
    }

    .sidebar-title a:hover {
        text-decoration: underline;
    }
</style>

<div class="detail-layout">

    <!-- Cột trái: video chính -->
    <div>
        <div class="video-box">
            <iframe width="100%" height="360"
                    src="https://www.youtube.com/embed/${video.href}"
                    frameborder="0" allowfullscreen></iframe>

            <div class="detail-title-bar">
                ${video.title}
            </div>

            <div class="detail-desc">
                <p>${video.description}</p>
                <p>Lượt xem: ${video.views}</p>
            </div>

            <div class="detail-actions">
                <form action="${pageContext.request.contextPath}/video/like" method="post" style="display:inline;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <button class="btn-like">Like</button>
                </form>

                <form action="${pageContext.request.contextPath}/video/share" method="get" style="display:inline;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <button class="btn-share">Share</button>
                </form>
            </div>

        </div>
    </div>

    <!-- Cột phải: danh sách video đã xem gần đây -->
    <div>
        <h3>Video đã xem gần đây</h3>

        <c:forEach var="v" items="${recentVideos}">
            <div class="sidebar-item">
                <div class="sidebar-poster">
                    <img src="${pageContext.request.contextPath}/${v.poster}" alt="${v.title}">
                </div>
                <div class="sidebar-title">
                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.id}">
                        ${v.title}
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>

</div>
