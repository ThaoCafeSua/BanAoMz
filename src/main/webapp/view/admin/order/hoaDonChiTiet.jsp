<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
<meta name="_csrf" content="${_csrf != null ? _csrf.token : ''}"/>
<meta name="_csrf_header" content="${_csrf != null ? _csrf.headerName : ''}"/>

<div class="container mt-4">
    <div class="border rounded-4 shadow-sm p-4">
        <div class="d-flex align-items-center mb-4">
            <i class="fas fa-file-invoice fa-2x me-2 text-primary"></i>
            <h4 class="mb-0 fw-bold">
                Chi Tiết Hóa Đơn - <c:out value="${hoaDonDetail.maHoaDon}" default="Không có"/>
            </h4>
        </div>

        <div class="card-body">
            <!-- Thông tin đầu trang -->
            <div class="row mb-3">
                <!-- Cột trái -->
                <div class="col-md-6">
                    <p class="mb-2"><strong>Mã hóa đơn:</strong>
                        <c:out value="${hoaDonDetail.maHoaDon}" default="Không có"/>
                    </p>

                    <p class="mb-2"><strong>Loại hóa đơn:</strong>
                        <c:choose>
                            <c:when test="${hoaDonDetail.loaiHoaDon == 'TAI_QUAY'}">
                                <span class="badge bg-info">Bán tại quầy</span>
                            </c:when>
                            <c:when test="${hoaDonDetail.loaiHoaDon == 'ONLINE'}">
                                <span class="badge bg-warning text-dark">Bán online</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Không rõ</span>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <p class="mb-2"><strong>Trạng thái:</strong>
                        <span id="label-status">
              <c:choose>
                  <c:when test="${hoaDonDetail.trangThai == 'CHO_XAC_NHAN'}">
                      <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'CHO_CHUAN_BI_HANG'}">
                      <span class="badge bg-info text-dark">Chờ chuẩn bị hàng</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'DANG_GIAO'}">
                      <span class="badge bg-primary">Đang giao</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'GIAO_THAT_BAI'}">
                      <span class="badge bg-dark">Giao thất bại</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'HOAN_HANG'}">
                      <span class="badge bg-secondary">Đang hoàn hàng</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'DA_HOAN_HANG'}">
                      <span class="badge bg-secondary">Đã hoàn hàng</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'HOAN_THANH'}">
                      <span class="badge bg-success">Hoàn thành</span>
                  </c:when>
                  <c:when test="${hoaDonDetail.trangThai == 'HUY'}">
                      <span class="badge bg-danger">Huỷ</span>
                  </c:when>
                  <c:otherwise>
                      <span class="badge bg-light text-dark">Không rõ</span>
                  </c:otherwise>
              </c:choose>
            </span>
                    </p>

                    <spring:eval
                            expression="hoaDonDetail.ngayDat != null ?
            T(java.time.format.DateTimeFormatter).ofPattern('dd/MM/yyyy HH:mm')
              .format(hoaDonDetail.ngayDat) : null"
                            var="ngayDatFmt"/>
                    <p class="mb-2"><strong>Ngày đặt:</strong>
                        <c:out value="${ngayDatFmt}" default="Không có"/>
                    </p>

                    <p class="mb-2"><strong>Phương thức thanh toán:</strong>
                        <c:out value="${hoaDonDetail.phuongThucThanhToan}" default="Không có"/>
                    </p>
                </div>

                <!-- Cột phải -->
                <div class="col-md-6">
                    <p class="mb-2"><strong>Khách hàng (tài khoản):</strong>
                        <c:out value="${hoaDonDetail.khachHangTen}" default="Khách lẻ"/>
                    </p>
                    <p class="mb-2"><strong>Người nhận (đơn hàng):</strong>
                        <c:out value="${hoaDonDetail.tenNguoiNhan}" default="Không có"/>
                    </p>
                    <p class="mb-2"><strong>Điện thoại nhận:</strong>
                        <c:out value="${hoaDonDetail.soDienThoaiNguoiNhan}" default="Không có"/>
                    </p>
                    <p class="mb-2"><strong>Địa chỉ nhận:</strong>
                        <c:out value="${hoaDonDetail.diaChiNguoiNhan}" default="Không có"/>
                    </p>
                </div>
            </div>

            <!-- Stepper: đưa ra hàng riêng, full width, canh giữa -->
            <c:if test="${hoaDonDetail.loaiHoaDon == 'ONLINE'}">
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
                            <h6 class="mb-0">Đổi trạng thái (ONLINE)</h6>
                        </div>

                        <div class="status-scroll">
                            <div id="statusFlow"
                                 class="status-flow"
                                 data-current="${hoaDonDetail.trangThai}"
                                 data-id="${hoaDonDetail.id}">
                                <!-- Không dùng spacer để tránh lệch -->
                                <button class="status-item" data-status="CHO_XAC_NHAN" title="Chờ xác nhận">
                                    <i class="fa-solid fa-hourglass-half"></i><span>Chờ xác nhận</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item" data-status="CHO_CHUAN_BI_HANG" title="Chờ chuẩn bị hàng">
                                    <i class="fa-solid fa-boxes-stacked"></i><span>Chuẩn bị hàng</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item" data-status="DANG_GIAO" title="Đang giao">
                                    <i class="fa-solid fa-truck-fast"></i><span>Đang giao</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item" data-status="HOAN_THANH" title="Hoàn thành">
                                    <i class="fa-solid fa-circle-check"></i><span>Hoàn thành</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item warn" data-status="GIAO_THAT_BAI" title="Giao thất bại">
                                    <i class="fa-solid fa-triangle-exclamation"></i><span>Giao thất bại</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item return" data-status="HOAN_HANG" title="Đang hoàn hàng">
                                    <i class="fa-solid fa-rotate-left"></i><span>Hoàn hàng</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item return" data-status="DA_HOAN_HANG" title="Đã hoàn hàng về kho">
                                    <i class="fa-solid fa-warehouse"></i><span>Đã hoàn hàng</span>
                                </button>
                                <div class="status-line"></div>

                                <button class="status-item danger" data-status="HUY" title="Huỷ đơn">
                                    <i class="fa-solid fa-ban"></i><span>Huỷ</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Danh sách sản phẩm -->
            <h5>Danh sách sản phẩm</h5>
            <c:choose>
                <c:when test="${empty chiTietList}">
                    <p>Không có sản phẩm nào.</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle">
                            <thead class="table-secondary">
                            <tr class="text-center">
                                <th>#</th>
                                <th>Sản phẩm</th>
                                <th>Màu sắc</th>
                                <th>Size</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="ct" items="${chiTietList}" varStatus="i">
                                <tr class="text-center">
                                    <td>${i.index + 1}</td>
                                    <td><c:out value="${ct.tenSanPham}" default="Không có"/></td>
                                    <td><c:out value="${ct.mauSac}" default="Không có"/></td>
                                    <td><c:out value="${ct.size}" default="Không có"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ct.giaBan != null}">
                                                <fmt:formatNumber value="${ct.giaBan}" type="number" pattern="#,###"/>₫
                                            </c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${ct.soLuong}" default="0"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ct.thanhTien != null}">
                                                <fmt:formatNumber value="${ct.thanhTien}" type="number" pattern="#,###"/>₫
                                            </c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Tổng kết tiền -->
            <div class="mt-4 text-end">
                <p class="mb-1"><strong>Tổng tiền:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.tongTien != null}">
                            <fmt:formatNumber value="${hoaDonDetail.tongTien}" type="number" pattern="#,###"/>₫
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </p>

                <p class="mb-1"><strong>Tiền giảm:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.tienGiam != null}">
                            <fmt:formatNumber value="${hoaDonDetail.tienGiam}" type="number" pattern="#,###"/>₫
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </p>

                <p class="mb-1"><strong>Phí vận chuyển:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.phiVanChuyen != null}">
                            <fmt:formatNumber value="${hoaDonDetail.phiVanChuyen}" type="number" pattern="#,###"/>₫
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </p>

                <h5 class="mt-3"><strong>Thành tiền:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.thanhTien != null}">
                            <fmt:formatNumber value="${hoaDonDetail.thanhTien}" type="number" pattern="#,###"/>₫
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </h5>
            </div>

            <!-- Action -->
            <div class="mt-4 text-end">
                <a href="/admin/hoaDon/xuat-pdf/${hoaDonDetail.id}"
                   class="btn btn-outline-danger rounded-pill px-4 py-2 shadow-sm me-2">
                    <i class="fa-solid fa-file-pdf me-2 fa-lg"></i> Xuất PDF
                </a>
                <a href="/admin/hoaDon" class="btn btn-secondary rounded-pill px-4 py-2 shadow-sm">
                    <i class="fa fa-arrow-left me-2"></i> Quay lại
                </a>
            </div>
        </div>
    </div>
