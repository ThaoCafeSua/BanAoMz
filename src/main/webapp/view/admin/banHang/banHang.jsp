<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<base href="${pageContext.request.contextPath}/" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>


<div class="container-fluid mt-4">
    <div class="row">
        <!-- DANH SÁCH SẢN PHẨM -->
        <div class="col-md-7">
            <div class="card">
                <div class="card-header text-white" style="background-color: #001f3d;">
                    <h5 class="mb-0">Danh sách sản phẩm</h5>
                </div>
                <div class="card-body">
                    <table class="table table-hover" id="productTable">
                        <thead style="background-color: #001f3d; color: white;" class="text-center">
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên</th>
                            <th>SL</th>
                            <th>Giá</th>
                            <th>Thêm</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="sp" items="${sanPhamList}">
                            <tr class="text-center">
                                <td>
                                    <img src="${empty sp.urlAnh ? '/includes/images/default.png' : sp.urlAnh}" width="60" height="60"
                                         onerror="this.src='/includes/images/default.png'"/>
                                </td>
                                <td>${sp.tenSanPham}</td>
                                <td>${sp.soLuongTon}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sp.giaBan != null}">
                                            <fmt:formatNumber value="${sp.giaBan}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                        </c:when>
                                        <c:otherwise>0 ₫</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button
                                            class="btn btn-sm btn-primary rounded-circle"
                                            style="width: 36px; height: 36px; padding: 0;"
                                            data-id="${sp.idSanPham}"
                                            data-ten="${fn:escapeXml(sp.tenSanPham)}"
                                            onclick="openModalFromBtn(this)">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- GIỎ HÀNG -->
        <div class="col-md-5">
            <div class="card">
                <div class="card-header text-white" style="background-color: #001f3d;">
                    <h5 class="mb-0">Giỏ hàng</h5>
                </div>
                <div class="card-body">
                    <table class="table table-bordered">
                        <thead>
                        <tr class="text-center">
                            <th>Tên</th>
                            <th>SL</th>
                            <th>Giá</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody id="cartItems"></tbody>
                    </table>
                    <div class="d-flex justify-content-between mt-3">
                        <strong>Tổng tiền:</strong>
                        <strong id="totalAmount">0 ₫</strong>
                    </div>
                    <button class="btn btn-success w-100 mt-3" id="btnCheckout">Thanh Toán</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL CHỌN MÀU & SIZE -->
<div class="modal fade" id="variantModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chọn màu và size cho <span id="modalTenSanPham"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modalSanPhamId"/>
                <div class="mb-3">
                    <label>Màu sắc:</label>
                    <select class="form-select" id="selectMauSac"></select>
                </div>
                <div class="mb-3">
                    <label>Size:</label>
                    <select class="form-select" id="selectSize"></select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-primary" onclick="chonThuocTinh()">Xác nhận</button>
            </div>
        </div>
    </div>
</div>

<style>
    .table th, .table td {
        border: 1px solid #dcdcdc !important;
        vertical-align: middle !important;
    }

    .table thead {
        background-color: #001f3d;
        color: white;
    }

    .table-striped tbody tr:nth-of-type(odd) {
        background-color: #f9f9f9;
    }

    .btn-primary {
        background-color: #001f3d;
        border: none;
    }

    .btn-primary:hover {
        background-color: #004080;
    }
</style>


