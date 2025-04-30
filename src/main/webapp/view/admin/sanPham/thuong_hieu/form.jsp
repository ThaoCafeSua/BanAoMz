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
        background-color: #003366; /* màu hover đậm hơn */
        color: #fff;
    }
</style>

<div>
    <h3 class="title-primary">${btnText}</h3>

    <a href="/admin/brand" class="btn mb-2">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>

    <!-- Form cho thương hiệu -->
    <div class="card">
        <div class="card-body">
            <form id="brandForm" action="${action}" method="post" onsubmit="validateForm(event)">
                <input type="hidden" class="form-control" name="id" id="id" value="${thuongHieu.id}">

                <!-- Tên thương hiệu -->
                <div class="mb-3">
                    <label for="inputName" class="form-label">Tên thương hiệu</label>
                    <input type="text" class="form-control" name="tenThuongHieu" id="inputName" placeholder="Nhập tên thương hiệu" value="${thuongHieu.tenThuongHieu}">
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
        event.preventDefault(); // Ngăn submit mặc định

        var name = $("#inputName").val().trim();
        if (name === "") {
            toastr.error("Tên danh mục không được để trống");
            return false;
        }


        // Hiển thị xác nhận trước khi gửi form
        Swal.fire({
            title: 'Bạn chắc chắn muốn ${btnText} thương hiệu này?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#001f3d', // màu confirm
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                event.target.submit(); // Gửi form trực tiếp sau khi xác nhận
            }
        });
    }

</script>