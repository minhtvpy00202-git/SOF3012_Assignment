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
<c:if test="${param.action == 'edit'}">
    <c:set var="activeTab" value="edit" />
</c:if>

<style>
    /* Vỏ ngoài giống hình */
    .user-admin-wrapper {
        border: 1px solid #f0a060;
        margin-top: 10px;
        background: #fff;
    }
    .user-admin-tabs {
        display: flex;
        border-bottom: 1px solid #f0a060;
    }
    .user-admin-tab {
        padding: 6px 16px;
        font-weight: bold;
        text-transform: uppercase;
        border-right: 1px solid #f0a060;
        text-decoration: none;
        color: #444;
        background: #fbead7;
    }
    .user-admin-tab.active {
        background: #ffffff;
        color: #c32a12;
        border-bottom: 2px solid #ffffff;
    }
    .user-admin-body {
        padding: 15px 20px 20px 20px;
    }
    .user-tab-pane {
        display: none;
    }
    .user-tab-pane.active {
        display: block;
    }

    /* FORM EDITION GIỐNG HÌNH */
    .user-edit-form {
        border: 1px solid #f0a060;
        border-top: none;
        padding: 15px 18px 18px 18px;
        font-size: 13px;
    }
    .user-edit-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        column-gap: 40px;
        row-gap: 12px;
    }
    .user-edit-row label {
        display: block;
        font-weight: bold;
        text-transform: uppercase;
        margin-bottom: 4px;
    }
    .user-edit-row input[type="text"],
    .user-edit-row input[type="password"],
    .user-edit-row input[type="email"] {
        width: 100%;
        padding: 4px 6px;
        border: 1px solid #f0a060;
        box-sizing: border-box;
    }

    .user-edit-actions {
        margin-top: 16px;
        border-top: 1px solid #f0a060;
        padding-top: 10px;
        text-align: right;
        background: #f7f7f7;
    }
    .btn-gray {
        background: #d9d9d9;
        border: 1px solid #999;
        padding: 6px 18px;
        margin-left: 6px;
        font-weight: bold;
        cursor: pointer;
    }
    .btn-gray:disabled {
        opacity: 0.4;
        cursor: default;
    }

    /* LIST */
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
        text-align: right;
    }
    .pagination button {
        background: #d9d9d9;
        border: 1px solid #999;
        padding: 4px 10px;
        margin-left: 4px;
        cursor: pointer;
        font-weight: bold;
    }

    /* message */
    .admin-message {
        margin-top: 10px;
        padding: 6px 10px;
        border-radius: 3px;
        font-size: 13px;
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

    </div>
</div>
