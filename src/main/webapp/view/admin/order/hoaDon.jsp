<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

<!-- jQuery + DataTables -->
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
                    <th>Ngày Tạo</th>
                    <th>Loại Hóa Đơn</th>
                    <th>Tổng Tiền</th>
                    <th>Thành Tiền</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="hd" items="${hoaDonList}" varStatus="stt">
                    <tr class="text-center">
                        <td>${stt.index + 1}</td>
                        <td>${hd.maHoaDon}</td>
                        <td>${hd.ngayTao}</td>
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

                        <td><fmt:formatNumber value="${hd.tongTien}" type="currency" currencySymbol="₫"/></td>
                        <td><fmt:formatNumber value="${hd.thanhTien}" type="currency" currencySymbol="₫"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${hd.trangThai == 'CHO_THANH_TOAN'}">
                                    <span class="badge bg-warning text-dark">Chờ thanh toán</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'DA_THANH_TOAN'}">
                                    <span class="badge bg-success">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${hd.trangThai == 'DA_HUY'}">
                                    <span class="badge bg-danger">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Không rõ</span>
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
    .table th, .table td {
        border: 1px solid #dee2e6 !important;
        vertical-align: middle;
    }

    .table-hover tbody tr:hover {
        background-color: #f1f1f1;
    }

    .btn-info {
        background-color: #007bff;
        color: white;
        border: none;
    }

    .btn-info:hover {
        background-color: #0056b3;
    }
</style>

<script>
    $(document).ready(function () {
        $('#hoaDonTable').DataTable({
            paging: true,
            ordering: false,
            info: false,
            lengthChange: false,
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
            },
            columnDefs: [
                { className: "text-center", targets: "_all" }
            ]
        });

        $(document).on("click", ".btnChiTiet", function () {
            const id = $(this).data("id");
            window.location.href = "/admin/hoaDon/chiTiet/" + id;
        });
    });
</script>
