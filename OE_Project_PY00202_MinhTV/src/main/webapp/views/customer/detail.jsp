<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
                <h2><fmt:message key="detail.description"/></h2>
                <p>${video.description}</p>
                <p><fmt:message key="detail.views"/> ${video.views}</p>
            </div>

            <div class="detail-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <c:choose>
                            <c:when test="${videoLikedByMe}">
                                <form action="${pageContext.request.contextPath}/video/unlike" method="post" style="display:inline;">
                                    <input type="hidden" name="videoId" value="${video.id}">
                                    <button class="btn-like"><fmt:message key="action.unlike"/></button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/video/like" method="post" style="display:inline;">
                                    <input type="hidden" name="videoId" value="${video.id}">
                                    <button class="btn-like"><fmt:message key="action.like"/></button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <a class="btn-like" href="${pageContext.request.contextPath}/login"><fmt:message key="action.like"/></a>
                    </c:otherwise>
                </c:choose>

                <form action="${pageContext.request.contextPath}/video/share" method="get" style="display:inline;">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <button class="btn-share"><fmt:message key="action.share"/></button>
                </form>
            </div>

            <!-- BÌNH LUẬN -->
            <div class="detail-title-bar" style="margin-top:16px;"><fmt:message key="detail.comments"/></div>

            <div class="comment-form" style="padding: 20px; background: var(--comment-bg); border-radius: 8px; margin-top: 16px;">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <form action="${pageContext.request.contextPath}/comment/add" method="post" style="width: 100%;">
                            <input type="hidden" name="videoId" value="${video.id}" />
                            <div style="width: 100%;">
                                <textarea name="content" rows="4" style="width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 8px; background: var(--input-bg); color: var(--text-primary); font-family: inherit; font-size: 14px; resize: vertical; box-sizing: border-box;"></textarea>
                            </div>
                            <div style="text-align:right; margin-top:12px;">
                                <button type="submit" style="background: var(--accent-color); color: var(--button-text); border: none; padding: 8px 16px; border-radius: 18px; font-size: 13px; font-weight: 500; cursor: pointer;">
                                    <fmt:message key="comment.post"/>
                                </button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div><fmt:message key="comment.loginToComment"/></div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="commentsList">
            <c:forEach var="cmt" items="${comments}">
                <div class="comment-item">
                    <div class="comment-author">
                        @<c:choose>
                            <c:when test="${not empty cmt.user.fullname}">${cmt.user.fullname}</c:when>
                            <c:otherwise>${cmt.user.id}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="comment-content">${cmt.content}</div>
                    <div class="comment-translate-suggest" data-status="pending"></div>
                    <div class="comment-actions">
                        <div class="like-section">
                            <form action="${pageContext.request.contextPath}/comment/like" method="post" style="display:inline;">
                                <input type="hidden" name="commentId" value="${cmt.id}" />
                                <input type="hidden" name="videoId" value="${video.id}" />
                                <button class="btn-like" type="submit">
                                    👍 <c:choose>
                                        <c:when test="${commentLikedByMe[cmt.id]}">Unlike</c:when>
                                        <c:otherwise>Like</c:otherwise>
                                    </c:choose>
                                </button>
                            </form>
                            <span class="like-count">${commentLikeCounts[cmt.id]}</span>
                        </div>
                        <c:if test="${not empty sessionScope.currentUser}">
                            <button class="reply-btn" onclick="toggleReplyForm('reply-form-${cmt.id}')">
                                Phản hồi
                            </button>
                        </c:if>
                    </div>

                    <c:set var="repCount" value="${fn:length(cmt.replies)}" />
                    <c:if test="${repCount > 0}">
                        <fmt:message key="replies.countTemplate" var="repTpl"/>
                        <c:set var="repText" value="${fn:replace(repTpl, '{COUNT}', repCount)}" />
                        <div class="comment-replies-toggle">
                            <a href="#" class="replies-toggle"
                               data-target="replies-${cmt.id}"
                               data-count="${repCount}"
                               data-hide-text="<fmt:message key='replies.hide'/>"
                               data-count-template="${repTpl}">${repText}</a>
                        </div>
                    </c:if>

                    <!-- form trả lời -->
                    <c:if test="${not empty sessionScope.currentUser}">
                        <div id="reply-form-${cmt.id}" class="reply-form">
                            <form action="${pageContext.request.contextPath}/comment/reply" method="post" style="width: 100%;">
                                <input type="hidden" name="parentId" value="${cmt.id}" />
                                <div style="display: flex; gap: 8px; align-items: flex-end; width: 100%; margin-top: 8px;">
                                    <input type="text" name="content" style="flex: 1; padding:8px 12px; box-sizing:border-box; border:1px solid var(--border-color); border-radius:20px; background:var(--input-bg); color:var(--text-primary); font-size: 14px;" placeholder="Thêm phản hồi..." />
                                    <button type="submit" style="background: none; border: none; color: var(--accent-color); font-weight: 500; cursor: pointer; padding: 8px 12px; border-radius: 18px; font-size: 13px;">Phản hồi</button>
                                    <button type="button" onclick="toggleReplyForm('reply-form-${cmt.id}')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer; padding: 8px 12px; border-radius: 18px; font-size: 13px;">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <!-- danh sách trả lời (ẩn mặc định, bấm để hiện) -->
                    <div id="replies-${cmt.id}" class="replies-box" style="display:none;">
                        <c:forEach var="rep" items="${cmt.replies}">
                            <div class="comment-reply">
                                <div class="comment-author">
                                    @<c:choose>
                                        <c:when test="${not empty rep.user.fullname}">${rep.user.fullname}</c:when>
                                        <c:otherwise>${rep.user.id}</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="comment-content">${rep.content}</div>
                                <div class="comment-translate-suggest" data-status="pending"></div>
                                <div class="comment-actions">
                                    <div class="like-section">
                                        <form action="${pageContext.request.contextPath}/comment/like" method="post" style="display:inline;">
                                            <input type="hidden" name="commentId" value="${rep.id}" />
                                            <input type="hidden" name="videoId" value="${video.id}" />
                                            <button class="btn-like" type="submit">
                                                👍 <c:choose>
                                                    <c:when test="${commentLikedByMe[rep.id]}">Unlike</c:when>
                                                    <c:otherwise>Like</c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                        <span class="like-count">${commentLikeCounts[rep.id]}</span>
                                    </div>
                                    <c:if test="${not empty sessionScope.currentUser}">
                                        <button class="reply-btn" onclick="toggleReplyForm('reply-form-${rep.id}')">
                                            Phản hồi
                                        </button>
                                    </c:if>
                                </div>
                                
                                <!-- form trả lời cho reply -->
                                <c:if test="${not empty sessionScope.currentUser}">
                                    <div id="reply-form-${rep.id}" class="reply-form">
                                        <form action="${pageContext.request.contextPath}/comment/reply" method="post" style="width: 100%;">
                                            <input type="hidden" name="parentId" value="${cmt.id}" />
                                            <div style="display: flex; gap: 8px; align-items: flex-end; width: 100%; margin-top: 8px;">
                                                <input type="text" name="content" style="flex: 1; padding:8px 12px; box-sizing:border-box; border:1px solid var(--border-color); border-radius:20px; background:var(--input-bg); color:var(--text-primary); font-size: 14px;" placeholder="Thêm phản hồi..." />
                                                <button type="submit" style="background: none; border: none; color: var(--accent-color); font-weight: 500; cursor: pointer; padding: 8px 12px; border-radius: 18px; font-size: 13px;">Phản hồi</button>
                                                <button type="button" onclick="toggleReplyForm('reply-form-${rep.id}')" style="background: none; border: none; color: var(--text-secondary); cursor: pointer; padding: 8px 12px; border-radius: 18px; font-size: 13px;">Hủy</button>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
            </div>

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

