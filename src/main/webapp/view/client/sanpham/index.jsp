<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container">
    <div class="section-title">
        <h2>TẤT CẢ SẢN PHẨM</h2>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
                ${error}
        </div>
    </c:if>

    <div class="row">
        <c:choose>
            <c:when test="${empty listSp}">
                <div class="col-12">
                    <div class="alert alert-warning text-center">
                        <h4>Không có sản phẩm nào!</h4>
                        <p>Hiện tại chưa có sản phẩm nào để hiển thị.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="p" items="${listSp}">
                    <div class="col-md-3 col-sm-6 mb-4">
                        <div class="product-card">
                            <c:if test="${not empty p.urlAnh}">
                                <img src="${p.urlAnh}" alt="${p.tenSanPham}" class="product-image">
                            </c:if>
                            <div class="product-info">
                                <h5 class="product-title">${p.tenSanPham}</h5>
                                <p class="product-brand"><strong>Thương hiệu:</strong> ${p.thuongHieu}</p>
                                <p class="product-category"><strong>Danh mục:</strong> ${p.danhMuc}</p>
                                <p class="product-origin"><strong>Xuất xứ:</strong> ${p.xuatXu}</p>
                                <p class="product-quantity"><strong>Số lượng:</strong> ${p.soLuong}</p>
                                <div class="product-actions">
                                    <a href="/sanpham/${p.id}" class="btn btn-primary">Xem chi tiết</a>
                                    <a href="#" class="btn btn-success">Thêm vào giỏ</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<style>
    .section-title {
        text-align: center;
        margin: 40px 0;
    }

    .section-title h2 {
        color: #333;
        font-weight: bold;
        position: relative;
        display: inline-block;
        padding: 0 20px;
    }

    .section-title h2:before,
    .section-title h2:after {
        content: '';
        position: absolute;
        top: 50%;
        width: 50px;
        height: 2px;
        background: #007bff;
    }

    .section-title h2:before {
        left: -70px;
    }

    .section-title h2:after {
        right: -70px;
    }

    .product-card {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        background: white;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        transition: all 0.3s ease;
        height: 100%;
    }

    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }

    .product-image {
        width: 100%;
        height: 200px;
        object-fit: cover;
        margin-bottom: 15px;
        border-radius: 6px;
    }

    .product-title {
        font-size: 18px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .product-info h5 {
        font-size: 17px;
        margin: 8px 0;
        color: #333;
        overflow: hidden;
        /* Ẩn phần dư */
        display: -webkit-box;
        /* Dùng flex ẩn dòng */
        -webkit-line-clamp: 2;
        /* Giới hạn 2 dòng */
        -webkit-box-orient: vertical;
        /* Chiều dọc */
        text-overflow: ellipsis;
        /* Hiển thị ... */
        line-height: 1.3em;
        /* Chiều cao mỗi dòng */
        max-height: calc(1.3em * 2);
        /* Tổng chiều cao = 2 dòng */
    }

    .product-info p {
        color: #666;
        font-size: 14px;
        margin: 8px 0;
        text-align: left;
    }

    .product-actions {
        margin-top: 15px;
        display: flex;
        gap: 10px;
        justify-content: center;
        flex-wrap: wrap;
    }

    .btn {
        padding: 8px 16px;
        text-decoration: none;
        border-radius: 4px;
        display: inline-block;
        font-size: 14px;
        border: none;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }

    .btn-primary:hover {
        background-color: #0056b3;
        color: white;
        text-decoration: none;
    }

    .btn-success {
        background-color: #28a745;
        color: white;
    }

    .btn-success:hover {
        background-color: #1e7e34;
        color: white;
        text-decoration: none;
    }

    .alert {
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }

    .alert-warning {
        background-color: #fff3cd;
        border: 1px solid #ffeaa7;
        color: #856404;
    }

    .alert-danger {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        color: #721c24;
    }
</style>