<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
