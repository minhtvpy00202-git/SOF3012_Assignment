<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .notifications-container {
        max-width: 1000px;
        margin: 0 auto;
    }
    
    .notifications-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 24px;
    }
    
    .notifications-title {
        font-size: 24px;
        font-weight: 500;
        color: var(--text-primary);
        margin: 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .notifications-title::before {
        content: '🔔';
        font-size: 28px;
    }
    
    .notifications-empty {
        text-align: center;
        padding: 80px 20px;
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px solid var(--border-color);
    }
    
    .notifications-empty-icon {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .notifications-empty p {
        color: var(--text-secondary);
        font-size: 16px;
        margin: 0;
    }
    
    .notifications-list {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        overflow: hidden;
    }
    
    .notification-item {
        display: flex;
        align-items: flex-start;
        padding: 20px;
        border-bottom: 1px solid var(--border-color);
        transition: background 0.2s ease;
        position: relative;
    }
    
    .notification-item:last-child {
        border-bottom: none;
    }
    
    .notification-item:hover {
        background: var(--bg-hover);
    }
    
    .notification-item.unread {
        background: rgba(102, 126, 234, 0.05);
        border-left: 4px solid var(--accent-color);
    }
    
    .notification-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16px;
        flex-shrink: 0;
        font-size: 18px;
    }
    
    .notification-icon.system {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .notification-icon.message {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
    }
    
    .notification-icon.video {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        color: white;
    }
    
    .notification-content {
        flex: 1;
        min-width: 0;
    }
    
    .notification-title {
        font-weight: 500;
        color: var(--text-primary);
        margin-bottom: 6px;
        font-size: 15px;
        line-height: 1.4;
    }
    
    .notification-title a {
        color: inherit;
        text-decoration: none;
        transition: color 0.2s ease;
    }
    
    .notification-title a:hover {
        color: var(--accent-color);
    }
    
    .notification-description {
        font-size: 13px;
        color: var(--text-secondary);
        line-height: 1.4;
        margin-bottom: 8px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .notification-meta {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 12px;
        color: var(--text-secondary);
    }
    
    .notification-type {
        background: var(--input-bg);
        padding: 2px 8px;
        border-radius: 12px;
        font-weight: 500;
        text-transform: uppercase;
        font-size: 11px;
    }
    
    .notification-status {
        font-weight: 500;
    }
    
    .notification-status.read {
        color: var(--text-secondary);
    }
    
    .notification-status.unread {
        color: var(--accent-color);
    }
    
    .notification-actions {
        display: flex;
        gap: 8px;
        margin-left: 16px;
        flex-shrink: 0;
    }
    
    .notification-btn {
        padding: 6px 12px;
        border: none;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .notification-btn.mark-read {
        background: var(--button-bg);
        color: var(--button-text);
    }
    
    .notification-btn.mark-read:hover {
        opacity: 0.9;
    }
    
    .notification-btn.delete {
        background: var(--danger-color);
        color: #ffffff;
    }
    
    .notification-btn.delete:hover {
        opacity: 0.9;
    }
    
    .notification-btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
    
    .unread-indicator {
        position: absolute;
        top: 20px;
        right: 20px;
        width: 8px;
        height: 8px;
        background: var(--accent-color);
        border-radius: 50%;
    }
    
    @media (max-width: 768px) {
        .notification-item {
            flex-direction: column;
            gap: 12px;
        }
        
        .notification-actions {
            margin-left: 0;
            align-self: stretch;
        }
        
        .notification-btn {
            flex: 1;
        }
    }
</style>

<div class="notifications-container">
    <div class="notifications-header">
        <h1 class="notifications-title"><fmt:message key="notifications.title"/></h1>
    </div>
    
    <c:choose>
        <c:when test="${empty notifications}">
            <div class="notifications-empty">
                <div class="notifications-empty-icon">🔔</div>
                <p><fmt:message key="notifications.empty"/></p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="notifications-list">
                <c:forEach var="n" items="${notifications}">
                    <div class="notification-item ${!n.isRead ? 'unread' : ''}">
                        <div class="notification-icon ${n.type.toLowerCase()}">
                            <c:choose>
                                <c:when test="${n.type == 'SYSTEM'}">⚙️</c:when>
                                <c:when test="${n.type == 'MESSAGE'}">💬</c:when>
                                <c:when test="${n.type == 'VIDEO'}">🎥</c:when>
                                <c:otherwise>📢</c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="notification-content">
                            <div class="notification-title">
                                <c:choose>
                                    <c:when test="${n.targetUrl != null && n.targetUrl != ''}">
                                        <a href="${pageContext.request.contextPath}${n.targetUrl}">${n.title}</a>
                                    </c:when>
                                    <c:otherwise>
                                        ${n.title}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="notification-description">${n.content}</div>
                            
                            <div class="notification-meta">
                                <span class="notification-type">${n.type}</span>
                                <span class="notification-status ${n.isRead ? 'read' : 'unread'}">
                                    <c:choose>
                                        <c:when test="${n.isRead}">Read</c:when>
                                        <c:otherwise>Unread</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <div class="notification-actions">
                            <c:if test="${!n.isRead}">
                                <form action="${pageContext.request.contextPath}/notifications" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${n.id}" />
                                    <input type="hidden" name="action" value="markRead" />
                                    <button type="submit" class="notification-btn mark-read">
                                        <fmt:message key="notifications.markRead"/>
                                    </button>
                                </form>
                            </c:if>
                            
                            <form action="${pageContext.request.contextPath}/notifications" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${n.id}" />
                                <input type="hidden" name="action" value="delete" />
                                <button type="submit" class="notification-btn delete">
                                    <fmt:message key="notifications.delete"/>
                                </button>
                            </form>
                        </div>
                        
                        <c:if test="${!n.isRead}">
                            <div class="unread-indicator"></div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<div class="notifications-container" style="margin-top:24px;">
    <div class="notifications-header">
        <h1 class="notifications-title"><fmt:message key="inbox.title"/></h1>
    </div>
    <c:choose>
        <c:when test="${empty messages}">
            <div class="notifications-empty">
                <div class="notifications-empty-icon">💬</div>
                <p><fmt:message key="inbox.empty"/></p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="notifications-list">
                <c:forEach var="m" items="${messages}">
                    <div class="notification-item ${!m.isRead ? 'unread' : ''}">
                        <div class="notification-icon message">💬</div>
                        <div class="notification-content">
                            <div class="notification-title">${m.title}</div>
                            <div class="notification-description">${m.content}</div>
                            <div class="notification-meta">
                                <span class="notification-type">MESSAGE</span>
                                <span class="notification-status ${m.isRead ? 'read' : 'unread'}">
                                    <c:choose>
                                        <c:when test="${m.isRead}">Read</c:when>
                                        <c:otherwise>Unread</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="notification-actions">
                            <c:if test="${!m.isRead}">
                                <form action="${pageContext.request.contextPath}/notifications" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${m.id}" />
                                    <input type="hidden" name="action" value="markMessageRead" />
                                    <button type="submit" class="notification-btn mark-read">
                                        <fmt:message key="inbox.markRead"/>
                                    </button>
                                </form>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/notifications" method="post" style="display:inline; margin-left: 6px;">
                                <input type="hidden" name="id" value="${m.id}" />
                                <input type="hidden" name="action" value="deleteMessage" />
                                <button type="submit" class="notification-btn delete">
                                    <fmt:message key="notifications.delete"/>
                                </button>
                            </form>
                        </div>
                        <c:if test="${!m.isRead}">
                            <div class="unread-indicator"></div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
