<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container">
    <h3 style="color: #001f3d;" class="mt-4">Thông tin Nhân viên</h3>
    <a href="/admin/employee" class="btn btn-outline-secondary btn-sm mb-3">
        <i class="fa-solid fa-arrow-left"></i>
    </a>

    <div class="card" style="border: 1px solid #006d7f; border-radius: 10px;">
        <div class="card-body">
            <form id="employeeForm" action="${action}" method="post">
                <input type="hidden" name="id" value="${employee.id}">

                <!-- Chức vụ -->
                <div class="mb-3">
                    <label class="form-label">Chức vụ</label>
                    <select class="form-select" name="chucVuId">
                        <c:forEach var="position" items="${positions}">
                            <option value="${position.id}"
                                    <c:if test="${employee.chucVu != null && employee.chucVu.id == position.id}">selected</c:if>>
                                    ${position.tenChucVu}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Tên nhân viên -->
                <div class="mb-3">
                    <label class="form-label">Tên nhân viên</label>
                    <input type="text" class="form-control" name="tenNhanVien" value="${employee.tenNhanVien}" placeholder="Nhập tên nhân viên">
                </div>

                <!-- Giới tính -->
                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <div class="d-flex">
                        <c:forEach var="entry" items="${gender}">
                            <div class="me-4">
                                <input type="radio" id="gender${entry.key}" name="gioiTinh" value="${entry.key}" <c:if test="${employee.gioiTinh == entry.key}">checked</c:if>>
                                <label for="gender${entry.key}" class="form-check-label">${entry.value}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Ngày sinh -->
                <div class="mb-3">
                    <label class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" name="ngaySinh" value="${employee.ngaySinh}">
                </div>

                <!-- SĐT -->
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" name="soDienThoai" value="${employee.soDienThoai}">
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" value="${employee.email}">
                </div>

                <!-- Địa chỉ -->
                <div class="mb-3">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" class="form-control" name="diaChi" value="${employee.diaChi}">
                </div>

                <!-- Mật khẩu -->
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <input type="password" class="form-control" name="matKhau" id="passwordField" value="${employee.matKhau}">
                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword()">👁️</button>
                    </div>
                </div>

<%--                <!-- Ngày tạo -->--%>
<%--                <input type="date" class="form-control" name="ngayTao" readonly--%>
<%--                       value="${employee.ngayTao != null ? employee.ngayTao.toLocalDate() : ''}"/>--%>

<%--                <!-- Ngày sửa -->--%>
<%--                <input type="date" class="form-control" readonly--%>
<%--                       value="${employee.ngaySua != null ? employee.ngaySua.toLocalDate() : ''}"/>--%>


                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-teal">${btnText}</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .btn-teal {
        background-color: #001f3d;
        color: white;
        border-radius: 20px;
        padding: 6px 20px;
        border: 1px solid #cccccc;
    }
    .btn-teal:hover {
        background-color: #004080;
        color: white;
    }
</style>

<script>
    function togglePassword() {
        const pw = document.getElementById("passwordField");
        pw.type = pw.type === "password" ? "text" : "password";
    }

        function validateForm(event) {
        event.preventDefault();

        let tenNhanVien = $("input[name='tenNhanVien']").val().trim();
        let gioiTinh = $("input[name='gioiTinh']:checked").val();
        let ngaySinh = $("input[name='ngaySinh']").val();
        let sdt = $("input[name='soDienThoai']").val().trim();
        let email = $("input[name='email']").val().trim();
        let diaChi = $("input[name='diaChi']").val().trim();
        let matKhau = $("input[name='matKhau']").val().trim();

        if (tenNhanVien === "") {
        toastr.error("Vui lòng nhập tên nhân viên.");
        return;
    }

        if (!gioiTinh) {
        toastr.error("Vui lòng chọn giới tính.");
        return;
    }

        if (ngaySinh === "") {
        toastr.error("Vui lòng nhập ngày sinh.");
        return;
    }

        if (!/^\d{10,11}$/.test(sdt)) {
        toastr.error("Số điện thoại không hợp lệ. Phải gồm 10–11 chữ số.");
        return;
    }

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        toastr.error("Email không hợp lệ.");
        return;
    }

        if (diaChi === "") {
        toastr.error("Vui lòng nhập địa chỉ.");
        return;
    }

        if (matKhau.length < 6) {
        toastr.error("Mật khẩu phải có ít nhất 6 ký tự.");
        return;
    }

        // Nếu hợp lệ -> gửi form
        $("#employeeForm")[0].submit();
    }

        $(document).ready(function () {
        $("#employeeForm").on("submit", validateForm);
    });


// (Optional: Thêm kiểm tra form bằng JS nếu muốn)
</script>
