<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <style>
        body{font-family:Arial;background:#f4f4f4}
        .box{width:380px;margin:80px auto;background:#fff;padding:30px;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,.1)}
        h2{text-align:center;color:#001f3d;margin-bottom:20px}
        input,button{width:100%;padding:12px;border-radius:6px}
        input{border:1px solid #ccc;margin:8px 0 14px}
        button{border:none;background:#001f3d;color:#fff;cursor:pointer}
        .error{color:#d00;text-align:center;margin-bottom:10px}
        .success{color:#090;text-align:center;margin-bottom:10px}
        .help{text-align:center;margin-top:10px}
        .help a{color:#001f3d;text-decoration:underline}
    </style>
</head>
<body>
<div class="box">
    <h2>Đăng nhập hệ thống</h2>

    <c:if test="${not empty error}"><div class="error">${error}</div></c:if>
    <c:if test="${not empty success}"><div class="success">${success}</div></c:if>

    <form action="${pageContext.request.contextPath}/auth/login" method="post" autocomplete="on">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <label>Email</label>
        <input type="email" name="email" autocomplete="username" required>
        <label>Mật khẩu</label>
        <input type="password" name="matKhau" autocomplete="current-password" required>
        <button type="submit">Đăng nhập</button>
    </form>

    <div class="help">
        <a href="${pageContext.request.contextPath}/auth/forgot">Quên mật khẩu?</a>
    </div>
</div>
</body>
</html>