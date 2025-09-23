<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Hóa Đơn</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Custom CSS -->
    <style>
        body {
            background: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
        .invoice-container {
            background: #fff;
            border-radius: 12px;
            padding: 25px 30px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.08);
        }
        h4.title {
            color: #0d6efd;
            font-weight: 700;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 8px;
            margin-bottom: 20px;
        }
        p strong {
            color: #555;
        }
        .table {
            margin-top: 15px;
            border-radius: 8px;
            overflow: hidden;
        }
        .table thead {
            background-color: #0d6efd;
            color: #fff;
        }
        .table tbody tr:hover {
            background-color: #f1f1f1;
            transition: 0.2s;
        }
        .total-box {
            text-align: right;
            font-size: 1.1rem;
            font-weight: 700;
            margin-top: 15px;
            padding-top: 10px;
            border-top: 2px solid #ddd;
        }
    </style>
</head>
<body>
<div class="container mt-4 invoice-container">

    <!-- Tiêu đề -->
    <h4 class="title">
        Chi Tiết Hóa Đơn - <c:out value="${hoaDonDetail.maHoaDon}" default="Không có"/>
    </h4>
    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/khachhang/${khachHang.id}/donhang"
           class="btn btn-primary">
            ⬅
        </a>
    </div>


    <!-- Thông tin khách hàng -->
    <div class="row">
        <div class="col-md-6">
            <p><strong>Mã hóa đơn:</strong> <c:out value="${hoaDonDetail.maHoaDon}" default="Không có"/></p>
            <p><strong>Khách hàng:</strong> <c:out value="${hoaDonDetail.khachHangTen}" default="Khách lẻ"/></p>
            <p><strong>Người nhận:</strong> <c:out value="${hoaDonDetail.tenNguoiNhan}" default="Không có"/></p>
        </div>
        <div class="col-md-6">
            <p><strong>Điện thoại nhận:</strong> <c:out value="${hoaDonDetail.soDienThoaiNguoiNhan}" default="Không có"/></p>
            <p><strong>Địa chỉ nhận:</strong> <c:out value="${hoaDonDetail.diaChiNguoiNhan}" default="Không có"/></p>
        </div>
    </div>

    <!-- Bảng sản phẩm -->
    <h5 class="mt-4 mb-2 fw-bold">Danh sách sản phẩm</h5>
    <table class="table table-bordered text-center align-middle">
        <thead>
        <tr>
            <th>Tên sản phẩm</th>
            <th>Màu sắc</th>
            <th>Size</th>
            <th>SL</th>
            <th>Giá</th>
            <th>Thành tiền</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="ct" items="${chiTietList}">
            <tr>
                <td>${ct.tenSanPham}</td>
                <td>${ct.mauSac}</td>
                <td>${ct.size}</td>
                <td>${ct.soLuong}</td>
                <td><fmt:formatNumber value="${ct.giaBan}" type="currency" currencySymbol="₫"/></td>
                <td><fmt:formatNumber value="${ct.thanhTien}" type="currency" currencySymbol="₫"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Tổng tiền -->
    <div class="total-box">
        Thành tiền:
        <c:choose>
            <c:when test="${hoaDonDetail.thanhTien != null}">
                <fmt:formatNumber value="${hoaDonDetail.thanhTien}" type="number" pattern="#,###"/>₫
            </c:when>
            <c:otherwise>Không có</c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
