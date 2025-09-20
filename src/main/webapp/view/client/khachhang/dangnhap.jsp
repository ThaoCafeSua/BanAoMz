<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng nhập</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <style>
        /* Modal nền tối */
        #forgotModal {
            display:none; position:fixed; top:0; left:0;
            width:100%; height:100%; background:rgba(0,0,0,0.5);
            z-index:1050;
        }
        .modal-content {
            background:#fff; width:350px; margin:120px auto;
            padding:20px; border-radius:8px; position:relative;
        }
        .close {
            position:absolute; top:8px; right:12px;
            font-size:20px; cursor:pointer;
        }
    </style>
</head>
<body>
<div class="container mt-5" id="mainBox">
    <h2 class="text-center">Đăng nhập khách hàng</h2>


    <form action="/khachhang/dangnhap" method="post" class="col-md-6 mx-auto">
        <!-- CSRF bắt buộc cho mọi form POST khi bật Spring Security -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </form>

    <form action="${pageContext.request.contextPath}/khachhang/dangnhap"
          method="post" class="col-md-6 mx-auto">

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

        <div class="d-flex justify-content-between mt-3">
            <a id="forgotLink" style="cursor:pointer">Quên mật khẩu?</a>
            <a href="${pageContext.request.contextPath}/khachhang/dangky">Đăng ký</a>
        </div>
    </form>
</div>

<!-- Modal quên mật khẩu -->
<div id="forgotModal">
    <div class="modal-content">
        <span class="close" onclick="$('#forgotModal').hide()">&times;</span>
        <h5 class="text-center mb-3">Lấy lại mật khẩu</h5>
        <input type="email" id="forgotEmail" class="form-control"
               placeholder="Nhập email" />
        <button id="sendNewPassword" class="btn btn-primary w-100 mt-3">
            <a href="${pageContext.request.contextPath}/khachhang/dangnhap"></a>
            Gửi mật khẩu mới
        </button>
        <div id="forgotMsg" class="mt-2 text-center"></div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // Mở popup
    $('#forgotLink').click(function () {
        $('#forgotModal').show();
        $('#forgotEmail').val('');
        $('#forgotMsg').empty();
    });

    // Gửi yêu cầu quên mật khẩu
    $('#sendNewPassword').click(function () {
        let email = $('#forgotEmail').val().trim();
        if (!email) {
            $('#forgotMsg').html('<span class="text-danger">Vui lòng nhập email.</span>');
            return;
        }
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/khachhang/forgot-password',
            data: { email: email },
            success: function (res) {
                $('#forgotModal').hide();
                $('#mainBox').prepend(
                    '<div class="success">✅ Mật khẩu mới đã được gửi vào email của bạn!</div>'
                );
                // Hiển thị thông báo thành công NGAY TRÊN form đăng nhập
                //$('#mainBox').prepend('<div class="alert alert-success text-center">'+res+'</div>');
            },
            error: function (xhr) {
                $('#forgotMsg').html('<span class="text-danger">' + xhr.responseText + '</span>');
            }
        });
    });
</script>
</body>
</html>
