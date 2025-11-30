<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="home-title"><fmt:message key="menu.favorites"/></div>

<c:if test="${empty favorites}">
    <p><fmt:message key="favorites.empty"/></p>
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
                <span class="video-views">(<fmt:message key="table.views"/> ${v.views})</span>
            </div>

            <div class="btn-row">
                <!-- Unlike -->
                <form action="${pageContext.request.contextPath}/video/unlike"
                      method="post" style="display:inline;">
                    <input type="hidden" name="videoId" value="${v.id}">
                    <button type="submit" class="btn-unlike"><fmt:message key="action.unlike"/></button>
                </form>

                <!-- Share -->
                <form action="${pageContext.request.contextPath}/share"
                      method="get" style="display:inline;">
                    <input type="hidden" name="videoId" value="${v.id}">
                    <button type="submit" class="btn-share"><fmt:message key="action.share"/></button>
                </form>
            </div>
        </div>
    </c:forEach>
</div>
