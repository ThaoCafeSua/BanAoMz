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
        </style>

        <div>
            <h3 class="title-primary">Chi tiết Phiếu Giảm Giá</h3>

            <a href="/admin/phieu-giam-gia" class="btn mb-2">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>

            <div class="card">
                <div class="card-body">
                    <input type="hidden" class="form-control" name="id" id="id" value="${phieuGiamGia.id}">

                    <div class="mb-3">
                        <label class="form-label label-primary">Mã Phiếu Giảm Giá:</label>
                        <input type="text" class="form-control" name="maPhieuGiamGia" readonly
                            value="${phieuGiamGia.maPhieuGiamGia}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Tên Phiếu Giảm Giá:</label>
                        <input type="text" class="form-control" name="tenPhieuGiamGia" readonly
                            value="${phieuGiamGia.tenPhieuGiamGia}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Giá Trị Giảm:</label>
                        <input type="text" class="form-control" name="giaTriGiam" readonly
                            value="${phieuGiamGia.giaTriGiam}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Điều Kiện Áp Dụng:</label>
                        <input type="text" class="form-control" name="dieuKienApDung" readonly
                            value="${phieuGiamGia.dieuKienApDung}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Ngày Bắt Đầu:</label>
                        <input type="text" class="form-control" name="ngayBatDau" readonly
                            value="${phieuGiamGia.ngayBatDau}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Ngày Kết Thúc:</label>
                        <input type="text" class="form-control" name="ngayKetThuc" readonly
                            value="${phieuGiamGia.ngayKetThuc}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Số Lượng:</label>
                        <input type="text" class="form-control" name="soLuong" readonly value="${phieuGiamGia.soLuong}">
                    </div>

                    <div class="mb-3">
                        <label class="form-label label-primary">Mô Tả:</label>
                        <textarea class="form-control" name="moTa" readonly rows="3">${phieuGiamGia.moTa}</textarea>
                    </div>

<%--                    <div class="mb-3">--%>
<%--                        <label class="form-label label-primary">Trạng Thái:</label>--%>
<%--                        <input type="text" class="form-control" name="trangThai" readonly--%>
<%--                            value="${phieuGiamGia.trangThai}">--%>
<%--                    </div>--%>
                </div>
            </div>
        </div>