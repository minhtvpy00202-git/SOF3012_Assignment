<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<c:if test="${empty editing}">
    <c:set var="editing" value="false" />
</c:if>


<%-- tab đang active: mặc định là edit, chỉ khi tab=list thì mới hiện list --%>
<c:set var="activeTab" value="edit" />
<c:if test="${param.tab == 'list'}">
    <c:set var="activeTab" value="list" />
</c:if>
<c:if test="${param.tab == 'deleted'}">
    <c:set var="activeTab" value="deleted" />
</c:if>
<c:if test="${param.action == 'edit'}">
    <c:set var="activeTab" value="edit" />
</c:if>

<style>
    /* Video Admin Wrapper - Use CSS Variables */
    .video-admin-wrapper {
        border: 1px solid var(--border-color);
        margin-top: 10px;
        background: var(--card-bg);
        border-radius: 8px;
        overflow: hidden;
    }
    .video-admin-tabs {
        display: flex;
        border-bottom: 2px solid var(--border-color);
        background: var(--input-bg);
    }
    .video-admin-tab {
        padding: 12px 24px;
        font-weight: 500;
        text-transform: uppercase;
        text-decoration: none;
        color: var(--text-secondary);
        background: transparent;
        border-bottom: 3px solid transparent;
        transition: all 0.2s ease;
        font-size: 14px;
    }
    .video-admin-tab:hover {
        color: var(--text-primary);
    }
    .video-admin-tab.active {
        background: var(--card-bg);
        color: var(--accent-color);
        border-bottom-color: var(--accent-color);
        font-weight: 600;
    }
    .video-admin-body {
        padding: 20px 24px;
        background: var(--card-bg);
    }
    .video-tab-pane {
        display: none;
    }
    .video-tab-pane.active {
        display: block;
    }

    /* Poster + Form Layout */
    .video-edit-layout {
        display: grid;
        grid-template-columns: 300px 1fr;
        gap: 24px;
    }
    .poster-panel {
        padding-top: 10px;
    }
    .poster-box {
        border: 2px solid var(--border-color);
        background: var(--input-bg);
        width: 100%;
        height: 220px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        color: var(--text-secondary);
        margin-bottom: 16px;
        border-radius: 8px;
    }
    .poster-box img {
        max-width: 100%;
        max-height: 100%;
        border-radius: 8px;
    }
    .poster-hidden {
        display: none;
    }
    
    .admin-form-row {
        margin-bottom: 16px;
    }
    .admin-form-row label {
        display: block;
        font-weight: 500;
        margin-bottom: 8px;
        color: var(--text-primary);
        font-size: 14px;
    }
    .admin-form-row input[type="text"],
    .admin-form-row input[type="number"],
    .admin-form-row input[type="file"],
    .admin-form-row textarea {
        border: 1px solid var(--input-border);
        border-radius: 8px;
        padding: 10px 12px;
        width: 100%;
        box-sizing: border-box;
        background: var(--input-bg);
        color: var(--text-primary);
        font-size: 14px;
    }
    .admin-form-row input:focus,
    .admin-form-row textarea:focus {
        outline: none;
        border-color: var(--accent-color);
    }
    .admin-form-row textarea {
        min-height: 100px;
        resize: vertical;
    }
    
    .admin-form-actions {
        margin-top: 20px;
        text-align: center;
        padding-top: 16px;
        border-top: 1px solid var(--border-color);
    }
    .btn-orange {
        background: var(--button-bg);
        color: var(--button-text);
        border: none;
        padding: 8px 20px;
        margin: 0 6px;
        font-weight: 500;
        cursor: pointer;
        border-radius: 8px;
        transition: all 0.2s ease;
    }
    .btn-orange:hover {
        opacity: 0.9;
    }
    .btn-orange:disabled {
        opacity: 0.4;
        cursor: not-allowed;
    }

    /* Pagination */
    .pagination {
        margin-top: 16px;
        text-align: left;
    }
    .pagination button {
        background: var(--bg-hover);
        border: 1px solid var(--border-color);
        color: var(--text-primary);
        padding: 6px 12px;
        margin-right: 4px;
        cursor: pointer;
        font-weight: 500;
        border-radius: 6px;
        transition: all 0.2s ease;
    }
    .pagination button:hover {
        background: var(--input-bg);
        border-color: var(--accent-color);
    }
