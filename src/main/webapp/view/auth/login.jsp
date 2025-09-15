<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
        }
        .login-container {
            width: 380px;
            margin: 80px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 { text-align:center; color:#001f3d; margin-bottom:20px; }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #001f3d;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        .error   { color: red;   text-align: center; margin-bottom: 15px; }
        .success { color: green; text-align: center; margin-bottom: 15px; }
        .forgot  { text-align: center; margin-top: 12px; }
        .forgot a { color: #001f3d; text-decoration: underline; cursor: pointer; }

        /* Popup */
        #forgotModal {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.5);
        }
        .modal-content {
            background: #fff;
            width: 350px;
            margin: 100px auto;
            padding: 20px;
            border-radius: 8px;
            position: relative;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .close {
            position: absolute;
            top: 8px; right: 12px;
            font-size: 20px;
            cursor: pointer;
        }
        #forgotMsg { margin-top: 10px; text-align: center; }
    </style>
</head>
<body>

<!-- Chỉ duy nhất 1 container -->
<div id="mainBox" class="login-container">
    <h2>Đăng nhập hệ thống</h2>
    <div id="messageArea">
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
    </div>

    <form id="loginForm" action="${pageContext.request.contextPath}/auth/login" method="post">
        <label>Email</label>
        <input type="text" name="email" required>

        <label>Mật khẩu</label>
        <input type="password" name="matKhau" required>

        <button type="submit">Đăng nhập</button>
    </form>

    <div class="forgot">
        <a id="forgotLink">Quên mật khẩu?</a>
    </div>
</div>

<!-- Popup quên mật khẩu -->
<div id="forgotModal">
    <div class="modal-content">
        <span class="close" onclick="$('#forgotModal').hide()">&times;</span>
        <h3>Lấy lại mật khẩu</h3>
        <p>Nhập email của bạn:</p>
        <input type="text" id="forgotEmail" placeholder="Email" style="width:100%;padding:10px;margin-top:10px;">
        <button id="sendNewPassword" style="margin-top:15px;">Gửi mật khẩu mới</button>
        <div id="forgotMsg"></div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $('#forgotLink').click(function () {
        $('#forgotModal').show();
        $('#forgotEmail').val('');
        $('#forgotMsg').empty();
    });

    $('#sendNewPassword').click(function () {
        let email = $('#forgotEmail').val().trim();
        if (!email) {
            $('#forgotMsg').html('<span style="color:red">Vui lòng nhập email.</span>');
            return;
        }
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/auth/forgot-password',
            data: { email: email },
            success: function (res) {
                // Đóng popup và chỉ CẬP NHẬT thông báo trong container hiện tại
                $('#forgotModal').hide();

                // THAY THẾ nội dung cũ (xóa form cũ nếu cần)
                $('#mainBox').html(
                    '<h2>Đăng nhập hệ thống</h2>' +
                    '<div class="success">'+res+'</div>' +
                    '<form action="${pageContext.request.contextPath}/auth/login" method="post">' +
                    '<label>Email</label>' +
                    '<input type="text" name="email" required>' +
                    '<label>Mật khẩu</label>' +
                    '<input type="password" name="matKhau" required>' +
                    '<button type="submit">Đăng nhập</button>' +
                    '</form>' +
                    '<div class="forgot"><a id="forgotLink">Quên mật khẩu?</a></div>'
                );

                // Gắn lại sự kiện cho link "Quên mật khẩu" mới
                $('#forgotLink').click(function () {
                    $('#forgotModal').show();
                    $('#forgotEmail').val('');
                    $('#forgotMsg').empty();
                });
            },
            error: function (xhr) {
                $('#forgotMsg').html('<span style="color:red">' + xhr.responseText + '</span>');
            }
        });
    });
</script>
<c:if test="${not empty sessionScope.message}">
    <div id="user-role-alert">${sessionScope.message}</div>
    <c:remove var="message" scope="session"/>
</c:if>
</body>
</html>
