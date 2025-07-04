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
<div class="card mt-3">
    <div class="card-header text-white" style="background-color: #001f3d;">
        <h6 class="mb-0">Danh sách hóa đơn chờ</h6>
    </div>
    <div class="card-body p-2" id="hoaDonListContainer">
        <ul class="list-group" id="hoaDonList">
            <!-- Danh sách hóa đơn sẽ hiển thị ở đây -->
        </ul>
        <button class="btn btn-sm btn-primary mt-2 w-100" onclick="taoHoaDonMoiVaRender()">+ Tạo hóa đơn mới</button>
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
    const modal = new bootstrap.Modal(document.getElementById('variantModal'));

    let hoaDonList = JSON.parse(localStorage.getItem('hoaDonList')) || [];
    let currentHoaDonId = hoaDonList.length > 0 ? hoaDonList[0].id : null;

    renderHoaDonList();
    loadCart();

    function taoHoaDonMoiVaRender() {
        const id = 'HD' + Date.now();
        hoaDonList.push({ id: id, items: [] });
        currentHoaDonId = id;
        saveHoaDonList();
        renderHoaDonList();
        loadCart();
    }

    function chonHoaDon(id) {
        currentHoaDonId = id;
        renderHoaDonList();
        loadCart();
    }

    function xoaHoaDon(id) {
        hoaDonList = hoaDonList.filter(hd => hd.id !== id);
        if (currentHoaDonId === id) {
            currentHoaDonId = hoaDonList.length > 0 ? hoaDonList[0].id : null;
        }
        saveHoaDonList();
        renderHoaDonList();
        loadCart();
    }

    function saveHoaDonList() {
        localStorage.setItem('hoaDonList', JSON.stringify(hoaDonList));
    }

    function renderHoaDonList() {
        const ul = $('#hoaDonList');
        ul.empty();

        hoaDonList.forEach(hd => {
            const li = $('<li class="list-group-item d-flex justify-content-between align-items-center"></li>');
            const text = $('<span></span>').text(hd.id);
            const removeBtn = $('<button class="btn btn-sm btn-danger ms-2"><i class="fa fa-trash"></i></button>').click(e => {
                e.stopPropagation();
                if (confirm('Xóa hóa đơn này?')) {
                    xoaHoaDon(hd.id);
                }
            });
            li.append(text).append(removeBtn);
            li.click(() => chonHoaDon(hd.id));
            if (hd.id === currentHoaDonId) li.addClass('active');
            ul.append(li);
        });
    }

    function openModalFromBtn(button) {
        const id = $(button).data('id');
        const ten = $(button).data('ten');
        openModal(id, ten);
    }

    function openModal(idSanPham, tenSanPham) {
        $('#modalSanPhamId').val(idSanPham);
        $('#modalTenSanPham').text(tenSanPham);

        $.get('/admin/banHang/lay-thuoc-tinh', { idSanPham: idSanPham }, function (data) {
            const mauSacList = data.mauSacList || [];
            const sizeList = data.sizeList || [];
            const chiTietList = data.sanPhamChiTietList || [];

            const sizeTheoMau = {};
            chiTietList.forEach(item => {
                if (!sizeTheoMau[item.idMauSac]) sizeTheoMau[item.idMauSac] = new Set();
                sizeTheoMau[item.idMauSac].add(item.idSize);
            });

            $('#selectMauSac').empty();
            $('#selectSize').empty();

            mauSacList.forEach(mau => {
                $('#selectMauSac').append($('<option></option>').val(mau.id).text(mau.ten));
            });

            $('#selectMauSac').off('change').on('change', function () {
                const selectedMau = $(this).val();
                $('#selectSize').empty();
                const sizeIds = sizeTheoMau[selectedMau] || new Set();
                sizeList.forEach(size => {
                    if (sizeIds.has(size.id)) {
                        $('#selectSize').append($('<option></option>').val(size.id).text(size.ten));
                    }
                });
            });

            $('#selectMauSac').trigger('change');
            modal.show();
        });
    }

    function chonThuocTinh() {
        const idSanPham = $('#modalSanPhamId').val();
        const idMau = $('#selectMauSac').val();
        const idSize = $('#selectSize').val();

        if (!idMau || !idSize || !currentHoaDonId) {
            alert('Vui lòng chọn đầy đủ và tạo hóa đơn trước.');
            return;
        }

        $.get('/admin/banHang/tim-san-pham-chi-tiet', {
            idSanPham: idSanPham,
            idMauSac: idMau,
            idSize: idSize
        }, function (res) {
            if (!res.id) {
                alert('Không tìm thấy sản phẩm phù hợp!');
                return;
            }

            if (res.soLuongTon <= 0) {
                alert('Sản phẩm đã hết hàng.');
                return;
            }

            const hd = hoaDonList.find(h => h.id === currentHoaDonId);
            if (!hd) return;

            const spct = {
                idSPCT: res.id,
                ten: res.tenSanPham,
                mau: res.tenMauSac,
                size: res.tenSize,
                soLuong: 1,
                giaBan: res.giaBan || 0,
                soLuongTon: res.soLuongTon
            };

            const existing = hd.items.find(i => i.idSPCT === spct.idSPCT);
            if (existing) {
                if (existing.soLuong < spct.soLuongTon) {
                    existing.soLuong += 1;
                } else {
                    alert('Đã đạt số lượng tối đa trong kho.');
                }
            } else {
                hd.items.push(spct);
            }
            console.log('👉 Sản phẩm sau khi thêm:', hd.items);
            saveHoaDonList();
            modal.hide();
            loadCart();
        });
    }


    function loadCart() {
        const hd = hoaDonList.find(h => h.id === currentHoaDonId);
        if (!hd) {
            $('#cartItems').html('<tr><td colspan="4" class="text-center">Chưa có hóa đơn nào</td></tr>');
            $('#totalAmount').text('0 ₫');
            return;
        }
        console.log('🛒 Danh sách sản phẩm trong giỏ:', hd.items);  // LOG KIỂM TRA
        let html = '', total = 0;

        hd.items.forEach(item => {
            const ten = item.ten || 'Không tên';
            const mau = item.mau || '';
            const size = item.size || '';
            const quantity = item.soLuong || 0;
            const price = item.giaBan || 0;
            const tonKho = item.soLuongTon || 1000;
            const thanhTien = price * quantity;

            const name = ten + ' - ' + mau + ' - ' + size;

            html += '<tr class="text-center">';
            html += '<td>' + name + '</td>';
            html += '<td><input type="number" min="1" max="' + tonKho + '" value="' + quantity + '" onchange="capNhatSoLuongLocal(\'' + item.idSPCT + '\', this.value)" class="form-control form-control-sm text-center"/></td>';
            html += '<td>' + thanhTien.toLocaleString('vi-VN') + ' ₫</td>';
            html += '<td><button class="btn btn-danger btn-sm" onclick="xoaSanPhamLocal(\'' + item.idSPCT + '\')">X</button></td>';
            html += '</tr>';

            total += thanhTien;
        });

        if (hd.items.length === 0) {
            html = '<tr><td colspan="4" class="text-center">Giỏ hàng trống</td></tr>';
        }

        $('#cartItems').html(html);
        $('#totalAmount').text(total.toLocaleString('vi-VN') + ' ₫');
    }


    function capNhatSoLuongLocal(idSPCT, soLuongMoi) {
        const hd = hoaDonList.find(h => h.id === currentHoaDonId);
        if (!hd) return;

        const item = hd.items.find(i => i.idSPCT === idSPCT);
        if (!item) return;

        soLuongMoi = parseInt(soLuongMoi);
        if (isNaN(soLuongMoi) || soLuongMoi <= 0) return;

        if (soLuongMoi > item.soLuongTon) {
            alert('Vượt quá tồn kho.');
            return;
        }

        item.soLuong = soLuongMoi;
        saveHoaDonList();
        loadCart();
    }

    function xoaSanPhamLocal(idSPCT) {
        const hd = hoaDonList.find(h => h.id === currentHoaDonId);
        if (!hd) return;
        hd.items = hd.items.filter(i => String(i.idSPCT) !== String(idSPCT));
        saveHoaDonList();
        loadCart();
    }

    function xoaTatCaSanPham() {
        const hd = hoaDonList.find(h => h.id === currentHoaDonId);
        if (!hd) return;
        if (confirm('Xóa toàn bộ sản phẩm trong giỏ?')) {
            hd.items = [];
            saveHoaDonList();
            loadCart();
        }
    }

    $('#btnCheckout').click(function () {
        const hd = hoaDonList.find(h => h.id === currentHoaDonId);
        if (!hd || hd.items.length === 0) {
            alert('Giỏ hàng trống.');
            return;
        }

        // Chuẩn bị dữ liệu
        const danhSachSanPham = hd.items.map(item => ({
            idSanPhamChiTiet: item.idSPCT,
            soLuong: item.soLuong
        }));

        const idPhieuGiamGia = hd.idPhieuGiamGia || null;  // Nếu bạn có chọn mã giảm giá, gán vào hd.idPhieuGiamGia
        const phuongThucThanhToan = $('#phuongThucThanhToan').val() || 'TIEN_MAT';  // Lấy từ select nếu có

        const payload = {
            danhSachSanPham: danhSachSanPham,
            idPhieuGiamGia: idPhieuGiamGia,
            phuongThucThanhToan: phuongThucThanhToan
        };

        $.ajax({
            url: '/admin/banHang/thanh-toan',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function (hoaDon) {
                alert('Thanh toán thành công!\nMã hóa đơn: ' + hoaDon.maHoaDon);

                hoaDonList = hoaDonList.filter(h => h.id !== currentHoaDonId);
                currentHoaDonId = hoaDonList.length > 0 ? hoaDonList[0].id : null;
                saveHoaDonList();
                renderHoaDonList();
                loadCart();

            },
            error: function (xhr) {
                alert('Lỗi thanh toán: ' + xhr.responseText);
            }
        });
    });

</script>

