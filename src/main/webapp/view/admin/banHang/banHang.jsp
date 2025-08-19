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

        <div class="card mb-3 shadow-sm">
            <div class="card-header text-white py-2" style="background-color: #001f3d;">
                <h6 class="mb-0">Danh sách hóa đơn chờ</h6>
            </div>
            <div class="card-body p-2" id="hoaDonListContainer">

                <!-- Thanh tab ngang -->
                <ul class="nav nav-pills mb-2" id="hoaDonTabs" role="tablist">

                    <li class="nav-item" role="presentation">
                        <button class="nav-link text-success fw-bold" onclick="taoHoaDonMoiVaRender()">+ </button>
                    </li>
                </ul>

            </div>
        </div>
        <!-- Cột trái: Danh sách sản phẩm -->
        <div class="col-md-7">
            <div class="card mb-3">
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
                                    <button class="btn btn-sm btn-primary rounded-circle"
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
        <!-- Cột phải: Hóa đơn chờ → Khách hàng → Giỏ hàng → Thanh toán -->
        <div class="col-md-5">

            <!-- Danh sách hóa đơn chờ dạng tab -->


            <!-- Khách hàng -->
            <div class="card mb-3 shadow-sm">
                <div class="card-header text-white py-2" style="background-color: #001f3d;">
                    <h6 class="mb-0">Khách hàng</h6>
                </div>
                <div class="card-body p-2">
                    <!-- Tìm kiếm + chọn khách -->
                    <div class="mb-2 d-flex gap-2">
                        <input type="text" class="form-control form-control-sm" id="timKhachHangInput" placeholder="Tìm SĐT...">
                        <select class="form-select form-select-sm" id="selectKhachHang"></select>
                    </div>
                    <!-- Người nhận & SĐT -->
                    <div class="row g-2">
                        <div class="col">
                            <input type="text" id="nguoiNhan" class="form-control form-control-sm" placeholder="Người nhận">
                        </div>
                        <div class="col">
                            <input type="text" id="sdtNguoiNhan" class="form-control form-control-sm" placeholder="SĐT người nhận">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Giỏ hàng -->
            <div class="card mb-3 shadow-sm">
                <div class="card-header text-white py-2" style="background-color: #001f3d;">
                    <h5 class="mb-0">Giỏ hàng</h5>
                </div>
                <div class="card-body p-2">
                    <table class="table table-bordered table-sm mb-3 align-middle text-center">
                        <thead class="table-light">
                        <tr>
                            <th>Tên</th>
                            <th>SL</th>
                            <th>Giá</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody id="cartItems"></tbody>
                    </table>

                    <!-- Tổng tiền -->
                    <div class="d-flex justify-content-between align-items-center mt-3 p-2 bg-light rounded">
                        <strong>Tổng tiền:</strong>
                        <strong id="totalAmount" class="text-danger">0 ₫</strong>
                    </div>

                    <!-- Thanh toán -->
                    <button class="btn btn-success w-100 mt-2" id="btnCheckout">
                        💳 Thanh Toán
                    </button>
                </div>
            </div>

        </div>


    </div>
</div>

