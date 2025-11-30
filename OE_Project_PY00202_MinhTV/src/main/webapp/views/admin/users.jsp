<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- editing: true => đang sửa, false => trạng thái khởi đầu --%>
<c:if test="${empty editing}">
    <c:set var="editing" value="false" />
</c:if>

<%-- Tab đang active: mặc định là EDITION --%>
    <c:set var="activeTab" value="edit" />
    <c:if test="${param.tab == 'list'}">
        <c:set var="activeTab" value="list" />
    </c:if>
    <c:if test="${param.tab == 'approve'}">
        <c:set var="activeTab" value="approve" />
    </c:if>
    <c:if test="${param.tab == 'deleted'}">
        <c:set var="activeTab" value="deleted" />
    </c:if>
<c:if test="${param.action == 'edit'}">
    <c:set var="activeTab" value="edit" />
</c:if>

<style>
    /* User Admin Wrapper - Use CSS Variables */
    .user-admin-wrapper {
        border: 1px solid var(--border-color);
        margin-top: 10px;
        background: var(--card-bg);
        border-radius: 8px;
        overflow: hidden;
    }
    .user-admin-tabs {
        display: flex;
        border-bottom: 2px solid var(--border-color);
        background: var(--input-bg);
    }
    .user-admin-tab {
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
    .user-admin-tab:hover {
        color: var(--text-primary);
    }
    .user-admin-tab.active {
        background: var(--card-bg);
        color: var(--accent-color);
        border-bottom-color: var(--accent-color);
        font-weight: 600;
    }
    .user-admin-body {
        padding: 20px 24px;
        background: var(--card-bg);
    }
    .user-tab-pane {
        display: none;
    }
    .user-tab-pane.active {
        display: block;
    }

    /* Form Edition */
    .user-edit-form {
        border: 1px solid var(--border-color);
        border-radius: 8px;
        padding: 20px;
        font-size: 14px;
        background: var(--card-bg);
    }
    .user-edit-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        column-gap: 24px;
        row-gap: 16px;
    }
    .user-edit-row label {
        display: block;
        font-weight: 500;
        margin-bottom: 8px;
        color: var(--text-primary);
        font-size: 14px;
    }
    .user-edit-row input[type="text"],
    .user-edit-row input[type="password"],
    .user-edit-row input[type="email"] {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid var(--input-border);
        border-radius: 8px;
        background: var(--input-bg);
        color: var(--text-primary);
        box-sizing: border-box;
        font-size: 14px;
    }
    .user-edit-row input:focus {
        outline: none;
        border-color: var(--accent-color);
    }

    .user-edit-actions {
        margin-top: 20px;
        border-top: 1px solid var(--border-color);
        padding-top: 16px;
        text-align: right;
    }
    .btn-gray {
        background: var(--button-bg);
        color: var(--button-text);
        border: none;
        padding: 8px 20px;
        margin-left: 8px;
        font-weight: 500;
        cursor: pointer;
        border-radius: 8px;
        transition: all 0.2s ease;
    }
    .btn-gray:hover {
        opacity: 0.9;
    }
    .btn-gray:disabled {
        opacity: 0.4;
        cursor: not-allowed;
    }

    /* Pagination */
    .pagination {
        margin-top: 16px;
        text-align: right;
    }
    .pagination button {
        background: var(--bg-hover);
        border: 1px solid var(--border-color);
        color: var(--text-primary);
        padding: 6px 12px;
        margin-left: 4px;
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

<h1 class="admin-title">USER MANAGEMENT</h1>

<div class="user-admin-wrapper">

    <!-- TAB HEADER -->
    <div class="user-admin-tabs">
        <a class="user-admin-tab ${activeTab == 'edit' ? 'active' : ''}"
           href="${ctx}/admin/users?tab=edit">
            USER EDITION
        </a>
        <a class="user-admin-tab ${activeTab == 'list' ? 'active' : ''}"
           href="${ctx}/admin/users?tab=list">
            USER LIST
        </a>
        <a class="user-admin-tab ${activeTab == 'approve' ? 'active' : ''}"
           href="${ctx}/admin/users?tab=approve">
            ACCOUNT APPROVAL
        </a>
        <a class="user-admin-tab ${activeTab == 'deleted' ? 'active' : ''}"
           href="${ctx}/admin/users?tab=deleted">
            DELETED LIST
        </a>
    </div>

    <div class="user-admin-body">

        <!-- messages -->
        <c:if test="${not empty message}">
            <div class="admin-message success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="admin-message error">${error}</div>
        </c:if>

        <!-- TAB 1: USER EDITION -->
        <div class="user-tab-pane ${activeTab == 'edit' ? 'active' : ''}" id="tab-user-edit">

            <div class="user-edit-form">
                <form action="${ctx}/admin/users" method="post">
                    <input type="hidden" name="action" id="userAction" value="update" />
                    <input type="hidden" name="tab" value="edit"/>

                    <div class="user-edit-grid">
                        <div class="user-edit-row">
                                <label>Username?</label>
                                <input type="text" name="id" value="${form.id}"
                                       <c:if test="${editing}">readonly</c:if> />
                        </div>

                        <div class="user-edit-row">
                            <label>Password?</label>
                            <input type="text" name="password" value="${form.password}" />
                        </div>

                        <div class="user-edit-row">
                            <label>Fullname?</label>
                            <input type="text" name="fullname" value="${form.fullname}" />
                        </div>

                        <div class="user-edit-row">
                            <label>Email Address?</label>
                            <input type="email" name="email" value="${form.email}" />
                        </div>
                    </div>

                    <div style="margin-top: 8px;">
                        <label style="font-size:13px;">
                            <input type="checkbox" name="admin" value="true"
                                   ${form.admin ? "checked" : ""}/>
                            Admin role
                        </label>
                        &nbsp;&nbsp;
                        <label style="font-size:13px;">
                            <input type="checkbox" name="active" value="true"
                                   ${form.active ? "checked" : ""}/>
                            Active
                        </label>
                    </div>

                    <div class="user-edit-actions">
                        <!-- Create -->
                        <button class="btn-gray" type="submit"
                                onclick="document.getElementById('userAction').value='create'"
                                <c:if test="${editing}">disabled</c:if>>
                            Create
                        </button>

                        <!-- Update -->
                        <button class="btn-gray" type="submit"
                                onclick="document.getElementById('userAction').value='update'"
                                <c:if test="${not editing}">disabled</c:if>>
                            Update
                        </button>

                        <!-- Delete -->
                        <button class="btn-gray" type="submit"
                                onclick="document.getElementById('userAction').value='delete'"
                                <c:if test="${not editing}">disabled</c:if>>
                            Delete
                        </button>

                        <!-- Reset -->
                        <button class="btn-gray" type="submit"
                                onclick="document.getElementById('userAction').value='reset'">
                            Reset
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- TAB 2: USER LIST -->
        <div class="user-tab-pane ${activeTab == 'list' ? 'active' : ''}" id="tab-user-list">
            <h2 class="admin-subtitle">USER LIST</h2>

            <table class="admin-table">
                <thead>
                <tr>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Fullname</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Active</th>
                    <th>Edit</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.password}</td>
                        <td>${u.fullname}</td>
                        <td>${u.email}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.admin}">Admin</c:when>
                                <c:otherwise>User</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${u.active ? 'Yes' : 'No'}</td>
                        <td>
                            <a href="${ctx}/admin/users?action=edit&id=${u.id}&tab=edit">Edit</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div style="margin-top:6px; font-size:13px;">
                ${totalUsers} users
            </div>

            <div class="pagination">
                <form action="${ctx}/admin/users" method="get">
                    <input type="hidden" name="tab" value="list"/>
                    <button name="page" value="1">|&lt;</button>
                    <button name="page" value="${currentPage > 1 ? currentPage - 1 : 1}">&lt;&lt;</button>
                    <button name="page" value="${currentPage < totalPage ? currentPage + 1 : totalPage}">&gt;&gt;</button>
                    <button name="page" value="${totalPage}">&gt;|</button>
                </form>
            </div>
        </div>

        <!-- TAB 3: DELETED LIST -->
        <div class="user-tab-pane ${activeTab == 'deleted' ? 'active' : ''}" id="tab-user-deleted">
            <h2 class="admin-subtitle">DELETED USERS</h2>

            <form action="${ctx}/admin/users" method="post">
                <input type="hidden" name="action" value="restore" />
                <input type="hidden" name="tab" value="deleted" />

                <table class="admin-table">
                    <thead>
                    <tr>
                        <th style="width:32px"><input type="checkbox" onclick="document.querySelectorAll('#tab-user-deleted input[type=checkbox].rowchk').forEach(cb=>cb.checked=this.checked)"></th>
                        <th>Username</th>
                        <th>Fullname</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Active</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${deletedUsers}">
                        <tr>
                            <td><input class="rowchk" type="checkbox" name="ids" value="${u.id}" /></td>
                            <td>${u.id}</td>
                            <td>${u.fullname}</td>
                            <td>${u.email}</td>
                            <td>${u.admin ? 'Admin' : 'User'}</td>
                            <td>${u.active ? 'Yes' : 'No'}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="admin-form-actions" style="text-align:right">
                    <button class="btn-gray" type="submit">Restore Selected</button>
                </div>
            </form>

            <div class="pagination">
                <form action="${ctx}/admin/users" method="get">
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
        <!-- TAB 4: ACCOUNT APPROVAL -->
        <div class="user-tab-pane ${activeTab == 'approve' ? 'active' : ''}" id="tab-user-approve">
            <h2 class="admin-subtitle">PENDING ACCOUNTS</h2>

            <table class="admin-table">
                <thead>
                <tr>
                    <th>Username</th>
                    <th>Fullname</th>
                    <th>Email</th>
                    <th>Approve</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${pendingUsers}">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.fullname}</td>
                        <td>${u.email}</td>
                        <td>
                            <form action="${ctx}/admin/users" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="approve"/>
                                <input type="hidden" name="id" value="${u.id}"/>
                                <input type="hidden" name="tab" value="approve"/>
                                <button class="btn-gray" type="submit">Approve</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
