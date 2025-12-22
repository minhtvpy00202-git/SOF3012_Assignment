<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.poly.oe.dao.NotificationDAO" %>
<%@ page import="com.poly.oe.dao.UserMessageDAO" %>
<%@ page import="com.poly.oe.entity.User" %>

<%-- 
    Topbar Component - Reusable for both Customer and Admin
    Parameters:
    - isAdmin: true for admin layout, false for customer layout
--%>

<c:set var="isAdmin" value="${param.isAdmin == 'true'}" />
<fmt:message key="notifications.empty" var="notifEmptyTopbar"/>

<div class="${isAdmin ? 'admin-top-bar' : 'top-bar'}">
    <div style="display: flex; align-items: center; gap: 12px;">
        <img src="${pageContext.request.contextPath}/assets/images/Logo.png" alt="Logo" class="site-logo">
        <span>
            <fmt:message key="app.title"/>
            <c:if test="${isAdmin}"> - Admin</c:if>
        </span>
    </div>
    <div style="display: flex; gap: 10px; align-items: center;">
        <%
            User cu = (User) (session != null ? session.getAttribute("currentUser") : null);
            long unreadNoti = 0;
            long unreadMsg = 0;
            if (cu != null) {
                try { unreadNoti = new NotificationDAO().countUnread(cu.getId()); } catch (Exception ignored) {}
                try { unreadMsg = new UserMessageDAO().countUnread(cu.getId()); } catch (Exception ignored) {}
            }
            long unreadTotal = unreadNoti + unreadMsg;
        %>
        <c:if test="${isAdmin}">
            <div id="bellWrap" style="position: relative;">
                <button id="bellBtn" type="button" style="background:none;border:none;cursor:pointer;position:relative;">
                    <span style="font-size: 20px;">🔔</span>
                    <% if (unreadTotal > 0) { %>
                    <span id="bellBadge" style="position:absolute; top:-6px; right:-10px; background:red; color:#fff; border-radius:10px; padding:0 6px; font-size:12px;">
                        <%= unreadTotal %>
                    </span>
                    <% } else { %>
                    <span id="bellBadge" style="position:absolute; top:-6px; right:-10px; background:red; color:#fff; border-radius:10px; padding:0 6px; font-size:12px; display:none;">
                        <%= unreadTotal %>
                    </span>
                    <% } %>
                </button>
                <div id="bellDropdown" style="display:none; position:absolute; right:0; top:28px; width:360px; max-height:480px; overflow:auto; background:#fff; color:#000; border:1px solid #ddd; border-radius:8px; box-shadow:0 8px 28px rgba(0,0,0,.25); z-index:9999;">
                    <div style="padding:10px; border-bottom:1px solid #eee; font-weight:600;">
                        <fmt:message key="notifications.title"/>
                    </div>
                    <div id="bellList" style="padding:8px;"></div>
                    <div style="padding:8px; border-top:1px solid #eee; text-align:right;">
                        <a href="${pageContext.request.contextPath}/notifications" style="text-decoration:none;">Xem tất cả</a>
                    </div>
                </div>
            </div>
        </c:if>
        <div class="${isAdmin ? 'admin-theme-toggle' : 'theme-toggle'}">
            <button id="${isAdmin ? 'adminThemeToggle' : 'themeToggle'}" type="button">🌙 Dark</button>
        </div>
        <div class="lang-switch">
            <a href="#" data-lang="en">EN</a> | <a href="#" data-lang="vi">VI</a>
        </div>
    </div>
</div>
<c:if test="${isAdmin}">
    <script>
    (function(){
        var btn = document.getElementById('bellBtn');
        var dd = document.getElementById('bellDropdown');
        var badge = document.getElementById('bellBadge');
        var list = document.getElementById('bellList');
        function toggle(){
            dd.style.display = dd.style.display === 'block' ? 'none' : 'block';
        }
        function close(e){
            if(!dd.contains(e.target) && !btn.contains(e.target)){
                dd.style.display = 'none';
            }
        }
        function itemHtml(it){
            var title = (it.title || '');
            var content = (it.content || '');
            var readDot = it.isRead ? '' : '<span style="display:inline-block;width:8px;height:8px;background:#1a73e8;border-radius:50%;margin-right:6px;"></span>';
            var url = it.targetUrl || '';
            return '<div style="display:flex;gap:8px;padding:8px;border-bottom:1px solid #f0f0f0;">'
                 +   '<div style="flex:1;">'
                 +     '<div style="display:flex;align-items:center;">'+ readDot + '<a href="'+ url +'" style="color:#000;text-decoration:none;">'+ title +'</a></div>'
                 +     '<div style="font-size:12px;color:#666;margin-top:4px;">'+ content +'</div>'
                 +   '</div>'
                 + '</div>';
        }
        function load(){
            fetch('${pageContext.request.contextPath}/notifications-feed', { method: 'GET' })
            .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
            .then(function(data){
                list.innerHTML = '';
                if(!data.items || data.items.length === 0){
                    list.innerHTML = '<div style="padding:12px;color:#666;">' + '${notifEmptyTopbar}' + '</div>';
                }else{
                    data.items.forEach(function(it){ list.insertAdjacentHTML('beforeend', itemHtml(it)); });
                }
                fetch('${pageContext.request.contextPath}/notifications-feed/mark-all', { method: 'POST' }).catch(function(){});
                badge.style.display = 'none';
                badge.textContent = '';
            }).catch(function(){
                list.innerHTML = '<div style="padding:12px;color:#c00;">Không tải được thông báo.</div>';
            });
        }
        if(btn){
            btn.addEventListener('click', function(){
                toggle();
                if(dd.style.display === 'block'){
                    load();
                }
            });
            document.addEventListener('click', close);
        }
    })();
    </script>
</c:if>