<script>
    let invoiceId = localStorage.getItem('invoiceId');
    const modal = new bootstrap.Modal(document.getElementById('variantModal'));
    if (invoiceId) {
        loadCart(); // Khôi phục giỏ hàng nếu invoiceId còn lưu
    }

    function getThuocTinhSanPham(idSanPham, callback) {
        $.ajax({
            url: '/admin/banHang/lay-thuoc-tinh',
            method: 'GET',
            dataType: 'json',
            data: { idSanPham: idSanPham },
            success: function (data) {
                callback(data);
            },
            error: function () {
                toastr.error("Không thể lấy thuộc tính sản phẩm");
            }
        });
    }

    function openModal(id, ten) {
        $('#modalSanPhamId').val(id);
        $('#modalTenSanPham').text(ten);

        getThuocTinhSanPham(id, function (data) {
            $('#selectMauSac').empty();
            $('#selectSize').empty();

            data.mauSacList.forEach(function (item) {
                $('#selectMauSac').append($('<option></option>').val(item.id).text(item.ten));
            });

            data.sizeList.forEach(function (item) {
                $('#selectSize').append($('<option></option>').val(item.id).text(item.ten));
            });

            modal.show();
        });
    }

    function chonThuocTinh() {
        const idSanPham = $('#modalSanPhamId').val();
        const idMau = $('#selectMauSac').val();
        const idSize = $('#selectSize').val();

        if (!idMau || !idSize) {
            alert("Vui lòng chọn đầy đủ màu và size.");
            return;
        }

        $.get('/admin/banHang/tim-san-pham-chi-tiet', {
            idSanPham: idSanPham,
            idMauSac: idMau,
            idSize: idSize
        }, function (res) {
            if (!res.id) {
                alert("Không tìm thấy sản phẩm phù hợp!");
                return;
            }

            const soLuongTon = res.soLuongTon || 0;
            if (soLuongTon <= 0) {
                alert("Sản phẩm đã hết hàng.");
                return;
            }

            const idSPCT = res.id;

            $.post('/admin/banHang/them-san-pham', {
                idHoaDon: invoiceId || '', // Gửi null hoặc rỗng nếu chưa có
                idSanPhamChiTiet: idSPCT,
                soLuong: 1
            }, function (hdct) {
                if (!invoiceId && hdct.hoaDon && hdct.hoaDon.id) {
                    invoiceId = hdct.hoaDon.id;
                    localStorage.setItem('invoiceId', invoiceId);
                }

                modal.hide();
                loadCart();
            });
        });
    }

    function themSanPham(idChiTiet, callback) {
        $.post('/admin/banHang/them-san-pham', {
            idHoaDon: invoiceId,
            idSanPhamChiTiet: idChiTiet,
            soLuong: 1
        }, function () {
            if (typeof callback === 'function') {
                callback();
            }
        });
    }


    function getGioHang(callback) {
        if (!invoiceId) return;

        $.ajax({
            url: '/admin/banHang/danh-sach-san-pham',
            method: 'GET',
            dataType: 'json',
            data: { idHoaDon: invoiceId },
            success: function (data) {
                console.log("✅ Dữ liệu giỏ hàng trả về:");
                console.table(data);
                callback(data);
            },
            error: function () {
                toastr.error("Không thể lấy danh sách sản phẩm trong giỏ hàng");
            }
        });
    }

    function loadCart() {
        getGioHang(function (data) {
            let html = '', total = 0;

            data.forEach(item => {
                const ten = item.tenSanPham || 'Không tên';
                const mau = item.tenMauSac || '';
                const size = item.tenSize || '';
                const quantity = item.soLuong || 0;
                const price = item.giaBan || 0;
                const thanhTien = item.tongTien || (price * quantity);
                const id = item.id;
                const tonKho = item.soLuongTon || 1000; // fallback nếu backend chưa trả về

                const name = ten + ' - ' + mau + ' - ' + size;

                html += '<tr class="text-center">';
                html += '<td>' + name + '</td>';
                html += '<td><input type="number" min="1" max="' + tonKho + '" value="' + quantity + '" onchange="capNhatSoLuong(' + id + ', this.value)" class="form-control form-control-sm text-center"/></td>';
                html += '<td>' + thanhTien.toLocaleString('vi-VN') + ' ₫</td>';
                html += '<td><button class="btn btn-danger btn-sm" onclick="removeItem(' + id + ')">X</button></td>';
                html += '</tr>';

                total += thanhTien;
            });

            $('#cartItems').html(html);
            $('#totalAmount').text(total.toLocaleString('vi-VN') + ' ₫');
        });
    }

    function openModalFromBtn(button) {
        const id = $(button).data('id');
        const ten = $(button).data('ten');
        openModal(id, ten);
    }


    function removeItem(idChiTiet) {
        $.post('/admin/banHang/xoa-san-pham', {
            idHoaDonChiTiet: idChiTiet
        }, function () {
            loadCart();
        });
    }

    $('#btnCheckout').click(function () {
        if (!invoiceId) return;
        $.post('/admin/banHang/thanh-toan', {
            idHoaDon: invoiceId,
            phuongThucThanhToan: 'Tiền mặt'
        }, function () {
            alert("Thanh toán thành công!");
            localStorage.removeItem('invoiceId');
            $('#cartItems').empty();
            $('#totalAmount').text('0 ₫');
            location.reload();
        });
    });
    function capNhatSoLuong(idHoaDonChiTiet, soLuongMoi) {
        soLuongMoi = parseInt(soLuongMoi);
        if (isNaN(soLuongMoi) || soLuongMoi <= 0) {
            alert("Số lượng không hợp lệ!");
            loadCart();
            return;
        }

        $.post('/admin/banHang/cap-nhat-so-luong', {
            idHoaDonChiTiet: idHoaDonChiTiet,
            soLuongMoi: soLuongMoi
        }, function () {
            loadCart();
        }).fail(function (xhr) {
            alert("Không thể cập nhật số lượng: " + xhr.responseText);
            loadCart(); // reset lại nếu lỗi
        });
    }


</script>