</style>

<h1 class="admin-title"><fmt:message key="admin.videos.title"/></h1>

<div class="video-admin-wrapper">

    <!-- TAB HEADER -->
    <div class="video-admin-tabs">
        <a class="video-admin-tab ${activeTab == 'edit' ? 'active' : ''}"
           href="${ctx}/admin/videos?tab=edit">
            <fmt:message key="admin.videos.tab.edit"/>
        </a>
        <a class="video-admin-tab ${activeTab == 'list' ? 'active' : ''}"
           href="${ctx}/admin/videos?tab=list">
            <fmt:message key="admin.videos.tab.list"/>
        </a>
        <a class="video-admin-tab ${activeTab == 'deleted' ? 'active' : ''}"
           href="${ctx}/admin/videos?tab=deleted">
            <fmt:message key="admin.videos.tab.deleted"/>
        </a>
    </div>

    <div class="video-admin-body">

        <!-- messages -->
        <c:if test="${not empty message}">
            <div class="admin-message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="admin-message error">${error}</div>
        </c:if>

        <!-- TAB 1: EDITION -->
        <div class="video-tab-pane ${activeTab == 'edit' ? 'active' : ''}" id="tab-edit">

            <form action="${ctx}/admin/videos" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create" id="actionField"/>
                <input type="hidden" name="tab" value="edit"/>

                <div class="video-edit-layout">
                    <!-- poster -->
                    <div class="poster-panel">
                        <div class="poster-box">
                            <img id="posterPreview"
                                 src="${empty form.poster ? '' : ctx.concat('/').concat(form.poster)}"
                                 alt="${form.title}"
                                 class="${empty form.poster ? 'poster-hidden' : ''}"/>

                            <span id="posterPlaceholder"
                                  class="${empty form.poster ? '' : 'poster-hidden'}">
                                POSTER
                            </span>
                        </div>

                        <div class="admin-form-row">
                            <label><fmt:message key="admin.videos.choosePoster"/></label>
                            <input type="file" name="posterFile" accept="image/*"/>
                        </div>
                    </div>


                    <!-- form fields -->
                    <div class="video-form-panel">
                        <div class="admin-form-row">
                            <label><fmt:message key="admin.videos.field.id"/></label>
                            <input type="text" name="id" value="${form.id}"/>
                        </div>

                        <div class="admin-form-row">
                            <label><fmt:message key="admin.videos.field.title"/></label>
                            <input type="text" name="title" value="${form.title}"/>
                        </div>

                        <div class="admin-form-row">
                            <label><fmt:message key="admin.videos.field.views"/></label>
                            <input type="number" name="views"
                                   value="${form.views != null ? form.views : 0}"/>
                        </div>

                        <div class="admin-form-row">
                            <label><fmt:message key="table.status"/></label>
                            <label>
                                <input type="radio" name="active" value="true"
                                       ${form.active ? "checked" : ""}/> <fmt:message key="status.active"/>
                            </label>
                            <label style="margin-left:15px;">
                                <input type="radio" name="active" value="false"
                                       ${!form.active ? "checked" : ""}/> <fmt:message key="status.inactive"/>
                            </label>
                        </div>

                        <div class="admin-form-row">
                            <label><fmt:message key="admin.videos.field.href"/></label>
                            <input type="text" name="href" value="${form.href}"/>
                        </div>

                        <div class="admin-form-row">
                            <label><fmt:message key="admin.videos.field.description"/></label>
                            <textarea name="description" rows="4">${form.description}</textarea>
                        </div>

                        <div class="admin-form-actions">
                            <!-- Create -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='create'"
                                    <c:if test="${editing}">disabled</c:if>>
                                <fmt:message key="action.create"/>
                            </button>

                            <!-- Update -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='update'"
                                    <c:if test="${not editing}">disabled</c:if>>
                                <fmt:message key="action.update"/>
                            </button>

                            <!-- Delete -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='delete'"
                                    <c:if test="${not editing}">disabled</c:if>>
                                <fmt:message key="action.delete"/>
                            </button>

                            <!-- Reset -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='reset'">
                                <fmt:message key="action.reset"/>
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <script>
            (function () {
                const fileInput = document.querySelector('input[name="posterFile"]');
                const previewImg = document.getElementById('posterPreview');
                const placeholder = document.getElementById('posterPlaceholder');

                if (!fileInput || !previewImg) return;

                fileInput.addEventListener('change', function () {
                    const file = this.files && this.files[0];
                    if (!file) return;

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        previewImg.src = e.target.result;
                        previewImg.classList.remove('poster-hidden');
                        if (placeholder) {
                            placeholder.classList.add('poster-hidden');
                        }
                    };
                    reader.readAsDataURL(file);
                });
            })();
        </script>

        </div>

        <!-- TAB 2: LIST -->
        <div class="video-tab-pane ${activeTab == 'list' ? 'active' : ''}" id="tab-list">
            <h2 class="admin-subtitle"><fmt:message key="admin.videos.tab.list"/></h2>

            <table class="admin-table">
                <thead>
                <tr>
                    <th><fmt:message key="admin.videos.field.id"/></th>
                    <th><fmt:message key="admin.videos.field.title"/></th>
                    <th><fmt:message key="admin.videos.field.views"/></th>
                    <th><fmt:message key="table.status"/></th>
                    <th><fmt:message key="table.edit"/></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="v" items="${videos}">
                    <tr>
                        <td>${v.id}</td>
                        <td>${v.title}</td>
                        <td>${v.views}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.active}"><fmt:message key="status.active"/></c:when>
                                <c:otherwise><fmt:message key="status.inactive"/></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${ctx}/admin/videos?action=edit&id=${v.id}&tab=edit">
                                <fmt:message key="table.edit"/>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="pagination">
                <form action="${ctx}/admin/videos" method="get">
                    <input type="hidden" name="tab" value="list"/>
                    <button name="page" value="1">|&lt;</button>
                    <button name="page" value="${currentPage > 1 ? currentPage - 1 : 1}">&lt;&lt;</button>
                    <button name="page" value="${currentPage < totalPage ? currentPage + 1 : totalPage}">&gt;&gt;</button>
                    <button name="page" value="${totalPage}">&gt;|</button>
                </form>
            </div>
        </div>

        <!-- TAB 3: DELETED LIST -->
        <div class="video-tab-pane ${activeTab == 'deleted' ? 'active' : ''}" id="tab-deleted">
            <h2 class="admin-subtitle"><fmt:message key="admin.videos.tab.deleted"/></h2>

            <form action="${ctx}/admin/videos" method="post">
                <input type="hidden" name="action" value="restore" />
                <input type="hidden" name="tab" value="deleted" />

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th style="width:32px"><input type="checkbox" onclick="document.querySelectorAll('#tab-deleted input[type=checkbox].rowchk').forEach(cb=>cb.checked=this.checked)"></th>
                        <th><fmt:message key="admin.videos.field.id"/></th>
                        <th><fmt:message key="admin.videos.field.title"/></th>
                        <th><fmt:message key="admin.videos.field.views"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="v" items="${deletedVideos}">
                        <tr>
                            <td><input class="rowchk" type="checkbox" name="ids" value="${v.id}" /></td>
                            <td>${v.id}</td>
                            <td>${v.title}</td>
                            <td>${v.views}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="admin-form-actions" style="text-align:right">
                    <button class="btn-orange" type="submit">Restore Selected</button>
                </div>
            </form>

            <div class="pagination">
                <form action="${ctx}/admin/videos" method="get">
                    <input type="hidden" name="tab" value="deleted"/>
                    <button name="page" value="1">|&lt;</button>
                    <button name="page" value="${deletedCurrentPage > 1 ? deletedCurrentPage - 1 : 1}">&lt;&lt;</button>
                    <button name="page" value="${deletedCurrentPage < deletedTotalPage ? deletedCurrentPage + 1 : deletedTotalPage}">&gt;&gt;</button>
                    <button name="page" value="${deletedTotalPage}">&gt;|</button>
                </form>
            </div>
        </div>
    </div>
</div>


