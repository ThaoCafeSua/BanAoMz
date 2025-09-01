<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div>
    <div class="container" style="max-width: 90%;">
        <section id="hero">
            <a href="/sanpham">
                <button class="btn-buy">Mua Ngay</button>
            </a>
        </section>
    </div>

    <div class="container" style="margin-top:45px">
        <div class="section-title" style="padding-bottom: 10px">
            <b></b>
            <h2 style="padding: 5px">SẢN PHẨM MỚI</h2>
            <b></b>
        </div>

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
                    <!-- Chỉ render 8 sản phẩm đầu -->
                    <c:forEach var="p" items="${listSp}" begin="0" end="7">
                        <div class="col-3">
                            <div class="product-box">
                                <c:if test="${not empty p.urlAnh}">
                                    <div class="top-product">
                                        <img src="${p.urlAnh}" alt="${p.tenSanPham}" class="product-image">
                                    </div>
                                </c:if>
                                <div class="product-info">
                                    <h5>${p.tenSanPham}</h5>
                                    <p><strong>Thương hiệu:</strong> ${p.thuongHieu}</p>
                                    <c:choose>
                                        <c:when test="${not empty p.giaBan}">
                                            <p><strong>Giá:</strong>
                                                <fmt:formatNumber value="${p.giaBan}" type="number" pattern="#,###"/>đ
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p><strong>Giá:</strong> 0đ</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-overlay">
                                    <a href="/sanpham/${p.id}" class="btn btn-light">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Nút Xem tất cả: chỉ hiện nếu có hơn 8 sp -->
        <c:if test="${not empty listSp && fn:length(listSp) > 8}">
            <div class="text-center" style="margin-top:10px">
                <a href="/sanpham" class="btn-view-all">Xem tất cả</a>
            </div>
        </c:if>
    </div>

    <div class="container" style="margin-top:20px">
        <div class="section-title" style="padding-bottom: 10px">
            <b></b>
            <h2 style="padding: 5px">SẢN PHẨM BÁN CHẠY</h2>
            <b></b>
        </div>

        <div class="row">
            <c:choose>
                <c:when test="${empty top10List}">
                    <div class="col-12">
                        <div class="alert alert-warning text-center">
                            <h4>Không có sản phẩm nào!</h4>
                            <p>Hiện tại chưa có sản phẩm nào để hiển thị.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Chỉ render 4 sản phẩm đầu -->
                    <c:forEach var="p" items="${top10List}" begin="0" end="3">
                        <div class="col-3">
                            <div class="product-box">
                                <c:if test="${not empty p.urlAnh}">
                                    <div class="top-product">
                                        <img src="${p.urlAnh}" alt="${p.tenSanPham}" class="product-image">
                                    </div>
                                </c:if>
                                <div class="product-info">
                                    <h5>${p.tenSanPham}</h5>
                                    <p><strong>Đã bán:</strong> ${p.soLuongDaBan}</p>
                                    <c:choose>
                                        <c:when test="${not empty p.giaBan}">
                                            <p><strong>Giá:</strong>
                                                <fmt:formatNumber value="${p.giaBan}" type="number" pattern="#,###"/>đ
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p><strong>Giá:</strong> 0đ</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-overlay">
                                    <a href="/sanpham/${p.id}" class="btn btn-light">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<div class="container">
    <div class="section-title">
        <b></b>
        <h2>DỊCH VỤ KHÁCH HÀNG</h2>
        <b></b>
    </div>
    <div class="row">
        <div class="col-service">
            <div class="service-box">
                <div class="icon-box">
                    <i class="fas fa-headset" aria-hidden="true"></i>
                </div>
                <div class="service-text">
                    <p><strong>CHĂM SÓC KHÁCH HÀNG</strong></p>
                    <p>Hỗ trợ khách hàng 24/7</p>
                </div>
            </div>
        </div>

        <div class="col-service">
            <div class="service-box">
                <div class="icon-box">
                    <i class="fas fa-tags" aria-hidden="true"></i>
                </div>
                <div class="service-text">
                    <p><strong>GIÁ CẢ HỢP LÝ</strong></p>
                    <p>Phù hợp với mọi ngân sách</p>
                </div>
            </div>
        </div>

        <div class="col-service">
            <div class="service-box">
                <div class="icon-box">
                    <i class="fas fa-shopping-cart" aria-hidden="true"></i>
                </div>
                <div class="service-text">
                    <p><strong>ĐẶT HÀNG TRỰC TUYẾN</strong></p>
                    <p>Tiện lợi, nhanh chóng</p>
                </div>
            </div>
        </div>

        <div class="col-service">
            <div class="service-box">
                <div class="icon-box">
                    <i class="fas fa-credit-card" aria-hidden="true"></i>
                </div>
                <div class="service-text">
                    <p><strong>THANH TOÁN LINH HOẠT</strong></p>
                    <p>Online hoặc trực tiếp tại nhà</p>
                </div>
            </div>
        </div>

    </div>
</div>
</div>

<style>
    .product-box {
        position: relative;
        border: 1px solid #ddd;
        padding: 15px;
        text-align: center;
        margin-bottom: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, background-color 0.3s ease;
        overflow: hidden;
    }

    .product-box:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        background-color: rgba(0, 0, 0, 0.05);
        /* tối màu nhẹ */
    }

    /* overlay */
    .product-overlay {
        position: absolute;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.6);
        padding: 15px;
        text-align: center;
        transform: translateY(100%);
        transition: transform 0.3s ease;
    }

    .product-box:hover .product-overlay {
        transform: translateY(0);
        /* trượt lên */
    }

    .product-overlay .btn {
        background: transparent;
        /* nền trong suốt */
        border: 2px solid #fff;
        /* viền trắng (hoặc màu khác tùy ý) */
        color: #fff;
        /* chữ màu trắng để nổi bật trên nền tối */
        padding: 8px 16px;
        border-radius: 4px;
        text-decoration: none;
        font-weight: bold;
        transition: all 0.3s ease;
    }

    .product-overlay .btn:hover {
        background: rgba(255, 255, 255, 0.2);
        /* hover có nền trắng mờ 20% */
        color: #fff;
    }

    .top-product {
        border-bottom: 1px solid #ddd;
        /* Thêm border line màu xám nhạt */
    }

    .product-image {
        border-radius: 5px;
        max-width: 100%;
        height: 250px;
        object-fit: cover;
        margin-bottom: 5px;
    }

    .product-info {
        padding-left: 20px;
        padding-right: 20px;
        text-align: left;

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
        font-size: 15px;
        margin: 5px 0;
    }

    .btn-view-all {
        display: inline-block;
        padding: 10px 18px;
        border-radius: 6px;
        border: 1px solid #007bff;
        color: #007bff;
        text-decoration: none;
        font-weight: 600;
        transition: all .2s ease;
    }
    .btn-view-all:hover {
        background-color: #007bff;
        color: #fff;
        text-decoration: none;
    }


    .alert {
        padding: 20px;
        border-radius: 8px;
        background-color: #fff3cd;
        border: 1px solid #ffeaa7;
        color: #856404;
    }

    .btn-primary {
        background-color: #779cc6;
        color: white;
        padding: 8px 16px;
        text-decoration: none;
        border-radius: 4px;
        display: inline-block;
        margin-top: 10px;
    }

    .btn-primary:hover {
        background-color: #0056b3;
        text-decoration: none;
        color: white;
    }
</style>