</div>

<style>
    /* Bảng & card */
    .table th, .table td { border: 1px solid #dee2e6 !important; }
    .table-hover tbody tr:hover { background-color: #f8f9fa; }
    .rounded-4{ border-radius:1rem; }

    /* Thanh cuộn nhẹ cho stepper trên mobile */
    .status-scroll{ overflow:auto; padding-bottom:.25rem; }

    /* Stepper canh giữa */
    .status-flow{
        display:flex; align-items:center; justify-content:center;
        gap:10px; flex-wrap:wrap;
    }
    .status-flow .status-spacer{ display:none !important; } /* nếu còn trong DOM thì ẩn */

    .status-item{
        display:flex; flex-direction:column; align-items:center; gap:6px;
        border:1px solid #dee2e6; background:#fff; padding:10px 12px;
        border-radius:12px; min-width:140px; cursor:pointer; transition:.2s;
        text-align:center;
    }
    .status-item i{ font-size:18px; }
    .status-item span{ font-size:12px; font-weight:600; white-space:nowrap; }

    /* States từ JS của bạn (giữ nguyên cách đặt class) */
    .status-item.done{ border-color:#20c997; color:#20c997; background:#eafff5; }
    .status-item.current{
        border-color:#0d6efd; color:#0d6efd;
        box-shadow:0 0 0 3px rgba(13,110,253,.15); background:#eef5ff;
    }
    .status-item.allowed{ border-color:#0dcaf0; color:#0dcaf0; background:#ecfbff; }
    .status-item.allowed:hover{ filter:brightness(.96); }
    .status-item.disabled{ opacity:.35; cursor:not-allowed; pointer-events:none; }

    /* Nhóm cảnh báo / hoàn / huỷ */
    .status-item.danger{ border-color:#dc3545; color:#dc3545; background:#fff5f6; }
    .status-item.warn{ border:1px dashed #6c757d; color:#343a40; background:#f5f6f7; }
    .status-item.return{ border-color:#6c757d; color:#6c757d; background:#f7f7f7; }

    .status-line{ height:2px; width:28px; background:#dee2e6; border-radius:1px; }

    /* Responsive tweak: nhỏ hơn md thì thu nhỏ min-width item */
    @media (max-width: 768px){
        .status-item{ min-width:120px; padding:8px 10px; }
        .status-line{ width:18px; }
    }
</style>

<script>
    /* =========================
       Helpers
    ========================= */
    function getCsrfHeaders() {
        const token  = document.querySelector('meta[name="_csrf"]')?.content;
        const header = document.querySelector('meta[name="_csrf_header"]')?.content;
        return (token && header) ? { [header]: token } : {};
    }

    // Gọi API và tự động "unwrap" ApiResponse{ data, message, ... }
    async function api(url, options) {
        const res = await fetch(url, {
            headers: { Accept: 'application/json', ...(options?.headers || {}) },
            ...options
        });
        const ct  = res.headers.get('content-type') || '';
        const raw = ct.includes('application/json') ? await res.json() : await res.text();

        if (!res.ok) {
            // Ưu tiên message bên server
            const msg = (raw && typeof raw === 'object')
                ? (raw.message || raw.error || 'Có lỗi xảy ra')
                : (raw || 'Có lỗi xảy ra');
            throw new Error(msg);
        }
        // Dạng ApiResponse => trả về data, nếu không có thì trả raw
        if (raw && typeof raw === 'object' && 'data' in raw) return raw.data;
        return raw;
    }

    // Map badge trạng thái để cập nhật UI
    const BADGE = {
        'CHO_XAC_NHAN'      : '<span class="badge bg-warning text-dark">Chờ xác nhận</span>',
        'CHO_CHUAN_BI_HANG' : '<span class="badge bg-info text-dark">Chờ chuẩn bị hàng</span>',
        'DANG_GIAO'         : '<span class="badge bg-primary">Đang giao</span>',
        'GIAO_THAT_BAI'     : '<span class="badge bg-dark">Giao thất bại</span>',
        'HOAN_HANG'         : '<span class="badge bg-secondary">Đang hoàn hàng</span>',
        'DA_HOAN_HANG'      : '<span class="badge bg-secondary">Đã hoàn hàng</span>',
        'HOAN_THANH'        : '<span class="badge bg-success">Hoàn thành</span>',
        'HUY'               : '<span class="badge bg-danger">Huỷ</span>'
    };

    // Thứ tự các bước chính
    const ORDER = ['CHO_XAC_NHAN', 'CHO_CHUAN_BI_HANG', 'DANG_GIAO', 'HOAN_THANH'];

    // Ma trận chuyển trạng thái (khớp với Service)
    const TRANSITIONS = {
        CHO_XAC_NHAN:      ['CHO_CHUAN_BI_HANG','HUY'],
        CHO_CHUAN_BI_HANG: ['DANG_GIAO','HUY'],
        DANG_GIAO:         ['HOAN_THANH','GIAO_THAT_BAI'],
        GIAO_THAT_BAI:     ['DANG_GIAO','HOAN_HANG','HUY'],
        HOAN_HANG:         ['DA_HOAN_HANG'],
        DA_HOAN_HANG:      [],
        HOAN_THANH:        [],
        HUY:               []
    };

    // Cập nhật nhãn trạng thái trên header
    function setStatusBadge(status) {
        const label = document.getElementById('label-status');
        if (label) label.innerHTML = BADGE[status] || `<span class="badge bg-light text-dark">${status}</span>`;
    }

    // Khởi tạo stepper
    (function initStatusFlow(){
        const flow = document.getElementById('statusFlow');
        if (!flow) return;

        let current = (flow.dataset.current || '').toUpperCase();
        const id    = flow.dataset.id;
        const items = [...flow.querySelectorAll('.status-item')];

        function refreshUI() {
            items.forEach(btn => {
                const s = btn.dataset.status.toUpperCase();
                btn.classList.remove('done', 'current', 'allowed', 'disabled');

                // Đánh dấu các bước đã qua (chỉ với các bước trong ORDER)
                if (ORDER.includes(s) && ORDER.includes(current) && ORDER.indexOf(s) < ORDER.indexOf(current)) {
                    btn.classList.add('done');
                }
                if (s === current) {
                    btn.classList.add('current');
                }

                const allowed = (TRANSITIONS[current] || []);
                if (allowed.includes(s)) {
                    btn.classList.add('allowed');
                } else if (s !== current) {
                    btn.classList.add('disabled');
                }
            });
        }

        async function updateStatus(next) {
            // Chặn click nhiều lần
            items.forEach(b => b.disabled = true);
            try {
                const data = await api(`/admin/hoaDon/${id}/trang-thai`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                        ...getCsrfHeaders()
                    },
                    body: new URLSearchParams({ trangThai: next })
                });

                // data lúc này là HoaDonDetailResponseDTO (đã "unwrap")
                current = (data?.trangThai || next).toUpperCase();
                flow.dataset.current = current;

                refreshUI();
                setStatusBadge(current);

                alert('Đã cập nhật trạng thái thành công!');
                // (Tuỳ chọn) Nếu muốn đồng bộ thêm dữ liệu khác sau khi đổi trạng thái,
                // có thể gọi lại detail và cập nhật DOM:
                // const fresh = await api(`/admin/hoaDon/${id}/api/detail`, { method: 'GET' });
                // ...cập nhật các vùng cần thiết từ fresh ...
            } catch (e) {
                console.error(e);
                alert('Cập nhật thất bại: ' + e.message);
            } finally {
                items.forEach(b => b.disabled = false);
            }
        }

        // Gán click
        items.forEach(btn => {
            btn.addEventListener('click', () => {
                if (btn.classList.contains('allowed')) {
                    const next = btn.dataset.status;
                    updateStatus(next);
                }
            });
        });

        // Lần đầu vẽ UI
        refreshUI();
    })();
</script>
