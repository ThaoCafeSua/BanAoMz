<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Theo dõi đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>
<body class="bg-light">

<div class="container mt-4">
    <h3 class="text-center mb-4 text-primary">
        <i class="fas fa-truck"></i> Theo dõi đơn hàng
    </h3>

    <div class="alert alert-info text-center">
        Xin chào <strong>${khachHang.hoVaTen}</strong>, đây là danh sách đơn hàng của bạn:
    </div>

    <c:choose>
        <c:when test="${not empty donHangList}">
            <table class="table table-bordered table-hover text-center align-middle shadow-sm bg-white">
                <thead class="table-primary">
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày tạo</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="don" items="${donHangList}">
                    <tr>
                        <td><span class="badge bg-primary">${don.maDonHang}</span></td>
                        <td><fmt:formatDate value="${don.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td><fmt:formatNumber value="${don.tongTien}" type="currency" currencySymbol="₫"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${don.trangThai == 'CHO_XAC_NHAN'}">
                                    <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                                </c:when>
                                <c:when test="${don.trangThai == 'DANG_GIAO'}">
                                    <span class="badge bg-info">Đang giao</span>
                                </c:when>
                                <c:when test="${don.trangThai == 'DA_HOAN_THANH'}">
                                    <span class="badge bg-success">Hoàn thành</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Đã hủy</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/donhang/detail/${don.id}"
                               class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-eye"></i> Xem
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="text-center text-muted fst-italic">
                <i class="fas fa-box-open fa-2x mb-2"></i><br/>
                Bạn chưa có đơn hàng nào.
            </div>
        </c:otherwise>
    </c:choose>

    <div class="mt-4 text-center">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
            <i class="fas fa-home"></i> Về trang chủ
        </a>
    </div>
</div>
</body>
</html>
