<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Đăng nhập khách hàng</h2>

    <form action="/khachhang/dangnhap" method="post" class="col-md-6 mx-auto">
        <!-- CSRF bắt buộc cho mọi form POST khi bật Spring Security -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label>Mật khẩu</label>
            <input type="password" name="matKhau" class="form-control" required/>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
        <p class="mt-3">Chưa có tài khoản? <a href="/khachhang/dangky">Đăng ký</a></p>
    </form>
</div>
</body>
</html>