<!-- Modal chọn màu & size -->
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

    #timKhachHangInput,
    #selectKhachHang,
    #nguoiNhan,
    #sdtNguoiNhan {
        width: 100%;
        max-width: 180px;
    }

    .form-control-sm,
    .form-select-sm {
        padding: 4px 6px;
        font-size: 0.875rem;
        border-radius: 6px;
    }

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

    /* Bỏ viền cũ của Bootstrap */
    #hoaDonTabs .nav-link {
        border: none;
        background: #f8f9fa;
        border-radius: 8px;
        margin-right: 6px;
        padding: 6px 12px;
        font-weight: 500;
        color: #333;
        transition: 0.2s;
        display: flex;
        align-items: center;
    }

    /* Hover nhẹ */
    /* Style cho tab hóa đơn */
    #hoaDonTabs .nav-link {
        border-radius: 8px;
        transition: all 0.3s ease;
        font-weight: 500;
    }
    #hoaDonTabs .nav-link:hover {
        background-color: #f1f1f1;
    }


    .delete-badge {
        display: inline-block;
        background-color: #dc3545;
        color: white;
        font-weight: bold;
        width: 18px;
        height: 18px;
        line-height: 16px;
        text-align: center;
        border-radius: 50%;
        font-size: 12px;
        margin-left: 6px;
        transition: 0.2s;
    }

    .delete-badge:hover {
        background-color: #bb2d3b;
        transform: scale(1.1);
    }

    /* Chỉ hiện nút xóa khi hover vào tab */
    #hoaDonTabs .nav-link .delete-badge {
        opacity: 0;
    }

    #hoaDonTabs .nav-link:hover .delete-badge {
        opacity: 1;
    }

    /* Nút thêm hóa đơn */
    #hoaDonTabs .nav-link.text-success {
        background: #d4edda;
        color: #155724;
        font-size: 18px;
        padding: 4px 12px;
        border-radius: 8px;
    }

    #hoaDonTabs .nav-link.text-success:hover {
        background: #c3e6cb;
    }
    .custom-active {
        background-color: #001f3d !important;
        color: white !important;
        border-radius: 5px; /* bo góc cho đẹp */
    }


</style>


