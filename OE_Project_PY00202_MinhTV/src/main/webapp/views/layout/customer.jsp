<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.poly.oe.dao.NotificationDAO" %>
<%@ page import="com.poly.oe.dao.UserMessageDAO" %>
<%@ page import="com.poly.oe.entity.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon"
          href="${pageContext.request.contextPath}/assets/images/favicon.ico">

    <title>OE Online Entertainment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/youtube-style.css">
</head>
<body data-theme="light">

<c:if test="${not empty param.lang}">
    <c:set var="siteLang" value="${param.lang}" scope="session" />
    </c:if>
<fmt:setLocale value="${sessionScope.siteLang != null ? sessionScope.siteLang : 'vi'}" scope="request" />
<fmt:setBundle basename="messages" scope="request" />
<fmt:message key="notifications.empty" var="notifEmpty"/>
<fmt:message key="action.like" var="likeText"/>
<fmt:message key="action.unlike" var="unlikeText"/>

<jsp:include page="topbar.jsp">
    <jsp:param name="isAdmin" value="false" />
</jsp:include>

<div class="menu">
    <a href="${pageContext.request.contextPath}/home"><fmt:message key="menu.home"/></a>
    <a href="${pageContext.request.contextPath}/my-favorites"><fmt:message key="menu.favorites"/></a>
    <a href="${pageContext.request.contextPath}/watched-videos"><fmt:message key="menu.watched"/></a>

    

    <!-- Khu My Account (tùy theo đã đăng nhập hay chưa) -->
    <c:choose>
        <c:when test="${not empty sessionScope.currentUser}">
            <!-- đã login -->
            <c:if test="${sessionScope.currentUser.admin}">
                <a href="${pageContext.request.contextPath}/admin/home"><fmt:message key="menu.adminDashboard"/></a>
            </c:if>
            <span class="dropdown">
                <span class="dropdown-toggle"><fmt:message key="menu.account"/></span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/account/edit-profile"><fmt:message key="account.editProfile"/></a>
                    <a href="${pageContext.request.contextPath}/account/change-password"><fmt:message key="account.changePassword"/></a>
                    <a href="${pageContext.request.contextPath}/inbox"><fmt:message key="menu.inbox"/></a>
                    <a href="${pageContext.request.contextPath}/account/logoff"><fmt:message key="account.logoff"/></a>
                </div>
            </span>
            <span class="right greet">
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
                <div id="bellWrap" style="position: relative; display:inline-block; margin-right:10px;">
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
                <fmt:message key="greet.loggedInPrefix"/> <b style="color: red;"> ${sessionScope.currentUser.fullname != null && sessionScope.currentUser.fullname != '' ? sessionScope.currentUser.fullname : sessionScope.currentUser.id} </b>
                <a href="${pageContext.request.contextPath}/account/logoff" style="color: white; background-color:red; margin-left: 10px; padding: 6px 10px; border-radius:6px;"><fmt:message key="account.logoff"/></a>
            </span>
        </c:when>
        <c:otherwise>
            <!-- chưa login -->
            <span class="dropdown">
                <span class="dropdown-toggle"><fmt:message key="menu.account"/></span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/login"><fmt:message key="account.login"/></a>
                    <a href="${pageContext.request.contextPath}/account/forgot-password"><fmt:message key="account.forgotPassword"/></a>
                    <a href="${pageContext.request.contextPath}/account/registration"><fmt:message key="account.registration"/></a>
                </div>
            </span>
            <span class="right greet"><fmt:message key="greet.guest"/><a style="color: white; background-color:red; margin-left: 10px;" href="${pageContext.request.contextPath}/login"><fmt:message key="account.login"/></a></span>

        </c:otherwise>
    </c:choose>
</div>

<c:if test="${empty hideSearch}">
    <div class="searchbar">
        <div class="searchbar-inner">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" name="q" value="${fn:escapeXml(param.q)}" placeholder="<fmt:message key='search.placeholder'/>" />
                <button type="submit"><fmt:message key="search.button"/></button>
            </form>
        </div>
    </div>
</c:if>




<div class="container">
    <!-- NỘI DUNG TỪ TRANG CON -->
    <jsp:include page="${view}" />
