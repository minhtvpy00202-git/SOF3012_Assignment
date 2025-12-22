<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .inbox-container {
        max-width: 900px;
        margin: 0 auto;
    }
    
    .inbox-title {
        font-size: 24px;
        font-weight: 500;
        margin-bottom: 24px;
        color: var(--text-primary);
    }
    
    .inbox-empty {
        text-align: center;
        padding: 60px 20px;
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px solid var(--border-color);
    }
    
    .inbox-empty-icon {
        font-size: 48px;
        margin-bottom: 16px;
        opacity: 0.5;
    }
    
    .inbox-empty p {
        color: var(--text-secondary);
        font-size: 16px;
        margin: 0;
    }
    
    .messages-table {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        overflow: hidden;
    }
    
    .messages-table table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .messages-table th {
        background: var(--input-bg);
        color: var(--text-primary);
        padding: 16px 20px;
        text-align: left;
        font-weight: 500;
        font-size: 14px;
        border-bottom: 1px solid var(--border-color);
    }
    
    .messages-table td {
        padding: 16px 20px;
        border-bottom: 1px solid var(--border-color);
        vertical-align: top;
    }
    
    .messages-table tbody tr:last-child td {
        border-bottom: none;
    }
    
    .messages-table tbody tr:hover {
        background: var(--bg-hover);
    }
    
    .message-title {
        font-weight: 500;
        color: var(--text-primary);
        margin-bottom: 4px;
        font-size: 15px;
    }
    
    .message-content {
        font-size: 13px;
        color: var(--text-secondary);
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .message-status {
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
    }
    
    .status-read {
        color: var(--text-secondary);
    }
    
    .status-unread {
        color: var(--accent-color);
        position: relative;
    }
    
    .status-unread::before {
        content: '●';
        margin-right: 6px;
        font-size: 12px;
    }
    
    .message-actions {
        white-space: nowrap;
    }
    
    .mark-read-btn {
        background: var(--button-bg);
        color: var(--button-text);
        border: none;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .mark-read-btn:hover {
        opacity: 0.9;
    }
    
    .mark-read-btn:disabled {
        background: var(--text-secondary);
        opacity: 0.5;
        cursor: not-allowed;
    }
</style>

<div class="inbox-container">
    <h1 class="inbox-title"><fmt:message key="inbox.title"/></h1>
    
    <c:choose>
        <c:when test="${empty messages}">
            <div class="inbox-empty">
                <div class="inbox-empty-icon">📬</div>
                <p><fmt:message key="inbox.empty"/></p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="messages-table">
                <table>
                    <thead>
                        <tr>
                            <th><fmt:message key="table.title"/></th>
                            <th><fmt:message key="table.status"/></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="m" items="${messages}">
                        <tr>
                            <td>
                                <div class="message-title">${m.title}</div>
                                <div class="message-content">${m.content}</div>
                            </td>
                            <td>
                                <span class="message-status ${m.isRead ? 'status-read' : 'status-unread'}">
                                    <c:choose>
                                        <c:when test="${m.isRead}">Read</c:when>
                                        <c:otherwise>Unread</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="message-actions">
                                <c:if test="${!m.isRead}">
                                    <form action="${pageContext.request.contextPath}/inbox" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${m.id}" />
                                        <input type="hidden" name="action" value="markRead" />
                                        <button type="submit" class="mark-read-btn">
                                            <fmt:message key="inbox.markRead"/>
                                        </button>
                                    </form>
                                </c:if>
                                <form action="${pageContext.request.contextPath}/inbox" method="post" style="display:inline; margin-left:8px;">
                                    <input type="hidden" name="id" value="${m.id}" />
                                    <input type="hidden" name="action" value="delete" />
                                    <button type="submit" class="mark-read-btn" style="background: var(--danger-color);">
                                        <fmt:message key="notifications.delete"/>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>
