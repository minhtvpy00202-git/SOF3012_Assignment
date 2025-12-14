<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OE Online Entertainment</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/youtube-style.css">
</head>
<body data-theme="light">

<c:if test="${not empty param.lang}">
    <c:set var="siteLang" value="${param.lang}" scope="session" />
    </c:if>
<fmt:setLocale value="${sessionScope.siteLang != null ? sessionScope.siteLang : 'vi'}" scope="request" />
<fmt:setBundle basename="messages" scope="request" />

<jsp:include page="topbar.jsp">
    <jsp:param name="isAdmin" value="false" />
</jsp:include>

<div class="menu">
    <a href="${pageContext.request.contextPath}/home"><fmt:message key="menu.home"/></a>
    <a href="${pageContext.request.contextPath}/my-favorites"><fmt:message key="menu.favorites"/></a>

    

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
                    <a href="${pageContext.request.contextPath}/account/logoff"><fmt:message key="account.logoff"/></a>
                </div>
            </span>
            <span class="right greet"><fmt:message key="greet.loggedInPrefix"/> <b style="color: red;"> ${sessionScope.currentUser.fullname != null && sessionScope.currentUser.fullname != '' ? sessionScope.currentUser.fullname : sessionScope.currentUser.id} </b></span>
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
        .chatbot-panel { position: fixed; right: 20px; bottom: 70px; width: 320px; max-height: 420px; background: #fff; color: #000; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 4px 18px rgba(0,0,0,0.25); display: none; flex-direction: column; overflow: hidden; z-index: 9999; }
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
        var toggle = document.getElementById('chatbotToggle');
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

        toggle.addEventListener('click', function(){
            if(panel.style.display === 'flex') closePanel(); else openPanel();
            if(messages.childElementCount === 0){
                addMsg('bot', 'Chào bạn! Mình là trợ lý OE. Hãy hỏi về tìm video, yêu thích, đăng nhập/đăng ký, quên mật khẩu hoặc đổi giao diện.');
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
                addMsg('bot', (data.source ? '[' + data.source + '] ' : '') + data.reply);
            })

            .catch(function(){ addMsg('bot', 'Không thể gửi yêu cầu. Vui lòng thử lại sau.'); });
        });
    })();
</script>
</html>
