
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Theo dõi đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary">Danh sách đơn hàng của bạn</h3>

        <!-- Nút quay lại -->
        <div class="mt-3">
            <button type="button" class="btn btn-secondary" onclick="window.history.back();">
                ⬅
            </button>
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

    <c:if test="${empty donHangList}">
        <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
    </c:if>

    <c:if test="${not empty donHangList}">
        <table class="table table-bordered table-hover bg-white">
            <thead class="table-primary text-center">
            <tr>
                <th>Mã đơn</th>
                <th>Ngày tạo</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody class="text-center">
            <c:forEach var="order" items="${donHangList}">
                <tr>
                    <td>${order.maHoaDon}</td>
                    <td>${order.ngayDat}</td>
                    <td>${order.tongTien}</td>
                    <td>${order.trangThai}</td>
                    <td>
                        <!-- Nút hủy đơn -->
                        <form action="${pageContext.request.contextPath}/khachhang/don-hang/huy"
                              method="post"
                              onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này không?');">
                            <input type="hidden" name="customerId" value="${khachHang.id}" />
                            <input type="hidden" name="id" value="${order.id}" />
                            <button type="submit" class="btn btn-danger btn-sm">Hủy đơn</button>
                            <a href="${pageContext.request.contextPath}/khachhang/chitiet/${order.id}"
                               class="btn btn-info btn-sm">
                                🔍
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
    </c:if>
</div>
</body>
</html>