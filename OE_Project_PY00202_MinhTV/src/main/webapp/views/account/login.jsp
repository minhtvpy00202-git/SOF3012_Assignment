<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        .login-box {
            width: 400px;
            margin: 40px auto;
            border: 1px solid #ccc;
            padding: 20px 30px;
            background: #fff;
        }
        .login-title {
            background: #f0ad4e;
            color: #fff;
            padding: 10px;
            font-weight: bold;
            margin: -20px -30px 20px -30px;
        }
        .form-row { margin-bottom: 10px; }
        label { display: block; margin-bottom: 4px; }
        input[type=text], input[type=password] {
            width: 100%;
            padding: 6px;
            box-sizing: border-box;
        }
        .remember {
            margin: 10px 0;
        }
        .btn-login {
            background: #f0ad4e;
            border: none;
            color: #fff;
            padding: 8px 20px;
            font-size: 14px;
            cursor: pointer;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="login-box">
    <div class="login-title">LOGIN</div>

    <c:if test="${not empty message}">
        <div class="error">${message}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="form-row">
            <label>Username?</label>
            <input type="text" name="username" value="${param.username != null ? param.username : cookie.username.value}">
        </div>
        <div class="form-row">
            <label>Password?</label>
            <input type="password" name="password"
                   value="${cookie.password.value}">
        </div>
        <div class="remember">
            <input type="checkbox" name="remember"
                   ${cookie.username.value != null ? "checked" : ""}> Remember me?
        </div>
        <button type="submit" class="btn-login">Login</button>
    </form>
</div>
</body>
</html>
