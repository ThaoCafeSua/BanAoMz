<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container mt-4">
    <h3 style="color: #001f3d;" class="mt-4">Chi tiết nhân viên</h3>
    <a href="/admin/employee" class="btn btn-outline-secondary btn-sm mb-3">
        <i class="fa-solid fa-arrow-left"></i>
    </a>

    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Tên nhân viên:</label>
                    <div id="tenNhanVien" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Ngày sinh:</label>
                    <div id="ngaySinh" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Giới tính:</label>
                    <div id="gioiTinh" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Số điện thoại:</label>
                    <div id="soDienThoai" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Email:</label>
                    <div id="email" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Mật khẩu:</label>
                    <div id="matKhau" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Chức vụ:</label>
                    <div id="chucVuTen" class="text-dark"></div>
                </div>


            <%--                <div class="col-md-4">--%>
<%--                    <label class="form-label fw-bold text-primary">Ngày tạo:</label>--%>
<%--                    <div id="ngayTao" class="text-dark"></div>--%>
<%--                </div>--%>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Ngày sửa:</label>
                    <div id="ngaySua" class="text-dark"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        let employeeId = ${employeeId};
        $.ajax({
            url: '/admin/employee/detail',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(employeeId),
            success: function (res) {
                let nv = res.data;
                $('#tenNhanVien').text(nv.tenNhanVien);
                $('#ngaySinh').text(nv.ngaySinh ?? '');
                $('#gioiTinh').text(nv.gioiTinh === 'Male' ? 'Nam' : 'Nữ');
                $('#soDienThoai').text(nv.soDienThoai ?? '');
                $('#email').text(nv.email ?? '');
                $('#matKhau').text(nv.matKhau ?? '');
                $('#chucVuTen').text(nv.chucVuTen ?? '');
                // $('#ngayTao').text(nv.ngayTao ?? '');
                $('#ngaySua').text(nv.ngaySua ?? '');
            },
            error: function () {
                toastr.error('Không thể tải dữ liệu nhân viên.');
            }
        });
    });
</script>

<style>
    .form-label {
        color: #001f3d;
        font-weight: bold;
    }
    .text-dark {
        font-size: 15px;
        margin-top: 5px;
    }
    .btn-outline-secondary {
        border-radius: 20px;
        color: #001f3d;
    }
    .btn-outline-secondary:hover {
        background-color: #004080;
        color: white;
    }
</style>
