<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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

    <a href="/admin/size" class="btn mb-2">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>

    <div class="card">
        <div class="card-body">
            <form id="sizeForm" action="${action}" method="post" onsubmit="validateForm(event)">
                <input type="hidden" class="form-control" name="id" id="id" value="${size.id}">

                <div class="mb-3">
                    <label for="sizeName" class="form-label">Tên Size</label>
                    <input type="text" class="form-control" name="tenSize" id="sizeName" placeholder="Nhập tên size" value="${size.tenSize}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <div>
                        <label>
                            <input type="radio" name="trangThai" value="HOAT_DONG"
                                   <c:if test="${empty size.trangThai || size.trangThai eq 'HOAT_DONG'}">checked</c:if> >
                            Hoạt Động
                        </label>
                        &nbsp;&nbsp;
                        <label>
                            <input type="radio" name="trangThai" value="NGUNG_HOAT_DONG"
                                   <c:if test="${size.trangThai eq 'NGUNG_HOAT_DONG'}">checked</c:if> >
                            Ngừng hoạt động
                        </label>
                    </div>
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

        var name = $("#sizeName").val().trim();
        if (name === "") {
            toastr.error("Tên size không được để trống");
            return false;
        }

        Swal.fire({
            title: 'Bạn chắc chắn muốn ${btnText} này?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#001f3d',
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