<script>
    const modal = new bootstrap.Modal(document.getElementById('variantModal'));

    let hoaDonList = [];
    try {
        hoaDonList = JSON.parse(localStorage.getItem('hoaDonList')) || [];
        if (!Array.isArray(hoaDonList)) hoaDonList = [];
    } catch (e) {
        hoaDonList = [];
    }

    let currentHoaDonId = hoaDonList.length > 0 ? hoaDonList[0].id : null;

    renderHoaDonList();
    loadCart();

    function taoHoaDonMoiVaRender() {
        // Lấy counter từ localStorage, nếu chưa có thì bắt đầu từ 1
        let counter = parseInt(localStorage.getItem('hoaDonCounter')) || 1;

        // Giới hạn từ 1 đến 1000
        if (counter > 1000) counter = 1;
        const id = 'HD' + counter;
        hoaDonList.push({ id: id, items: [] });
        currentHoaDonId = id;
        counter++;
        localStorage.setItem('hoaDonCounter', counter);
        saveHoaDonList();
        renderHoaDonList();
        loadCart();
    }

    function chonHoaDon(id) {
        console.log("Chọn hóa đơn:", id);
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
        const ul = $('#hoaDonTabs');
        ul.empty();

        hoaDonList.forEach(hd => {
            const isActive = hd.id === currentHoaDonId ? 'active custom-active' : '';
            const li = $('<li>', { class: 'nav-item', role: 'presentation' });
            const btn = $('<button>', {
                class: `nav-link ${isActive}`,
                'data-id': hd.id,
                type: 'button',
                'aria-selected': isActive ? 'true' : 'false'
            }).text(hd.id + ' ');

            const span = $('<span>', {
                class: 'delete-badge ms-1',
                style: 'cursor:pointer;',
                html: '&times;'
            });

            btn.append(span);
            li.append(btn);

            li.find('button').click(() => chonHoaDon(hd.id));
            li.find('span').click(e => {
                e.stopPropagation();
                if (confirm('Xóa hóa đơn này?')) {
                    xoaHoaDon(hd.id);
                }
            });

            ul.append(li);
        });

        // Nút thêm hóa đơn mới
        const addLi = $(`
        <li class="nav-item" role="presentation">
            <button class="nav-link text-success fw-bold" type="button">+</button>
        </li>
    `);
        addLi.find('button').click(() => taoHoaDonMoiVaRender());
        ul.append(addLi);
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
            html += '<td><input type="number" min="1" max="' + tonKho + '" value="' + quantity + '" oninput="capNhatSoLuongLocal(\'' + item.idSPCT + '\', this.value)" class="form-control form-control-sm text-center"/></td>';
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

        const item = hd.items.find(i => String(i.idSPCT) === String(idSPCT));
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
        const idKhachHang = $('#selectKhachHang').val();
        const tenNguoiNhan = $('#nguoiNhan').val().trim();
        const sdtNguoiNhan = $('#sdtNguoiNhan').val().trim();
        const payload = {
            danhSachSanPham: danhSachSanPham,
            idKhachHang: idKhachHang ? parseInt(idKhachHang) : null,
            idPhieuGiamGia: idPhieuGiamGia,
            phuongThucThanhToan: phuongThucThanhToan,
            tenNguoiNhan: tenNguoiNhan,
            sdtNguoiNhan: sdtNguoiNhan
        };

        $.ajax({
            url: '/admin/banHang/thanh-toan',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: function (hoaDon) {
                alert('Thanh toán thành công!\nMã hóa đơn: ' + hoaDon.maHoaDon);

                $('#nguoiNhan').val('');
                $('#sdtNguoiNhan').val('');

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

    let danhSachKhachHang = [];

    $(document).ready(function () {
        loadKhachHangSelect();

        $('#timKhachHangInput').on('input', function () {
            const keyword = $(this).val().toLowerCase().trim();

            const filtered = danhSachKhachHang.filter(kh => {
                const sdt = kh.soDienThoai?.replaceAll(' ', '') ?? '';
                const ten = kh.hoVaTen?.toLowerCase() ?? '';
                return sdt.includes(keyword) || ten.includes(keyword);
            });

            renderKhachHangSelect(filtered);
        });

    });

    function loadKhachHangSelect() {
        $.get("/admin/banHang/danh-sach-khach-hang", function (data) {
            console.log("Dữ liệu KH:", data);
            danhSachKhachHang = data || [];
            renderKhachHangSelect(danhSachKhachHang);
        });
    }

    function renderKhachHangSelect(list) {
        const $select = $('#selectKhachHang');
        $select.empty();

        list.forEach(kh => {
            const id = kh.id ?? '';
            const ten = kh.hoVaTen ?? '';
            const rawSdt = kh.soDienThoai ?? '';
            const sdt = rawSdt.toString().replaceAll(' ', '').trim();
            const hienThi = [ten, sdt && sdt.trim()].filter(Boolean).join(' - ');

            console.log('KH:', { id, ten, rawSdt, sdt, hienThi });

            const $option = $('<option>').val(id).text(hienThi);
            $select.append($option);
        });
    }

    $(document).ready(function () {
        $('#btnThemKhachHang').click(function () {
            const hoVaTen = $('#inputTenKH').val().trim();
            const soDienThoai = $('#inputSDT').val().trim();
            const gioiTinh = $('#inputGioiTinh').val();

            if (!hoVaTen || !soDienThoai || !gioiTinh) {
                toastr.warning("Vui lòng nhập đầy đủ thông tin khách hàng.");
                return;
            }

            $.ajax({
                url: '/admin/banHang/khach-hang/them-nhanh',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    hoVaTen: hoVaTen,
                    soDienThoai: soDienThoai,
                    gioiTinh: gioiTinh
                }),
                success: function (res) {
                    toastr.success("Đã thêm khách hàng mới thành công.");

                    // Đóng modal
                    $('#modalThemKhachHang').modal('hide');

                    $('.modal-backdrop').remove();
                    $('body').removeClass('modal-open').css('padding-right', '');

                    // Làm sạch form
                    $('#inputTenKH').val('');
                    $('#inputSDT').val('');
                    $('#inputGioiTinh').val('Nam');

                    // Reload lại danh sách KH để có khách mới
                    loadKhachHangSelect();

                    // Gán sẵn khách mới vào select
                    $('#selectKhachHang').val(res.id);
                },
                error: function (xhr) {
                    if (xhr.status === 400 || xhr.status === 409) {
                        toastr.error(xhr.responseText);
                    } else {
                        toastr.error("Đã xảy ra lỗi khi thêm khách hàng.");
                    }
                }
            });
        });
    });




</script>

