<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
            integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg=="
            crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            .navbar {
                background-color: #001f3d;
            }

            .logo img {
                width: 50px;
                height: 50px;
            }

            .nav-link {
                color: white !important;
                font-weight: bold;
            }

            .nav-link:hover {
                color: #001f3d !important;
                background-color: white;
                border-radius: 5px;
            }

            .search-bar input {
                border-radius: 30px 0 0 30px;
            }

            .search-bar button {
                border-radius: 0 30px 30px 0;
                background-color: #001f3d;
                color: white;
            }

            .search-bar button:hover {
                background-color: #74ace0;
            }

            .icons a {
                color: white;
                font-size: 20px;
                margin: 0 10px;
            }

            .icons a:hover {
                color: #74ace0;
            }

            #hero {
                background-image: url("/includes/images/Banner.png");
                height: 85vh;
                width: 100%;
                background-size: cover;
                background-position: top 25% right 0;
                margin-top: 20px;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                justify-content: center;
            }

            /* Styling cho nút Mua Ngay */
            #hero button {
                margin-top: 230px;
                margin-left: 65px;
                background-color: transparent;
                color: #001f3d;
                padding: 14px 80px 14px 65px;
                cursor: pointer;
                font-weight: 700;
                font-size: 15px;
                border: 2px solid transparent;
                border-radius: 30px;
                background-image: linear-gradient(white, white), linear-gradient(45deg, #74ace0, #001f3d);
                background-origin: border-box;
                background-clip: padding-box, border-box;
                transition: all 0.3s ease;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            /* Hiệu ứng khi di chuột vào nút */
            #hero button:hover {
                background-color: #001f3d;
                color: #001f3d;
                box-shadow: 0 8px 15px rgba(0, 0, 0, 0.3);
                transform: translateY(-3px);
                border: 2px solid #001f3d;
                transition: all 0.3s ease;
            }

            .section-title b {
                display: block;
                height: 3px;
                background-color: #001f3d;
                flex-grow: 1;
                /* Giúp thanh dài hết phần không gian còn lại */
            }

            .section-title h2 {
                font-size: 2rem;
                color: #001f3d;
                text-align: center;
                margin: 0 10px;
                /* Khoảng cách giữa tiêu đề và thanh */
                white-space: nowrap;
                /* Đảm bảo tiêu đề trên một dòng */
            }

            .col-service {
                flex: 1;
                padding: 10px;
                display: flex;
                flex-direction: column;
                align-items: center;
                /* Căn giữa nội dung theo chiều ngang */
                justify-content: center;
                /* Căn giữa nội dung theo chiều dọc */
                text-align: center;
            }

            /* Hộp dịch vụ */
            .service-box {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-align: center;
                padding: 10px;
            }

            .icon-box i {
                color: #001f3d;
                transition: color 0.3s ease;
            }

            .icon-box:hover i {
                color: #74ace0;
            }

            .service-text p {
                margin: 5px 0;
                color: #001f3d;
            }

            .service-text p strong {
                font-size: 110%;
            }

            footer {
                background-color: #001f3d;
                color: #ffffff;
                padding: 10px 0;
                text-align: center;
            }

            footer .footer-info {
                margin-bottom: 15px;
            }

            footer .footer-info p {
                margin: 5px 0;
            }

            footer .footer-info p:first-child {
                margin-top: 0;
            }

            footer .footer-links {
                margin-top: 10px;
            }

            footer .footer-links a {
                color: #ffffff;
                text-decoration: none;
                margin: 0 10px;
                font-size: 14px;
            }

            footer .footer-links a:hover {
                text-decoration: underline;
            }

            .footer-icons a {
                margin: 0 10px;
            }

            .footer-icons img {
                width: 40px;
                /* Kích thước icon */
                height: 40px;
                transition: transform 0.3s ease;
            }

            /* Hiệu ứng hover cho các icon */
            .footer-icons a:hover img {
                transform: scale(1.2);
                /* Phóng to nhẹ khi hover */
            }

            .navbar-toggler-icon {
                background-image: url("data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='white' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E");
            }

            .required::after {
                content: ' *';
                color: red;
            }
        </style>
    </head>

    <body>
        <header>
            <nav class="navbar navbar-expand-lg shadow-sm">
                <div class="container" style="max-width: 95%;">
                    <!-- Logo -->
                    <a class="navbar-brand logo" href="/">
                        <img src="/includes/images/MzShop.png" alt="Logo" class="img-fluid" />
                    </a>

                    <!-- Toggler for Mobile -->
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <!-- Menu Items -->
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item">
                                <a class="nav-link active" aria-current="page" href="/">TRANG CHỦ</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/sanpham">SẢN PHẨM</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/gioithieu">GIỚI THIỆU</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/tintuc">TIN TỨC</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/lienhe">LIÊN HỆ</a>
                            </li>
                        </ul>
                        <!-- Thanh tìm kiếm -->
                        <form class="d-flex search-bar me-4" action="/sanpham/timkiem" method="get">
                            <div class="input-group search-box">
                                <input class="form-control" type="search" name="query"
                                    placeholder="Tìm kiếm sản phẩm..." aria-label="Search">
                                <button class="btn btn-search" type="submit">Tìm kiếm</button>
                            </div>
                        </form>

                        <!-- Icons -->
                        <div class="icons d-flex align-items-center">
                            <a href="/cart" class="me-3"><i class="fas fa-shopping-cart"></i></a>
                            <a href="/auth/login" class="text-white fw-bold"><i class="fas fa-user"></i></a>
                        </div>
                    </div>
                </div>
            </nav>
        </header>

        <style>
            .search-box {
                width: 350px;
                height: 40px;
            }

            .search-box .form-control {
                border-radius: 20px 0 0 20px;
                /* bo tròn bên trái */
                border: 1px solid #ccc;
                border-right: none;
                /* bỏ viền phải để dính với nút */
                padding-left: 12px;
                font-size: 14px;
            }

            .search-box .btn-search {
                border-radius: 0 20px 20px 0;
                /* bo tròn bên phải */
                border: 1px solid #ccc;
                border-left: none;
                /* bỏ viền trái để dính với input */
                background-color: #ccc;
                color: #fff;
                font-size: 14px;
                padding: 0 16px;
                transition: background 0.3s ease;
            }

            .search-box .btn-search:hover {
                background-color: #0056b3;
            }
        </style>