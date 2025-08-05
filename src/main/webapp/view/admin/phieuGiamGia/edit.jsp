<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <style>
            .title-primary {
                color: #001f3d;
                font-weight: bold;
            }

            .label-primary {
                color: #001f3d;
                font-weight: 500;
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
            <h3 class="title-primary">Chỉnh sửa Phiếu Giảm Giá</h3>

            <a href="/admin/phieu-giam-gia" class="btn mb-2">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>

            <div class="card">
                <div class="card-body">
                    <form id="phieuGiamGiaForm" action="/admin/phieu-giam-gia/update" method="post">
                        <input type="hidden" class="form-control" name="id" id="id" value="${phieuGiamGia.id}">

                        <div class="mb-3">
                            <label class="form-label label-primary">Mã Phiếu Giảm Giá:</label>
                            <input type="text" class="form-control" name="maPhieuGiamGia" id="maPhieuGiamGia"
                                value="${phieuGiamGia.maPhieuGiamGia}" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Tên Phiếu Giảm Giá:</label>
                            <input type="text" class="form-control" name="tenPhieuGiamGia" id="tenPhieuGiamGia"
                                value="${phieuGiamGia.tenPhieuGiamGia}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Giá Trị Giảm:</label>
                            <input type="number" class="form-control" name="giaTriGiam" id="giaTriGiam"
                                value="${phieuGiamGia.giaTriGiam}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Điều Kiện Áp Dụng:</label>
                            <input type="number" class="form-control" name="dieuKienApDung" id="dieuKienApDung"
                                value="${phieuGiamGia.dieuKienApDung}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Ngày Bắt Đầu:</label>
                            <input type="date" class="form-control" name="ngayBatDau" id="ngayBatDau"
                                value="${phieuGiamGia.ngayBatDau}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Ngày Kết Thúc:</label>
                            <input type="date" class="form-control" name="ngayKetThuc" id="ngayKetThuc"
                                value="${phieuGiamGia.ngayKetThuc}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Số Lượng:</label>
                            <input type="number" class="form-control" name="soLuong" id="soLuong"
                                value="${phieuGiamGia.soLuong}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Mô Tả:</label>
                            <textarea class="form-control" name="moTa" id="moTa"
                                rows="3">${phieuGiamGia.moTa}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label label-primary">Trạng Thái:</label>

                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <button type="submit" class="btn btn-submit">Cập Nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>