<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="home-title"><fmt:message key="search.resultsTitle"><fmt:param value="${q}"/></fmt:message></div>

<c:choose>
    <c:when test="${empty videos}">
        <div><fmt:message key="search.noResults"/></div>
    </c:when>
    <c:otherwise>
        <div class="video-grid">
            <c:forEach var="v" items="${videos}">
                <div class="video-card">
                    <a class="poster-box" href="${pageContext.request.contextPath}/video/detail?id=${v.id}">
                        <img src="${pageContext.request.contextPath}/${v.poster}" alt="${v.title}" />
                    </a>
                    <div class="video-title-bar">${v.title}</div>

                    <div>
                        <form action="${pageContext.request.contextPath}/video/share" method="get" style="display:inline;">
                            <input type="hidden" name="videoId" value="${v.id}" />
                            <button class="btn-share" type="submit"><fmt:message key="action.share"/></button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="pager">
            <form action="${pageContext.request.contextPath}/search" method="get" style="display:inline;">
                <input type="hidden" name="q" value="${q}" />
                <button name="page" value="1">&vert;&lt;</button>
            </form>
            <form action="${pageContext.request.contextPath}/search" method="get" style="display:inline;">
                <input type="hidden" name="q" value="${q}" />
                <button name="page" value="${currentPage > 1 ? currentPage - 1 : 1}">&lt;&lt;</button>
            </form>
            <form action="${pageContext.request.contextPath}/search" method="get" style="display:inline;">
                <input type="hidden" name="q" value="${q}" />
                <button name="page" value="${currentPage < totalPage ? currentPage + 1 : totalPage}">&gt;&gt;</button>
            </form>
            <form action="${pageContext.request.contextPath}/search" method="get" style="display:inline;">
                <input type="hidden" name="q" value="${q}" />
                <button name="page" value="${totalPage}">&gt;&vert;</button>
            </form>
        </div>
    </c:otherwise>
</c:choose>
