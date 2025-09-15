<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Chi tiết khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://kit.fontawesome.com/yourcode.js" crossorigin="anonymous"></script>
</head>
<body>
<div class="container mt-4">
    <h3 style="color: #001f3d;" class="mt-4">Chi tiết khách hàng</h3>

    <!-- Nút quay lại -->
    <a href="/home" class="btn btn-outline-secondary btn-sm mb-3">
        <i class="fa-solid fa-arrow-left"></i> Trang chủ
    </a>

    <!-- Thông tin khách hàng -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Tên khách hàng:</label>
                    <div class="text-dark">${khachHang.hoVaTen}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Ngày sinh:</label>
                    <div class="text-dark">${khachHang.ngaySinh}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Giới tính:</label>
                    <div class="text-dark">${khachHang.gioiTinh}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Số điện thoại:</label>
                    <div class="text-dark">${khachHang.soDienThoai}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Email:</label>
                    <div class="text-dark">${khachHang.email}</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Mật khẩu:</label>
                    <div class="text-dark">${khachHang.matKhau}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Nút thêm địa chỉ -->
    <a href="/khachhang/${khachHang.id}/address" class="btn btn-primary">
        <i class="fa-solid fa-plus"></i> Thêm địa chỉ
    </a>
</div>
</body>
</html>