<script>
    (function(){
        document.addEventListener('click', function(e){
            var t = e.target;
            if(t && t.classList && t.classList.contains('replies-toggle')){
                e.preventDefault();
                var targetId = t.getAttribute('data-target');
                var box = document.getElementById(targetId);
                if(box){
                    var isHidden = box.style.display === 'none' || box.style.display === '';
                    box.style.display = isHidden ? 'block' : 'none';
                    var count = t.getAttribute('data-count');
                    var hideText = t.getAttribute('data-hide-text') || 'Hide replies';
                    var tpl = t.getAttribute('data-count-template') || '{COUNT} replies';
                    t.textContent = isHidden ? hideText : tpl.replace('{COUNT}', count);
                }
            }
        });
    })();
    (function(){
        document.addEventListener('submit', function(e){
            var form = e.target;
            if(!form || !form.getAttribute) return;
            var action = form.getAttribute('action') || '';
            if(action.endsWith('/comment/add')){
                e.preventDefault();
                var fd = new URLSearchParams(new FormData(form));
                fetch(action, { method: 'POST', headers: { 'Accept': 'application/json', 'X-Requested-With': 'fetch' }, body: fd })
                    .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
                    .then(function(data){
                        var list = document.getElementById('commentsList');
                        if(!list) return;
                        var html = ''
                          + '<div class="comment-item">'
                          +   '<div class="comment-author">@' + (data.userName || '') + '</div>'
                          +   '<div class="comment-content">' + (data.content || '') + '</div>'
                          +   '<div class="comment-translate-suggest" data-status="pending"></div>'
                          +   '<div class="comment-actions">'
                          +     '<div class="like-section">'
                          +       '<form action="' + ('${pageContext.request.contextPath}/comment/like') + '" method="post" style="display:inline;">'
                          +         '<input type="hidden" name="commentId" value="' + data.id + '"/>'
                          +         '<input type="hidden" name="videoId" value="' + (data.videoId || '') + '"/>'
                          +         '<button class="btn-like" type="submit" style="padding:4px 12px; font-size:12px;">👍 Like</button>'
                          +       '</form>'
                          +       '<span class="like-count">' + (data.likeCount || 0) + '</span>'
                          +     '</div>'
                          +   '</div>'
                          +   '<div class="comment-replies-toggle"></div>'
                          +   '<div id="replies-' + data.id + '" class="replies-box" style="display:none;"></div>'
                          + '</div>';
                        list.insertAdjacentHTML('afterbegin', html);
                        form.reset();
                        if (typeof runTranslationSuggestions === 'function') { runTranslationSuggestions(); }
                    });
            } else if(action.endsWith('/comment/reply')){
                e.preventDefault();
                var fd2 = new URLSearchParams(new FormData(form));
                fetch(action, { method: 'POST', headers: { 'Accept': 'application/json', 'X-Requested-With': 'fetch' }, body: fd2 })
                    .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
                    .then(function(data){
                        var box = document.getElementById('replies-' + data.parentId);
                        if(!box) return;
                        var html = ''
                          + '<div class="comment-reply">'
                          +   '<div class="comment-author">@' + (data.userName || '') + '</div>'
                          +   '<div class="comment-content">' + (data.content || '') + '</div>'
                          +   '<div class="comment-translate-suggest" data-status="pending"></div>'
                          +   '<div class="comment-actions">'
                          +     '<div class="like-section">'
                          +       '<form action="' + ('${pageContext.request.contextPath}/comment/like') + '" method="post" style="display:inline;">'
                          +         '<input type="hidden" name="commentId" value="' + (data.id || '') + '"/>'
                          +         '<input type="hidden" name="videoId" value="' + (data.videoId || '') + '"/>'
                          +         '<button class="btn-like" type="submit" style="padding:4px 12px; font-size:12px;">👍 Like</button>'
                          +       '</form>'
                          +       '<span class="like-count">' + (data.likeCount || 0) + '</span>'
                          +     '</div>'
                          +   '</div>'
                          + '</div>';
                        box.insertAdjacentHTML('beforeend', html);
                        box.style.display = 'block';
                        form.reset();
                        if (typeof runTranslationSuggestions === 'function') { runTranslationSuggestions(); }
                    });
            } else if(action.endsWith('/comment/like')){
                e.preventDefault();
                var fd3 = new URLSearchParams(new FormData(form));
                fetch(action, { method: 'POST', headers: { 'Accept': 'application/json', 'X-Requested-With': 'fetch' }, body: fd3 })
                    .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
                    .then(function(data){
                        var btn = form.querySelector('button');
                        var span = form.parentElement && form.parentElement.querySelector('.like-count');
                        if(btn){ btn.textContent = '👍 ' + (data.liked ? 'Unlike' : 'Like'); }
                        if(span){ span.textContent = (data.likeCount || 0); }
                    });
            } else if(action.endsWith('/video/like') || action.endsWith('/video/unlike')){
                e.preventDefault();
                var fd4 = new URLSearchParams(new FormData(form));
                fetch(action, { method: 'POST', headers: { 'Accept': 'application/json', 'X-Requested-With': 'fetch' }, body: fd4 })
                    .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
                    .then(function(data){
                        var btn = form.querySelector('button');
                        if(!btn) return;
                        if(data.liked){
                            form.setAttribute('action', '${pageContext.request.contextPath}/video/unlike');
                            btn.textContent = '<fmt:message key="action.unlike"/>';
                        } else {
                            form.setAttribute('action', '${pageContext.request.contextPath}/video/like');
                            btn.textContent = '<fmt:message key="action.like"/>';
                        }
                    });
            }
        });
    })();
