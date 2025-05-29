<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container">
    <h3 style="color: #001f3d;" class="mt-4">Khách hàng</h3>
    <a href="/admin/customer" class="btn btn-outline-secondary btn-sm mb-3">
        <i class="fa-solid fa-arrow-left"></i>
    </a>

    <div class="card" style="border: 1px solid #006d7f; border-radius: 10px;">
        <div class="card-body">
            <form id="customerForm" action="${action}" method="post">
                <input type="hidden" name="id" id="id" value="${customer.id}">

                <div class="mb-3">
                    <label for="nameKh" class="form-label">Tên khách hàng</label>
                    <input type="text" class="form-control" name="hoVaTen" id="nameKh" placeholder="Nhập tên khách hàng" value="${customer.hoVaTen}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <div class="d-flex">
                        <c:forEach var="entry" items="${gender}">
                            <div class="me-4">
                                <input type="radio" id="gender${entry.key}" name="gioiTinh" value="${entry.key}"
                                       <c:if test="${customer.gioiTinh != null and customer.gioiTinh == entry.key}">checked</c:if>>
                                <label for="gender${entry.key}" class="form-check-label">${entry.value}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="dateKh" class="form-label">Ngày sinh</label>
                    <input type="date" style="width: 200px" class="form-control" id="dateKh" name="ngaySinh"
                           value="${customer.ngaySinh != null ? customer.ngaySinh : '1990-01-01'}">
                </div>

                <div class="mb-3">
                    <label for="phoneKh" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phoneKh" name="soDienThoai" value="${customer.soDienThoai}" placeholder="Nhập số điện thoại">
                </div>

                <div class="mb-3">
                    <label for="emailKh" class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="emailKh" value="${customer.email}" placeholder="Nhập email khách hàng">
                </div>

                <div class="d-flex justify-content-end mt-4">
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

    .btn {
        border: 1px solid #cccccc !important;
        border-radius: 4px !important;
    }

    .btn:hover {
        background-color: #004080 !important;
        color: white !important;
    }

    .form-label {
        color: #001f3d;
        font-weight: 500;
    }

    .form-control {
        border-radius: 8px;
        border: 1px solid #dcdcdc;
    }

    .card {
        background-color: white;
        border: 1px solid #dcdcdc;
    }
</style>

<script>
    function validateForm(event) {
        event.preventDefault(); // Ngăn hành động gửi form mặc định

        // Kiểm tra tên khách hàng
        var name = $("#nameKh").val();
        if (name.trim() === "") {
            toastr.error("Tên khách hàng không được để trống");
            return false;
        }

        // Kiểm tra số điện thoại
        var phone = $("#phoneKh").val();
        var phoneRegex = /^[0-9]{10,11}$/;
        if (!phone.match(phoneRegex)) {
            toastr.error("Số điện thoại không hợp lệ. Vui lòng nhập 10-11 chữ số.");
            return false;
        }

        // Kiểm tra email
        var email = $("#emailKh").val();
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.match(emailRegex)) {
            toastr.error("Email không hợp lệ.");
            return false;
        }

        // Kiểm tra giới tính
        var gender = $('input[name="gioiTinh"]:checked').val();
        if (!gender) {
            toastr.error("Vui lòng chọn giới tính.");
            return false;
        }

        // Kiểm tra ngày sinh
        var dob = $("#dateKh").val();
        if (dob.trim() === "") {
            toastr.error("Vui lòng nhập ngày sinh.");
            return false;
        }

        // Hiển thị xác nhận trước khi gửi form
        Swal.fire({
            title: `Xác Nhận ${btnText}?`,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $("#customerForm")[0].submit(); // Gửi form trực tiếp sau khi xác nhận
            }
        });
    }

    // Gắn sự kiện validateForm vào form
    $(document).ready(function () {
        $("#customerForm").on("submit", validateForm);
    });
</script>