</div>

    <!-- Chatbot widget -->
    <style>
        .chatbot-toggle { position: fixed; right: 20px; bottom: 20px; z-index: 9999; padding: 10px 14px; border: none; border-radius: 20px; background: #cc0000; color: #fff; cursor: pointer; box-shadow: 0 2px 6px rgba(0,0,0,0.2); }
        .chatbot-panel { position: fixed; right: 20px; bottom: 70px; width: 320px; max-height: 430px; height:430px; background: #fff; color: #000; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 4px 18px rgba(0,0,0,0.25); display: none; flex-direction: column; overflow: hidden; z-index: 9999; }
        .chatbot-header { padding: 10px; background: #202020; color: #fff; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
        .chatbot-messages { padding: 10px; overflow-y: auto; flex: 1; background: #fafafa; }
        .chatbot-input { display: flex; border-top: 1px solid #eee; }
        .chatbot-input input { flex: 1; padding: 8px; border: none; outline: none; }
        .chatbot-input button { padding: 8px 12px; border: none; background: #cc0000; color: #fff; cursor: pointer; }
        .msg { margin: 6px 0; }
        .msg.me { text-align: right; }
        .msg.me span { display: inline-block; background: #e7f1ff; color: #003d99; padding: 6px 8px; border-radius: 12px; }
        .msg.bot span { display: inline-block; background: #f2f2f2; color: #222; padding: 6px 8px; border-radius: 12px; }
        [data-theme="dark"] .chatbot-panel { background: #1e1e1e; color: #ddd; border-color: #333; }
        [data-theme="dark"] .chatbot-header { background: #111; }
        [data-theme="dark"] .chatbot-messages { background: #151515; }
        [data-theme="dark"] .msg.bot span { background: #222; color: #ddd; }
        [data-theme="dark"] .msg.me span { background: #223; color: #cde; }
    </style>
    <button id="chatbotToggle" class="chatbot-toggle">Trợ lý</button>
    <div id="chatbotPanel" class="chatbot-panel">
        <div class="chatbot-header">
            <span>Trợ lý OE</span>
            <button id="chatbotClose" style="background:none;border:none;color:#fff;cursor:pointer">✕</button>
        </div>
        <div id="chatbotMessages" class="chatbot-messages"></div>
        <form id="chatbotForm" class="chatbot-input">
            <input id="chatbotInput" type="text" placeholder="Nhập câu hỏi..." autocomplete="off" />
            <button type="submit">Gửi</button>
        </form>
    </div>

</body>
<script>
    (function(){
        var t = localStorage.getItem('theme');
        if(!t){ t = 'light'; }
        document.body.setAttribute('data-theme', t);
        var btn = document.getElementById('themeToggle');
        if(btn){ 
            btn.textContent = t === 'dark' ? '☀️ Light' : '🌙 Dark';
            btn.addEventListener('click', function(){ 
                var nt = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark'; 
                document.body.setAttribute('data-theme', nt); 
                localStorage.setItem('theme', nt); 
                btn.textContent = nt === 'dark' ? '☀️ Light' : '🌙 Dark';
            }); 
        }
        var ls = document.querySelector('.lang-switch');
        if(ls){
            ls.addEventListener('click', function(e){
                var a = e.target.closest('a[data-lang]');
                if(!a) return;
                e.preventDefault();
                var lang = a.getAttribute('data-lang');
                var url = new URL(window.location.href);
                url.searchParams.set('lang', lang);
                window.location.assign(url.toString());
            });
        }
    })();

    (function(){
        var btn = document.getElementById('bellBtn');
        var dd = document.getElementById('bellDropdown');
        var badge = document.getElementById('bellBadge');
        var list = document.getElementById('bellList');
        function toggleBell(){
            dd.style.display = dd.style.display === 'block' ? 'none' : 'block';
        }
        function close(e){
            if(dd && btn && !dd.contains(e.target) && !btn.contains(e.target)){
                dd.style.display = 'none';
            }
        }
        function itemHtml(it){
            var title = (it.title || '');
            var content = (it.content || '');
            var readDot = it.isRead ? '' : '<span style=\"display:inline-block;width:8px;height:8px;background:#1a73e8;border-radius:50%;margin-right:6px;\"></span>';
            var url = it.targetUrl || '';
            return '<div style=\"display:flex;gap:8px;padding:8px;border-bottom:1px solid #f0f0f0;\">'
                 +   '<div style=\"flex:1;\">'
                 +     '<div style=\"display:flex;align-items:center;\">'+ readDot + '<a href=\"'+ url +'\" style=\"color:#000;text-decoration:none;\">'+ title +'</a></div>'
                 +     '<div style=\"font-size:12px;color:#666;margin-top:4px;\">'+ content +'</div>'
                 +   '</div>'
                 + '</div>';
        }
        function load(){
            fetch('${pageContext.request.contextPath}/notifications-feed', { method: 'GET' })
            .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
            .then(function(data){
                if(!list) return;
                list.innerHTML = '';
                if(!data.items || data.items.length === 0){
                    list.innerHTML = '<div style=\"padding:12px;color:#666;\">' + '${notifEmpty}' + '</div>';
                }else{
                    data.items.forEach(function(it){ list.insertAdjacentHTML('beforeend', itemHtml(it)); });
                }
                fetch('${pageContext.request.contextPath}/notifications-feed/mark-all', { method: 'POST' }).catch(function(){});
                if(badge){
                    badge.style.display = 'none';
                    badge.textContent = '';
                }
            }).catch(function(){
                if(list){
                    list.innerHTML = '<div style=\"padding:12px;color:#c00;\">Không tải được thông báo.</div>';
                }
            });
        }
        if(btn){
            btn.addEventListener('click', function(evt){
                if(evt && evt.stopPropagation) evt.stopPropagation();
                toggleBell();
                if(dd.style.display === 'block'){
                    load();
                }
            });
            document.addEventListener('click', close);
            if(dd){ dd.addEventListener('click', function(e){ if(e && e.stopPropagation) e.stopPropagation(); }); }
        }

        var chatbotToggle = document.getElementById('chatbotToggle');
        var panel = document.getElementById('chatbotPanel');
        var closeBtn = document.getElementById('chatbotClose');
        var form = document.getElementById('chatbotForm');
        var input = document.getElementById('chatbotInput');
        var messages = document.getElementById('chatbotMessages');

        function addMsg(cls, text){
            var div = document.createElement('div');
            div.className = 'msg ' + cls;
            var span = document.createElement('span');
            span.textContent = text;
            div.appendChild(span);
            messages.appendChild(div);
            messages.scrollTop = messages.scrollHeight;
        }

        function openPanel(){ panel.style.display = 'flex'; input.focus(); }
        function closePanel(){ panel.style.display = 'none'; }

        chatbotToggle.addEventListener('click', function(){
            if(panel.style.display === 'flex') closePanel(); else openPanel();
            if(messages.childElementCount === 0){
                addMsg('bot', 'Chào bạn! Mình là trợ lý OE. Mình có thể giúp bạn giải đáp thắc mắc về trang web này. Ngoài ra mình còn có thể trò chuyện vui vẻ cùng bạn nữa!');
            }
        });
        closeBtn.addEventListener('click', function(){ closePanel(); });

        form.addEventListener('submit', function(e){
            e.preventDefault();
            var text = (input.value || '').trim();
            if(!text) return;
            addMsg('me', text);
            input.value = '';
            fetch('${pageContext.request.contextPath}/chatbot', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: new URLSearchParams({ message: text }).toString()
            })
            .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
            .then(function(data){
                addMsg('bot', data.reply);
            })


            .catch(function(){ addMsg('bot', 'Không thể gửi yêu cầu. Vui lòng thử lại sau.'); });
        });
    })();
    (function(){
        document.addEventListener('submit', function(e){
            var form = e.target;
            if(!form || !form.getAttribute) return;
            var action = form.getAttribute('action') || '';
            var method = (form.getAttribute('method') || 'get').toLowerCase();
            if(method === 'post' && (action.endsWith('/video/like') || action.endsWith('/video/unlike'))){
                e.preventDefault();
                var fd = new URLSearchParams(new FormData(form));
                fetch(action, { method: 'POST', headers: { 'Accept': 'application/json', 'X-Requested-With': 'fetch' }, body: fd })
                    .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
                    .then(function(data){
                        var btn = form.querySelector('button');
                        if(!btn) return;
                        if(data.liked){
                            form.setAttribute('action', '${pageContext.request.contextPath}/video/unlike');
                            btn.textContent = '${unlikeText}';
                        } else {
                            form.setAttribute('action', '${pageContext.request.contextPath}/video/like');
                            btn.textContent = '${likeText}';
                        }
                    });
            }
        });
    })();
</script>
</html>
