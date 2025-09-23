
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Theo dõi đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<style>
    body {
        background-color: #f8f9fa;
    }

    h3.text-primary {
        color: #001f3d !important;
        font-weight: 600;
    }

    /* Table header */
    .table-primary {
        background-color: #001f3d !important;
        color: #fff !important;
    }

    /* Nút quay lại */
    .btn-secondary {
        background-color: #72b4ef;
        border-color: #001f3d;
        color: #fff;
    }
    .btn-secondary:hover {
        background-color: #003366;
        border-color: #003366;
        color: #fff;
    }

    /* Nút lọc */
    .btn-primary {
        background-color: #001f3d;
        border-color: #001f3d;
        color: #fff;
    }
    .btn-primary:hover {
        background-color: #003366;
        border-color: #003366;
    }

    /* Nút chi tiết */
    .btn-info {
        background-color: #72b4ef;
        border-color: #001f3d;
        color: #fff;
    }
    .btn-info:hover {
        background-color: #003366;
        border-color: #003366;
    }

    /* Nút hủy */
    .btn-danger {
        background-color: #e03131;
        border-color: #e03131;
        color: #fff;
    }
    .btn-danger:hover {
        background-color: #c92a2a;
        border-color: #c92a2a;
    }

    /* Alert */
    .alert-info {
        background-color: #e7f5ff;
        color: #001f3d;
    }
    .alert-success {
        background-color: #d3f9d8;
        color: #2b8a3e;
    }
    .alert-danger {
        background-color: #ffe3e3;
        color: #c92a2a;
    }
</style>
<body class="bg-light">
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary">Danh sách đơn hàng của bạn</h3>

        <!-- Nút quay lại -->
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/khachhang/detail/${khachHang.id}"
               class="btn btn-info btn-sm">
                ⬅
            </a>
        </div>

    </div>

    <!-- 🔎 Form lọc trạng thái -->
    <form class="row g-2 mb-3" method="get"
          action="${pageContext.request.contextPath}/khachhang/${customerId}/donhang">
        <div class="col-auto">
            <select name="status" class="form-select">
                <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>Tất cả</option>
                <option value="CHO_XAC_NHAN" ${selectedStatus == 'CHO_XAC_NHAN' ? 'selected' : ''}>Chờ xử lý</option>
                <option value="CHO_CHUAN_BI_HANG" ${selectedStatus == 'CHO_CHUAN_BI_HANG' ? 'selected' : ''}>Chờ chuẩn bị hàng</option>
                <option value="DANG_GIAO" ${selectedStatus == 'DANG_GIAO' ? 'selected' : ''}>Đang giao</option>
                <option value="GIAO_THAT_BAI" ${selectedStatus == 'GIAO_THAT_BAI' ? 'selected' : ''}>Giao thất bại</option>
                <option value="HOAN_HANG" ${selectedStatus == 'HOAN_HANG' ? 'selected' : ''}>Hoàn hàng</option>
                <option value="DA_HOAN_HANG" ${selectedStatus == 'DA_HOAN_HANG' ? 'selected' : ''}>Đã hoàn hàng</option>
                <option value="HOAN_THANH" ${selectedStatus == 'HOAN_THANH' ? 'selected' : ''}>Hoàn thành</option>
                <option value="HUY" ${selectedStatus == 'HUY' ? 'selected' : ''}>Đã hủy</option>
            </select>
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Lọc</button>
        </div>
    </form>

    <!-- 🔔 Hiển thị thông báo -->
    <c:if test="${not empty message}">
        <div class="alert alert-success text-center">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>
    <c:if test="${empty donHangList}">
        <div class="alert alert-info">Không tìm thấy đơn hàng phù hợp.</div>
    </c:if>

    <c:if test="${donHangPage.totalElements == 0}">
        <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
    </c:if>
    <c:if test="${donHangPage.totalElements > 0}">
        <table class="table table-bordered table-hover bg-white">
            <thead class="table-primary text-center ">
            <tr>
                <th>Mã đơn</th>
                <th>Ngày tạo</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody class="text-center">
            <c:forEach var="order" items="${donHangPage.content}">
                <tr>
                    <td>${order.maHoaDon}</td>
                    <td>${order.ngayDat}</td>
                    <td>${order.tongTien}</td>
                    <td>${order.trangThai}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/khachhang/don-hang/huy"
                              method="post"
                              onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này không?');">
                            <input type="hidden" name="customerId" value="${customerId}"/>  <!-- SỬA Ở ĐÂY -->
                            <input type="hidden" name="id" value="${order.id}"/>

                            <c:choose>
                                <c:when test="${order.trangThai ne 'DANG_GIAO'
                     and order.trangThai ne 'GIAO_THAT_BAI'
                     and order.trangThai ne 'DA_HOAN_HANG'
                     and order.trangThai ne 'HOAN_HANG'
                     and order.trangThai ne 'HOAN_THANH'
                     and order.trangThai ne 'HUY'}">
                                    <button type="submit" class="btn btn-danger btn-sm">Hủy đơn</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-secondary btn-sm" disabled>Không thể hủy</button>
                                </c:otherwise>
                            </c:choose>

                            <a href="${pageContext.request.contextPath}/khachhang/chitiet/${order.id}"

                               class="btn btn-info btn-sm">🔍</a>


                               class="btn btn-info btn-sm">
                                Xem chi tiết
                            </a>

                            <c:if test="${not empty _csrf}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            </c:if>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${donHangPage.totalElements > 0}">
            <table>
                <c:forEach var="order" items="${donHangPage.content}"> ... </c:forEach> </table>
            <nav>
                <ul class="pagination">
                    <c:forEach var="i" begin="0" end="${totalPages - 1}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&size=5&status=${selectedStatus}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:if>
    </c:if>
</div>
</body>
</html>