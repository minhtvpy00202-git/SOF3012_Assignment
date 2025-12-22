<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .messages-container {
        max-width: 800px;
        margin: 0 auto;
    }
    
    .messages-title {
        font-size: 24px;
        font-weight: 500;
        margin-bottom: 24px;
        color: var(--text-primary);
    }
    
    .messages-form {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 24px;
        margin-bottom: 20px;
    }
    
    .messages-form-row {
        margin-bottom: 20px;
    }
    
    .messages-form-row label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
        color: var(--text-primary);
        font-size: 14px;
    }
    
    .messages-form-row input[type="text"],
    .messages-form-row textarea {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid var(--input-border);
        border-radius: 8px;
        background: var(--input-bg);
        color: var(--text-primary);
        font-size: 14px;
        font-family: inherit;
        box-sizing: border-box;
    }
    
    .messages-form-row input:focus,
    .messages-form-row textarea:focus {
        outline: none;
        border-color: var(--accent-color);
    }
    
    .messages-form-row textarea {
        resize: vertical;
        min-height: 120px;
    }
    
    .checkbox-label {
        display: flex !important;
        align-items: center;
        gap: 8px;
        font-weight: 400 !important;
        margin-bottom: 16px !important;
    }
    
    .checkbox-label input[type="checkbox"] {
        width: 18px;
        height: 18px;
    }
    
    .users-selection {
        margin-top: 16px;
    }
    
    .users-selection > div:first-child {
        font-weight: 500;
        color: var(--text-primary);
        margin-bottom: 12px;
    }
    
    .users-list {
        max-height: 280px;
        overflow: auto;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        padding: 16px;
        background: var(--input-bg);
    }
    
    .user-item {
        display: flex !important;
        align-items: center;
        gap: 8px;
        margin-bottom: 8px;
        padding: 4px 0;
    }
    
    .user-item input[type="checkbox"] {
        width: 16px;
        height: 16px;
    }
    
    .pagination {
        margin-top: 12px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 14px;
        color: var(--text-secondary);
    }
    
    .pagination a {
        color: var(--accent-color);
        text-decoration: none;
        padding: 4px 8px;
        border-radius: 4px;
        transition: background 0.2s ease;
    }
    
    .pagination a:hover {
        background: var(--bg-hover);
    }
    
    .pagination a.disabled {
        color: var(--text-secondary);
        opacity: 0.5;
        pointer-events: none;
    }
    
    .submit-button {
        background: var(--button-bg);
        color: var(--button-text);
        border: none;
        padding: 12px 24px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    
    .submit-button:hover {
        opacity: 0.9;
    }
    
    .messages-note {
        font-size: 13px;
        color: var(--text-secondary);
        margin-top: 16px;
        padding: 12px;
        background: var(--bg-hover);
        border-radius: 8px;
        border-left: 4px solid var(--accent-color);
    }
    
    .alert {
        padding: 12px 16px;
        margin-bottom: 20px;
        border-radius: 8px;
        font-size: 14px;
        background: #f0fdf4;
        color: #15803d;
        border: 1px solid #15803d;
    }
    
    body[data-theme="dark"] .alert {
        background: #1a3a1a;
        color: #4ade80;
        border-color: #4ade80;
    }
</style>

<div class="messages-container">
    <h1 class="messages-title"><fmt:message key="admin.messages.title"/></h1>
    
    <c:if test="${not empty message}">
        <div class="alert">${message}</div>
    </c:if>
    
    <div class="messages-form">
        <form action="${pageContext.request.contextPath}/admin/messages" method="post">
            <div class="messages-form-row">
                <label><fmt:message key="admin.messages.titleField"/></label>
                <input type="text" name="title" placeholder="Nhập tiêu đề tin nhắn..." />
            </div>
            
            <div class="messages-form-row">
                <label><fmt:message key="admin.messages.contentField"/></label>
                <textarea name="content" rows="5" placeholder="Nhập nội dung tin nhắn..."></textarea>
            </div>
            
            <div class="messages-form-row">
                <label class="checkbox-label">
                    <input type="checkbox" name="sendAll" />
                    <fmt:message key="admin.messages.sendAll"/>
                </label>
            </div>
            
            <div class="users-selection">
                <div><fmt:message key="admin.messages.selectUsers"/></div>
                <div class="users-list">
                    <c:forEach var="u" items="${users}">
                        <label class="user-item">
                            <input type="checkbox" name="userIds" value="${u.id}" />
                            ${u.fullname != null && u.fullname != '' ? u.fullname : u.id}
                        </label>
                    </c:forEach>
                </div>
                
                <c:if test="${totalPage > 1}">
                    <div class="pagination">
                        <span>Page: ${currentPage} / ${totalPage}</span>
                        <a href="${pageContext.request.contextPath}/admin/messages?page=${currentPage - 1}" 
                           class="${currentPage <= 1 ? 'disabled' : ''}">Prev</a>
                        <a href="${pageContext.request.contextPath}/admin/messages?page=${currentPage + 1}" 
                           class="${currentPage >= totalPage ? 'disabled' : ''}">Next</a>
                    </div>
                </c:if>
            </div>
            
            <div class="messages-form-row">
                <button type="submit" class="submit-button">
                    <fmt:message key="admin.messages.submit"/>
                </button>
            </div>
        </form>
        
        <div class="messages-note">
            Nếu chọn "Gửi tất cả", hệ thống sẽ bỏ qua danh sách người dùng đã chọn.
        </div>
    </div>
</div>
