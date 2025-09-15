<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng ký khách hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-lg p-4">
                <h3 class="text-center mb-4">Đăng ký tài khoản</h3>
                <form action="/khachhang/dangky" method="post">
                    <div class="mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" name="hoVaTen" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" name="ngaySinh" class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Giới tính</label>
                        <select name="gioiTinh" class="form-control">
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="soDienThoai" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Mật khẩu</label>
                        <input type="password" name="matKhau" class="form-control" required>
                    </div>

                    <button type="submit" class="btn btn-success w-100">Đăng ký</button>
                    <p class="mt-3 text-center">Đã có tài khoản? <a href="/khachhang/dangnhap">Đăng nhập</a></p>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
