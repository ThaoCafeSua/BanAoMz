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

    <a href="/admin/origin" class="btn mb-2">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>

    <!-- Chỉ còn 1 form -->
    <div class="card">
        <div class="card-body">
            <form id="xuatXuForm" action="${action}" method="post" onsubmit="validateForm(event)">
                <input type="hidden" class="form-control" name="id" id="id" value="${xuatXu.id}">

                <div class="mb-3">
                    <label for="xuatXuName" class="form-label">Tên Xuất Xứ</label>
                    <input type="text" class="form-control" name="tenXuatXu" id="xuatXuName" placeholder="Nhập tên xuất xứ" value="${xuatXu.tenXuatXu}">
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

        var name = $("#xuatXuName").val().trim();
        if (name === "") {
            toastr.error("Tên xuất xứ không được để trống");
            return false;
        }

        Swal.fire({
            title: 'Bạn chắc chắn muốn ${btnText}?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#001f3d', // màu confirm
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                event.target.submit();
            }
        });
    }
</script>