</script>

<script>
function toggleReplyForm(formId) {
    var form = document.getElementById(formId);
    if (form) {
        if (form.classList.contains('active')) {
            form.classList.remove('active');
        } else {
            // Hide all other reply forms
            var allForms = document.querySelectorAll('.reply-form.active');
            allForms.forEach(function(f) {
                f.classList.remove('active');
            });
            // Show this form
            form.classList.add('active');
            // Focus on input
            var input = form.querySelector('input[name="content"]');
            if (input) {
                input.focus();
            }
        }
    }
}
</script>
<script>
    window.I18N_TRANSLATE_SHOW = '<fmt:message key="translate.show"/>';
    window.I18N_TRANSLATE_HIDE = '<fmt:message key="translate.hide"/>';
    window.I18N_TRANSLATE_DETECTED = '<fmt:message key="translate.detected"/>';
</script>

<script>
    (function(){
        var currentLang = '${sessionScope.siteLang != null ? sessionScope.siteLang : "vi"}';
        var ctx = '${pageContext.request.contextPath}';
        function label(lang){
            const map = {
                vi: 'Vietnamese',
                en: 'English',
                fr: 'French',
                pt: 'Portuguese',
                es: 'Spanish',
                it: 'Italian',
                de: 'German',
                ja: 'Japanese',
                ko: 'Korean',
                zh: 'Chinese',
                ar: 'Arabic',
                ru: 'Russian',
                hi: 'Hindi'
            };
            return map[lang] || lang || '';
        }
        function build(container, data){
            if(!data || !data.suggestTranslation){
                container.setAttribute('data-status','done');
                container.style.display='none';
                return;
            }

            var wrap = container.closest('.comment-item, .comment-reply');
            if(!wrap) return;

            var contentEl = wrap.querySelector('.comment-content');
            if(!contentEl) return;

            // Lưu nội dung gốc (chỉ 1 lần)
            if(!contentEl.dataset.original){
                contentEl.dataset.original = contentEl.textContent;
            }

            // ===== dòng hiển thị =====
            var line = document.createElement('div');
            line.style.display = 'flex';
            line.style.alignItems = 'center';
            line.style.gap = '8px';
            line.style.marginTop = '4px';

            // Phát hiện ngôn ngữ
            var info = document.createElement('span');
            info.textContent = window.I18N_TRANSLATE_DETECTED + ': ' + label(data.detectedLang);
            info.style.fontSize = '12px';
            info.style.color = '#888';
            info.style.fontWeight = '400';

            // Link dịch / ẩn
            var a = document.createElement('a');
            a.href = '#';
            a.textContent = window.I18N_TRANSLATE_SHOW;
            a.style.fontSize = '12px';
            a.style.fontWeight = '600';
            a.style.color = '#0448BB';
            a.style.textDecoration = 'none';
            a.style.cursor = 'pointer';

            var showing = false;

            a.addEventListener('click', function(e){
                e.preventDefault();
                showing = !showing;

                contentEl.textContent = showing
                    ? data.translation
                    : contentEl.dataset.original;

                a.textContent = showing
                    ? window.I18N_TRANSLATE_HIDE
                    : window.I18N_TRANSLATE_SHOW;
            });

            line.appendChild(info);
            line.appendChild(a);

            container.innerHTML = '';
            container.appendChild(line);
            container.setAttribute('data-status','done');
        }



        function process(container){
        // ===== Hiển thị ngay trạng thái đang xử lý =====
        container.innerHTML =
          '<span style="font-size:12px;color:#aaa;">Detecting language...</span>';
        container.style.display = 'block';

            if(!container) return;
            var wrap = container.closest('.comment-item, .comment-reply');
            var contentEl = wrap ? wrap.querySelector('.comment-content') : null;
            var text = contentEl ? contentEl.textContent : '';
            if(!text || !text.trim()) { container.setAttribute('data-status','done'); container.style.display='none'; return; }
            var fd = new URLSearchParams();
            fd.append('content', text);
            fd.append('targetLang', currentLang);
            fetch(ctx + '/translation/suggest', { method: 'POST', headers: { 'Accept': 'application/json', 'X-Requested-With': 'fetch' }, body: fd })
                .then(function(r){ return r.ok ? r.json() : Promise.reject(r.status); })
                .then(function(data){ build(container, data); })
                .catch(function(){ container.setAttribute('data-status','done'); container.style.display='none'; });
        }
        window.runTranslationSuggestions = function(){
            var nodes = document.querySelectorAll('.comment-translate-suggest[data-status="pending"]');
            nodes.forEach(function(n){ process(n); });
        };
        document.addEventListener('DOMContentLoaded', function(){ runTranslationSuggestions(); });
    })();
</script>
