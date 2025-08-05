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

            <a href="/admin/phieu-giam-gia" class="btn mb-2">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>

            <div class="card">
                <div class="card-body">
                    <form id="phieuGiamGiaForm" action="${action}" method="post" onsubmit="validateForm(event)">
                        <input type="hidden" class="form-control" name="id" id="id" value="${phieuGiamGia.id}">

                        <div class="mb-3">
                            <label for="maPhieuGiamGia" class="form-label">Mã Phiếu Giảm Giá</label>
                            <input type="text" class="form-control" name="maPhieuGiamGia" id="maPhieuGiamGia"
                                placeholder="Nhập mã phiếu giảm giá" value="${phieuGiamGia.maPhieuGiamGia}">
                        </div>

                        <div class="mb-3">
                            <label for="tenPhieuGiamGia" class="form-label">Tên Phiếu Giảm Giá</label>
                            <input type="text" class="form-control" name="tenPhieuGiamGia" id="tenPhieuGiamGia"
                                placeholder="Nhập tên phiếu giảm giá" value="${phieuGiamGia.tenPhieuGiamGia}">
                        </div>

                        <div class="mb-3">
                            <label for="giaTriGiam" class="form-label">Giá Trị Giảm</label>
                            <input type="number" class="form-control" name="giaTriGiam" id="giaTriGiam"
                                placeholder="Nhập giá trị giảm" value="${phieuGiamGia.giaTriGiam}">
                        </div>

                        <div class="mb-3">
                            <label for="dieuKienApDung" class="form-label">Điều Kiện Áp Dụng</label>
                            <input type="number" class="form-control" name="dieuKienApDung" id="dieuKienApDung"
                                placeholder="Nhập điều kiện áp dụng" value="${phieuGiamGia.dieuKienApDung}">
                        </div>

                        <div class="mb-3">
                            <label for="ngayBatDau" class="form-label">Ngày Bắt Đầu</label>
                            <input type="date" class="form-control" name="ngayBatDau" id="ngayBatDau"
                                value="${phieuGiamGia.ngayBatDau}">
                        </div>

                        <div class="mb-3">
                            <label for="ngayKetThuc" class="form-label">Ngày Kết Thúc</label>
                            <input type="date" class="form-control" name="ngayKetThuc" id="ngayKetThuc"
                                value="${phieuGiamGia.ngayKetThuc}">
                        </div>

                        <div class="mb-3">
                            <label for="soLuong" class="form-label">Số Lượng</label>
                            <input type="number" class="form-control" name="soLuong" id="soLuong"
                                placeholder="Nhập số lượng" value="${phieuGiamGia.soLuong}">
                        </div>

                        <div class="mb-3">
                            <label for="moTa" class="form-label">Mô Tả</label>
                            <textarea class="form-control" name="moTa" id="moTa" rows="3"
                                placeholder="Nhập mô tả">${phieuGiamGia.moTa}</textarea>
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
                event.preventDefault();

                var maPhieu = $("#maPhieuGiamGia").val().trim();
                var tenPhieu = $("#tenPhieuGiamGia").val().trim();
                var giaTriGiam = $("#giaTriGiam").val().trim();
                var dieuKien = $("#dieuKienApDung").val().trim();

                if (maPhieu === "" || tenPhieu === "" || giaTriGiam === "" || dieuKien === "") {
                    toastr.error("Vui lòng điền đầy đủ thông tin");
                    return false;
                }

                Swal.fire({
                    title: 'Bạn chắc chắn muốn ${btnText}?',
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