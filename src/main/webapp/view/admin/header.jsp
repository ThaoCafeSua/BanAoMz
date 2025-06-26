<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ban Ao MzShop</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- jQuery 3.6.4 -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>

    <!-- Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <!-- Toastr -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

    <style>
        /* Header */
        header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 60px;
            background-color: #001f3d; /* Màu xanh than */
            color: white;
            z-index: 1000;
            box-shadow: 0 2px 2px rgba(0,0,0,0.1);
        }
        .header-flex {
            display: flex;
            align-items: center;       /* Căn giữa theo chiều dọc */
            gap: 10px;                 /* Khoảng cách giữa logo và h3 */
        }

        .header-flex img {
            width: 50px;               /* Điều chỉnh kích thước logo nếu cần */
            height: auto;
            align-items: center;       /* Căn giữa theo chiều dọc */

        }


        /* Sidebar */
        .sidebar {
            width: 20%;
            transition: width 0.3s;
            background-color: #001f3d; /* Màu xanh than */
            position: fixed;
            top: 60px; /* Dưới header */
            left: 0;
            bottom: 0;
            padding: 10px;
            color: white;
        }

        .sidebar.collapsed {
            width: 60px;
            padding: 20px 10px;
        }

        /* Sidebar links */
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            transition: background-color 0.3s;
        }

        .sidebar a:hover {
            background-color: #004080; /* Màu xanh than đậm khi hover */
        }

        /* Content */
        .content {
            margin-left: 20%;
            padding-top: 70px; /* Không bị header che khuất */
            transition: margin-left 0.3s;
        }

        .content.expanded {
            margin-left: 60px; /* Khi sidebar thu gọn */
        }

        /* Nút toggle */
        #toggleSidebar {
            position: fixed;
            top: 10px;
            left: 10px;
            z-index: 1100;
            padding: 10px;
            background-color: #001f3d; /* Màu xanh than */
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            border-radius: 5px;
        }

        #toggleSidebar:hover {
            background-color: #004080; /* Màu xanh than đậm khi hover */
        }

        /* Responsive: Điều chỉnh khi màn hình nhỏ */
        @media (max-width: 768px) {
            .sidebar {
                width: 60px;
                padding: 10px;
                top: 60px; /* Dưới header */
            }

            .content {
                margin-left: 60px;
            }

            .sidebar.collapsed {
                width: 0;
                padding: 0;
            }

            .content.expanded {
                margin-left: 0;
            }
        }
    </style>
</head>

<body>

<header>
    <div class="container header-flex">
        <img src="/includes/images/MzShop.png" alt="Logo" class="img-fluid" />
        <h3>MzShop</h3>
    </div>
</header>


<!-- Sidebar -->
<div class="sidebar ">
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link active text-white h5" href="/admin" aria-label="Thống kê">
                <i class="fas fa-chart-pie me-2"></i> Thống kê
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" href="/admin/banHang" aria-label="Bán hàng tại quầy">
                <i class="fas fa-cash-register me-2"></i> Bán hàng tại quầy
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" href="/admin/order" aria-label="Quản lý đơn hàng">
                <i class="fas fa-shopping-cart me-2"></i> Quản lý đơn hàng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" data-bs-toggle="collapse" href="#productManagement" role="button"
               aria-expanded="false" aria-controls="productManagement">
                <i class="fas fa-boxes me-2"></i> Quản lý sản phẩm <i class="fas fa-chevron-down float-end"></i>
            </a>
            <div class="collapse" id="productManagement">
                <ul class="nav flex-column ms-3">
                    <li class="nav-item">
                        <a class="nav-link text-white h5" href="/admin/product" aria-label="Sản phẩm">
                            <i class="fas fa-box-open me-2"></i> Sản phẩm
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white h5" href="/admin/size" aria-label="Size">
                            <i class="fas fa-weight-hanging me-2"></i> Size
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white h5" href="/admin/color" aria-label="Màu sắc">
                            <i class="fas fa-palette me-2"></i> Màu sắc
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white h5" href="/admin/origin" aria-label="Xuất xứ">
                            <i class="fas fa-globe-asia me-2"></i> Xuất xứ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white h5" href="/admin/brand" aria-label="Thương hiệu">
                            <i class="fas fa-tag me-2"></i> Thương hiệu
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white h5" href="/admin/category" aria-label="Danh mục">
                            <i class="fas fa-list me-2"></i> Danh mục
                        </a>
                    </li>
                </ul>
            </div>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" href="/admin/voucher" aria-label="Giảm giá">
                <i class="fas fa-ticket-alt me-2"></i> Giảm giá
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" href="/admin/customer" aria-label="Khách hàng">
                <i class="fas fa-users me-2"></i> Khách hàng
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" href="/admin/staff" aria-label="Nhân viên">
                <i class="fas fa-user-tie me-2"></i> Nhân viên
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link text-white h5" href="/admin/logout" aria-label="Đăng xuất" id="logoutBtn">
                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
            </a>
        </li>
    </ul>
</div>


<!-- Toggle Sidebar Button -->
<button id="toggleSidebar">
    <i class="fas fa-bars"></i>
</button>

<!-- Main Content -->
<div class="content">
    <jsp:include page="${page}.jsp" /> <!-- Nội dung động -->
</div>

<script>
    document.getElementById("toggleSidebar").addEventListener("click", function() {
        const sidebar = document.querySelector(".sidebar");
        const content = document.querySelector(".content");

        sidebar.classList.toggle("collapsed");
        content.classList.toggle("expanded");
    });
</script>

</body>
</html>
