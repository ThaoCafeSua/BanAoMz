<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<div class="container">
    <div class="card mt-4" style="border: 1px solid #006d7f; background-color: white;">
        <div class="card-body">
            <h4 style="color: #001f3d;">📄 Quản Lý Hóa Đơn</h4>

            <table class="table table-hover" id="hoaDonTable">
                <thead style="background-color: #001f3d; color: white;">
                <tr class="text-center">
                    <th>#</th>
                    <th>Mã Hóa Đơn</th>
                    <th>Ngày Đặt</th>
                    <th>Khách Hàng</th>
                    <th>SĐT</th>
                    <th>Loại</th>
                    <th>Thành Tiền</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="hd" items="${hoaDonList}" varStatus="stt">
                    <tr class="text-center">
                        <td>${stt.index + 1}</td>

                        <td><c:out value="${hd.maHoaDon}" /></td>

                        <td>
                            <span class="date" data-iso="${hd.ngayDat}">
                                <c:out value="${hd.ngayDat}" />
                            </span>
                        </td>

                        <td><c:out value="${hd.khachHangTen}" default="Khách lẻ"/></td>

                        <td><c:out value="${hd.soDienThoai}" default=""/></td>

                        <td>
                            <c:choose>
                                <c:when test="${hd.loaiHoaDon == 'TAI_QUAY'}">
                                    <span class="badge bg-primary">Bán tại quầy</span>
                                </c:when>
                                <c:when test="${hd.loaiHoaDon == 'ONLINE'}">
                                    <span class="badge bg-info text-dark">Bán online</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Không rõ</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${hd.thanhTien != null}">
                                    <fmt:formatNumber value="${hd.thanhTien}" type="number" pattern="#,###"/>₫
                                </c:when>
                                <c:otherwise>0₫</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${hd.trangThai == 'CHO_XAC_NHAN'}">
                                    <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'CHO_CHUAN_BI_HANG'}">
                                    <span class="badge bg-info text-dark">Chờ chuẩn bị hàng</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'DANG_GIAO'}">
                                    <span class="badge bg-primary">Đang giao</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'GIAO_THAT_BAI'}">
                                    <span class="badge bg-dark">Giao thất bại</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'HOAN_HANG'}">
                                    <span class="badge bg-secondary">Đang hoàn hàng</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'DA_HOAN_HANG'}">
                                    <span class="badge bg-secondary">Đã hoàn hàng</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'HOAN_THANH'}">
                                    <span class="badge bg-success">Hoàn thành</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'HUY'}">
                                    <span class="badge bg-danger">Huỷ</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-light text-dark">Không rõ</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <button class="btn btn-sm btn-info btnChiTiet" data-id="${hd.id}" title="Xem chi tiết">
                                <i class="fa-solid fa-eye"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

        </div>
    </div>
</div>

<style>
    .table th, .table td { border: 1px solid #dee2e6 !important; vertical-align: middle; }
    .table-hover tbody tr:hover { background-color: #f1f1f1; }
    .btn-info { background-color: #007bff; color: white; border: none; }
    .btn-info:hover { background-color: #0056b3; }
</style>

<script>
    function formatVNDate(iso) {
        try {
            if (!iso) return '';
            var d = new Date(iso);
            if (isNaN(d.getTime())) return iso; // fallback nếu trình duyệt không parse được

            function pad(n){ return n < 10 ? '0' + n : n; }

            return pad(d.getDate()) + '/' +
                pad(d.getMonth() + 1) + '/' +
                d.getFullYear() + ' ' +
                pad(d.getHours()) + ':' +
                pad(d.getMinutes());
        } catch (e) {
            return iso;
        }
    }

    $(function () {
        document.querySelectorAll('.date').forEach(function (el) {
            var iso = el.getAttribute('data-iso');
            el.textContent = formatVNDate(iso);
        });

        $('#hoaDonTable').DataTable({
            paging: true,
            ordering: false,
            info: false,
            lengthChange: false,
            language: { url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json' },
            columnDefs: [{ className: "text-center", targets: "_all" }]
        });

        $(document).on("click", ".btnChiTiet", function () {
            var id = $(this).data("id");
            window.location.href = "/admin/hoaDon/chiTiet/" + id;
        });
    });
</script>
