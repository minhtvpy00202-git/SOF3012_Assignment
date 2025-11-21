<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<c:if test="${empty editing}">
    <c:set var="editing" value="false" />
</c:if>


<%-- tab đang active: mặc định là edit, chỉ khi tab=list thì mới hiện list --%>
<c:set var="activeTab" value="edit" />
<c:if test="${param.tab == 'list'}">
    <c:set var="activeTab" value="list" />
</c:if>
<c:if test="${param.action == 'edit'}">
    <c:set var="activeTab" value="edit" />
</c:if>

<style>
    /* KHUNG TAB GIỐNG ĐỀ */
    .video-admin-wrapper {
        border: 1px solid #f0a060;
        margin-top: 10px;
        background: #fff;
    }
    .video-admin-tabs {
        display: flex;
        border-bottom: 1px solid #f0a060;
    }
    .video-admin-tab {
        padding: 6px 16px;
        font-weight: bold;
        text-transform: uppercase;
        border-right: 1px solid #f0a060;
        text-decoration: none;
        color: #444;
        background: #fbead7;
    }
    .video-admin-tab.active {
        background: #ffffff;
        color: #c32a12;
        border-bottom: 2px solid #ffffff;
    }
    .video-admin-body {
        padding: 15px 20px 20px 20px;
    }
    .video-tab-pane {
        display: none;
    }
    .video-tab-pane.active {
        display: block;
    }

    /* POSTER + FORM LAYOUT */
    .video-edit-layout {
        display: grid;
        grid-template-columns: 320px auto;
        gap: 20px;
    }
    .poster-panel {
        padding-top: 10px;
    }
    .poster-box {
        border: 2px solid #f4a460;
        background: #fbfbfb;
        width: 260px;
        height: 220px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        color: #555;
        margin-bottom: 10px;
    }
    .poster-box img {
        max-width: 100%;
        max-height: 100%;
    }
    .admin-form-row {
        margin-bottom: 10px;
    }
    .admin-form-row label {
        display: inline-block;
        width: 120px;
        font-weight: bold;
        text-transform: uppercase;
        font-size: 13px;
    }
    .admin-form-row input[type="text"],
    .admin-form-row input[type="number"],
    .admin-form-row textarea {
        border: 1px solid #f4a460;
        padding: 4px 6px;
        width: 100%;
        box-sizing: border-box;
    }
    .admin-form-row textarea {
        min-height: 80px;
    }
    .admin-form-actions {
        margin-top: 15px;
        text-align: center;
        padding-top: 10px;
        border-top: 1px solid #f4a460;
    }
    .btn-orange {
        background: #d9d9d9;
        border: 1px solid #999;
        padding: 6px 22px;
        margin: 0 5px;
        font-weight: bold;
        cursor: pointer;
    }
    .btn-orange:disabled {
        opacity: 0.4;
        cursor: default;
    }

    /* BẢNG LIST */
    .admin-subtitle {
        font-size: 16px;
        margin-bottom: 8px;
    }
    .admin-table {
        width: 100%;
        border-collapse: collapse;
        border: 1px solid #f0a060;
        font-size: 13px;
    }
    .admin-table th,
    .admin-table td {
        border: 1px solid #f0a060;
        padding: 4px 6px;
    }
    .admin-table th {
        background: #fbe9d7;
        text-align: left;
    }
    .pagination {
        margin-top: 10px;
        text-align: left;
    }
    .pagination button {
        background: #d9d9d9;
        border: 1px solid #999;
        padding: 4px 10px;
        margin-right: 4px;
        cursor: pointer;
        font-weight: bold;
    }

    /* message */
    .admin-message {
        margin-top: 10px;
        padding: 6px 10px;
        border-radius: 3px;
    }
    .admin-message.success {
        background: #e8f5e9;
        border: 1px solid #8bc34a;
        color: #2e7d32;
    }
    .admin-message.error {
        background: #ffebee;
        border: 1px solid #e57373;
        color: #c62828;
    }

        .poster-hidden {
            display: none;
        }

</style>

<h1 class="admin-title">VIDEO MANAGEMENT</h1>

<div class="video-admin-wrapper">

    <!-- TAB HEADER -->
    <div class="video-admin-tabs">
        <a class="video-admin-tab ${activeTab == 'edit' ? 'active' : ''}"
           href="${ctx}/admin/videos?tab=edit">
            VIDEO EDITION
        </a>
        <a class="video-admin-tab ${activeTab == 'list' ? 'active' : ''}"
           href="${ctx}/admin/videos?tab=list">
            VIDEO LIST
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
                            <label>Chọn poster?</label>
                            <input type="file" name="posterFile" accept="image/*"/>
                        </div>
                    </div>


                    <!-- form fields -->
                    <div class="video-form-panel">
                        <div class="admin-form-row">
                            <label>Youtube ID?</label>
                            <input type="text" name="id" value="${form.id}"/>
                        </div>

                        <div class="admin-form-row">
                            <label>Video Title?</label>
                            <input type="text" name="title" value="${form.title}"/>
                        </div>

                        <div class="admin-form-row">
                            <label>View Count?</label>
                            <input type="number" name="views"
                                   value="${form.views != null ? form.views : 0}"/>
                        </div>

                        <div class="admin-form-row">
                            <label>Status</label>
                            <label>
                                <input type="radio" name="active" value="true"
                                       ${form.active ? "checked" : ""}/> Active
                            </label>
                            <label style="margin-left:15px;">
                                <input type="radio" name="active" value="false"
                                       ${!form.active ? "checked" : ""}/> Inactive
                            </label>
                        </div>

                        <div class="admin-form-row">
                            <label>Youtube href?</label>
                            <input type="text" name="href" value="${form.href}"/>
                        </div>

                        <div class="admin-form-row">
                            <label>Description?</label>
                            <textarea name="description" rows="4">${form.description}</textarea>
                        </div>

                        <div class="admin-form-actions">
                            <!-- Create -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='create'"
                                    <c:if test="${editing}">disabled</c:if>>
                                Create
                            </button>

                            <!-- Update -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='update'"
                                    <c:if test="${not editing}">disabled</c:if>>
                                Update
                            </button>

                            <!-- Delete -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='delete'"
                                    <c:if test="${not editing}">disabled</c:if>>
                                Delete
                            </button>

                            <!-- Reset -->
                            <button class="btn-orange" type="submit"
                                    onclick="document.getElementById('actionField').value='reset'">
                                Reset
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


        <!-- TAB 2: LIST -->
        <div class="video-tab-pane ${activeTab == 'list' ? 'active' : ''}" id="tab-list">
            <h2 class="admin-subtitle">VIDEO LIST</h2>

            <table class="admin-table">
                <thead>
                <tr>
                    <th>Youtube Id</th>
                    <th>Video Title</th>
                    <th>View Count</th>
                    <th>Status</th>
                    <th>Edit</th>
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
                                <c:when test="${v.active}">Active</c:when>
                                <c:otherwise>Inactive</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${ctx}/admin/videos?action=edit&id=${v.id}&tab=edit">
                                Edit
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
    </div>
</div>


