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

    .btn-like, .btn-share {
        border: none;
        padding: 5px 18px;
        font-weight: bold;
        cursor: pointer;
        margin-right: 6px;
        border-radius: 3px;
    }

    .btn-like  { background: #4caf50; color: #fff; }
    .btn-share { background: #ff7f27; color: #fff; }

    .pager {
        text-align: center;
        margin-top: 20px;
    }

    .pager button {
        padding: 5px 15px;
        margin: 0 3px;
    }
</style>

<div class="home-title">Danh sách tiểu phẩm</div>

<div class="video-grid">
    <c:forEach var="v" items="${videos}">
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
                <form action="${pageContext.request.contextPath}/video/like" method="post" style="display:inline;">
                    <input type="hidden" name="videoId" value="${v.id}">
                    <button class="btn-like">Like</button>
                </form>

                <form action="${pageContext.request.contextPath}/video/share" method="get" style="display:inline;">
                    <input type="hidden" name="videoId" value="${v.id}">
                    <button class="btn-share">Share</button>
                </form>
            </div>

        </div>
    </c:forEach>
</div>

<div class="pager">
    <form action="${pageContext.request.contextPath}/home" method="get" style="display:inline;">
        <button name="page" value="1">&vert;&lt;</button>
    </form>

    <form action="${pageContext.request.contextPath}/home" method="get" style="display:inline;">
        <button name="page" value="${currentPage > 1 ? currentPage - 1 : 1}">&lt;&lt;</button>
    </form>

    <form action="${pageContext.request.contextPath}/home" method="get" style="display:inline;">
        <button name="page" value="${currentPage < totalPage ? currentPage + 1 : totalPage}">&gt;&gt;</button>
    </form>

    <form action="${pageContext.request.contextPath}/home" method="get" style="display:inline;">
        <button name="page" value="${totalPage}">&gt;&vert;</button>
    </form>
</div>
