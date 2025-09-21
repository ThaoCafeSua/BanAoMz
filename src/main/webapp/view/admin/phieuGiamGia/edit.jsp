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
                            <label for="maPhieuGiamGia" class="form-label">Mã Phiếu Giảm Giá</label>
                            <input type="text" class="form-control" name="maPhieuGiamGia" id="maPhieuGiamGia"
                                value="${phieuGiamGia.maPhieuGiamGia}" readonly>
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'maPhieuGiamGia'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="tenPhieuGiamGia" class="form-label">Tên Phiếu Giảm Giá</label>
                            <input type="text" class="form-control" name="tenPhieuGiamGia" id="tenPhieuGiamGia"
                                value="${phieuGiamGia.tenPhieuGiamGia}">
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'tenPhieuGiamGia'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="giaTriGiam" class="form-label">Giá Trị Giảm</label>
                            <input type="number" class="form-control" name="giaTriGiam" id="giaTriGiam"
                                value="${phieuGiamGia.giaTriGiam}">
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'giaTriGiam'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="dieuKienApDung" class="form-label">Điều Kiện Áp Dụng</label>
                            <input type="number" class="form-control" name="dieuKienApDung" id="dieuKienApDung"
                                value="${phieuGiamGia.dieuKienApDung}">
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'dieuKienApDung'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="ngayBatDau" class="form-label">Ngày Bắt Đầu</label>
                            <input type="date" class="form-control" name="ngayBatDau" id="ngayBatDau"
                                value="${phieuGiamGia.ngayBatDau}">
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'ngayBatDau'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="ngayKetThuc" class="form-label">Ngày Kết Thúc</label>
                            <input type="date" class="form-control" name="ngayKetThuc" id="ngayKetThuc"
                                value="${phieuGiamGia.ngayKetThuc}">
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'ngayKetThuc'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="soLuong" class="form-label">Số Lượng</label>
                            <input type="number" class="form-control" name="soLuong" id="soLuong"
                                value="${phieuGiamGia.soLuong}">
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'soLuong'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="moTa" class="form-label">Mô Tả</label>
                            <textarea class="form-control" name="moTa" id="moTa"
                                rows="3">${phieuGiamGia.moTa}</textarea>
                            <c:if test="${not empty org.springframework.validation.BindingResult.phieuGiamGia}">
                                <c:forEach
                                    items="${org.springframework.validation.BindingResult.phieuGiamGia.fieldErrors}"
                                    var="error">
                                    <c:if test="${error.field == 'moTa'}">
                                        <small class="text-danger">${error.defaultMessage}</small>
                                    </c:if>
                                </c:forEach>
                            </c:if>
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

        <script>
            function validateForm(event) {
                event.preventDefault();

                let maPhieu = $("#maPhieuGiamGia").val().trim();
                let tenPhieu = $("#tenPhieuGiamGia").val().trim();
                let giaTriGiam = parseInt($("#giaTriGiam").val().trim());
                let dieuKien = parseInt($("#dieuKienApDung").val().trim());
                let ngayBatDau = $("#ngayBatDau").val();
                let ngayKetThuc = $("#ngayKetThuc").val();
                let soLuong = parseInt($("#soLuong").val().trim());

                if (!tenPhieu) {
                    toastr.error("Tên phiếu không được để trống");
                    return false;
                }
                if (isNaN(giaTriGiam) || giaTriGiam <= 0) {
                    toastr.error("Giá trị giảm phải lớn hơn 0");
                    return false;
                }
                if (isNaN(dieuKien) || dieuKien < 0) {
                    toastr.error("Điều kiện áp dụng phải >= 0");
                    return false;
                }
                if (!ngayBatDau || !ngayKetThuc || new Date(ngayBatDau) > new Date(ngayKetThuc)) {
                    toastr.error("Ngày bắt đầu/kết thúc không hợp lệ");
                    return false;
                }
                if (isNaN(soLuong) || soLuong < 1) {
                    toastr.error("Số lượng phải >= 1");
                    return false;
                }

                Swal.fire({
                    title: 'Bạn chắc chắn muốn ' + $(".btn-submit").text() + '?',
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