<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<!-- Viết CSS riêng -->
<style>
    .title-primary {
        color: #001f3d;
    }
    .btn-submit {
        background-color: #001f3d;
        color: #fff;
        transition: background-color 0.3s ease;
    }
    .btn-submit:hover {
        background-color: #003366;
        color: #fff;
    }
</style>

<div>
    <h3 class="title-primary">${btnText}</h3>

    <a href="/admin/color" class="btn mb-2">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>

    <div class="card">
        <div class="card-body">
            <form id="mauSacForm" action="${action}" method="post" onsubmit="validateForm(event)">
                <input type="hidden" class="form-control" name="id" id="idKhoiLuong" value="${mauSac.id}">

                <div class="mb-3">
                    <label for="inputName" class="form-label label-primary">Tên Màu Sắc</label>
                    <input type="text" class="form-control" name="tenMauSac" id="inputName" placeholder="Nhập tên màu sắc" value="${mauSac.tenMauSac}">
                </div>

                <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-submit">${btnText}</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function validateForm(event) {
        event.preventDefault(); // Ngăn hành động gửi form mặc định

        // Kiểm tra tên màu sắc
        var name = $("#inputName").val().trim();
        if (name === "") {
            toastr.error("Màu sắc không được để trống");
            return false;
        }

        // Hiển thị xác nhận trước khi gửi form
        Swal.fire({
            title: 'Bạn chắc chắn muốn ${btnText} màu sắc này?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#001f3d',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                event.target.submit(); // Gửi form trực tiếp sau khi xác nhận
            }
        });
    }

    // Gắn sự kiện validateForm vào form khi trang được tải
    $(document).ready(function () {
        $("#mauSacForm").on("submit", validateForm);
    });
</script>
