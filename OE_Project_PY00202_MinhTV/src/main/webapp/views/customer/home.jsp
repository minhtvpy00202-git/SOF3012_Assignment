<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser && likedMap[v.id]}">
                        <form action="${pageContext.request.contextPath}/video/unlike" method="post" style="display:inline;">
                            <input type="hidden" name="videoId" value="${v.id}">
                            <button class="btn-like">Unlike</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/video/like" method="post" style="display:inline;">
                            <input type="hidden" name="videoId" value="${v.id}">
                            <button class="btn-like">Like</button>
                        </form>
                    </c:otherwise>
                </c:choose>

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
