<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <style>
        .box { width: 450px; margin: 30px auto; border: 1px solid #ccc; padding: 20px 30px; background: #fff; }
        .title { background: #f0ad4e; color: #fff; padding: 10px; margin: -20px -30px 20px -30px; font-weight:bold; }
        .row { margin-bottom: 10px; }
        label { display:block; margin-bottom:3px; }
        input[type=text], input[type=email] { width: 100%; padding:6px; box-sizing:border-box; }
        .btn { background:#f0ad4e; color:#fff; border:none; padding:8px 20px; cursor:pointer; }
        .msg { color:red; margin-bottom:10px; }
    </style>
</head>
<body>
<div class="box">
    <div class="title">EDIT PROFILE</div>

    <c:if test="${not empty message}">
        <div class="msg">${message}</div>
    </c:if>

    <form method="post">
        <div class="row">
            <label>Username?</label>
            <input type="text" value="${sessionScope.currentUser.id}" readonly>
        </div>
        <div class="row">
            <label>Password?</label>
            <input type="password" value="${sessionScope.currentUser.password}" readonly>
        </div>
        <div class="row">
            <label>Fullname?</label>
            <input type="text" name="fullname" value="${sessionScope.currentUser.fullname}">
        </div>
        <div class="row">
            <label>Email address?</label>
            <input type="email" name="email" value="${sessionScope.currentUser.email}">
        </div>
        <button class="btn" type="submit">Update</button>
    </form>
</div>
</body>
</html>
