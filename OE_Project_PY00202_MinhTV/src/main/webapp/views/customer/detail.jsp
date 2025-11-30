<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                <h2>Description</h2>
                <p>${video.description}</p>
                <p>Lượt xem: ${video.views}</p>
            </div>

            <div class="detail-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <c:choose>
                            <c:when test="${videoLikedByMe}">
                                <form action="${pageContext.request.contextPath}/video/unlike" method="post" style="display:inline;">
                                    <input type="hidden" name="videoId" value="${video.id}">
                                    <button class="btn-like">Unlike</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/video/like" method="post" style="display:inline;">
                                    <input type="hidden" name="videoId" value="${video.id}">
                                    <button class="btn-like">Like</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <a class="btn-like" href="${pageContext.request.contextPath}/login">Like</a>
                    </c:otherwise>
                </c:choose>

                <form action="${pageContext.request.contextPath}/video/share" method="get" style="display:inline;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <button class="btn-share">Share</button>
                </form>
            </div>

            <!-- BÌNH LUẬN -->
            <div class="detail-title-bar" style="margin-top:16px;">COMMENTS</div>

            <div class="comment-form" style="padding: 20px; background: var(--comment-bg); border-radius: 8px; margin-top: 16px;">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <form action="${pageContext.request.contextPath}/comment/add" method="post" style="width: 100%;">
                            <input type="hidden" name="videoId" value="${video.id}" />
                            <div style="width: 100%;">
                                <textarea name="content" rows="4" style="width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 8px; background: var(--input-bg); color: var(--text-primary); font-family: inherit; font-size: 14px; resize: vertical; box-sizing: border-box;"></textarea>
                            </div>
                            <div style="text-align:right; margin-top:12px;">
                                <button class="btn-share" type="submit">Post Comment</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div>Hãy <a href="${pageContext.request.contextPath}/login">đăng nhập</a> để bình luận.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:forEach var="cmt" items="${comments}">
                <div class="comment-item">
                    <div class="comment-author">
                        <c:choose>
                            <c:when test="${not empty cmt.user.fullname}">${cmt.user.fullname}</c:when>
                            <c:otherwise>${cmt.user.id}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="comment-content">${cmt.content}</div>
                    <div class="comment-actions">
                        <form action="${pageContext.request.contextPath}/comment/like" method="post" style="display:inline;">
                            <input type="hidden" name="commentId" value="${cmt.id}" />
                            <input type="hidden" name="videoId" value="${video.id}" />
                            <button class="btn-like" type="submit" style="padding:4px 12px; font-size:12px;">
                                <c:choose>
                                    <c:when test="${commentLikedByMe[cmt.id]}">Unlike</c:when>
                                    <c:otherwise>Like</c:otherwise>
                                </c:choose>
                            </button>
                        </form>
                        <span>${commentLikeCounts[cmt.id]} likes</span>
                    </div>

                    <!-- form trả lời -->
                    <c:if test="${not empty sessionScope.currentUser}">
                        <div style="margin-top:12px; width: 100%;">
                            <form action="${pageContext.request.contextPath}/comment/reply" method="post" style="width: 100%;">
                                <input type="hidden" name="parentId" value="${cmt.id}" />
                                <div style="width: 100%;">
                                    <input type="text" name="content" style="width:100%; padding:10px; box-sizing:border-box; border:1px solid var(--border-color); border-radius:8px; background:var(--input-bg); color:var(--text-primary); font-size: 14px;" placeholder="Viết phản hồi..." />
                                </div>
                                <div style="text-align:right; margin-top:8px;">
                                    <button class="btn-share" type="submit">Reply</button>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <!-- danh sách trả lời -->
                    <c:forEach var="rep" items="${cmt.replies}">
                        <div class="comment-reply">
                            <div class="comment-author">
                                <c:choose>
                                    <c:when test="${not empty rep.user.fullname}">${rep.user.fullname}</c:when>
                                    <c:otherwise>${rep.user.id}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="comment-content">${rep.content}</div>
                            <div class="comment-actions">
                                <form action="${pageContext.request.contextPath}/comment/like" method="post" style="display:inline;">
                                    <input type="hidden" name="commentId" value="${rep.id}" />
                                    <input type="hidden" name="videoId" value="${video.id}" />
                                    <button class="btn-like" type="submit" style="padding:4px 12px; font-size:12px;">
                                        <c:choose>
                                            <c:when test="${commentLikedByMe[rep.id]}">Unlike</c:when>
                                            <c:otherwise>Like</c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                                <span>${commentLikeCounts[rep.id]} likes</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:forEach>

        </div>
    </div>

    <!-- Cột phải: danh sách video đã xem gần đây -->
    <div>
        <h3>Recently Watched Videos</h3>

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
