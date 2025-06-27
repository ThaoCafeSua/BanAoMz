<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Đăng nhập</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f4f4f4;
        }

        .login-box {
            width: 400px;
            margin: 100px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #001f3d;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 6px 0 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #001f3d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .error {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="login-box">
    <h2>Đăng nhập hệ thống</h2>
    <form action="/auth/login" method="post">
        <label>Email</label>
        <input type="text" name="email" required>

        <label>Mật khẩu</label>
        <input type="password" name="matKhau" required>

        <button type="submit">Đăng nhập</button>
    </form>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
</div>
</body>
</html>
