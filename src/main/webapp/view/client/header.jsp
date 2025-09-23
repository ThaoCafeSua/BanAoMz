<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home</title>

    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/includes/images/MzShop.png">

    <style>
        .navbar{ background-color:#001f3d; }
        .logo img{ width:80px; height:80px; }
        .nav-link{ color:#fff!important; font-weight:bold; }
        .nav-link:hover{ color:#001f3d!important; background:#fff; border-radius:5px; }
        .icons a{ color:#fff; font-size:20px; margin:0 10px; }
        .icons a:hover{ color:#74ace0; }

        #hero{
            background-image:url("${pageContext.request.contextPath}/includes/images/Banner.png");
            height:85vh; width:100%; background-size:cover; background-position:top 25% right 0;
            margin-top:20px; display:flex; flex-direction:column; align-items:flex-start; justify-content:center;
        }
        #hero button{
            margin-top:230px; margin-left:65px; background-color:transparent; color:#001f3d;
            padding:14px 80px 14px 65px; cursor:pointer; font-weight:700; font-size:15px;
            border:2px solid transparent; border-radius:30px;
            background-image:linear-gradient(white,white),linear-gradient(45deg,#74ace0,#001f3d);
            background-origin:border-box; background-clip:padding-box,border-box; transition:all .3s ease;
            box-shadow:0 4px 8px rgba(0,0,0,.1);
        }
        #hero button:hover{ background-color:#001f3d; color:#001f3d; box-shadow:0 8px 15px rgba(0,0,0,.3); transform:translateY(-3px); border:2px solid #001f3d; }
        .section-title b{ display:block; height:3px; background:#001f3d; flex-grow:1; }
        .section-title h2{ font-size:2rem; color:#001f3d; text-align:center; margin:0 20px; white-space:nowrap; }
        .col-service{ flex:1; padding:10px; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; }
        .service-box{ display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; padding:10px; }
        .icon-box i{ color:#001f3d; transition:color .3s ease; } .icon-box:hover i{ color:#74ace0; }
        .service-text p{ margin:5px 0; color:#001f3d; } .service-text p strong{ font-size:110%; }
        footer{ background:#001f3d; color:#fff; padding:10px 0; text-align:center; }
        .footer-links a{ color:#fff; text-decoration:none; margin:0 10px; font-size:14px; }
        .footer-links a:hover{ text-decoration:underline; }
        .footer-icons img{ width:40px; height:40px; transition:transform .3s ease; }
        .footer-icons a:hover img{ transform:scale(1.2); }
        .navbar-toggler-icon{ background-image:url("data:image/svg+xml;charset=utf8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='white' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E"); }
        .required::after{ content:' *'; color:red; }
    </style>
</head>
<body>
<header>
    <nav class="navbar navbar-expand-lg shadow-sm">
        <div class="container">
            <!-- Logo -->
            <a class="navbar-brand logo" href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/includes/images/MzShop.png" alt="Logo" class="img-fluid"/>
            </a>

            <!-- Toggler -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Menu -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/">TRANG CHỦ</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/sanpham">SẢN PHẨM</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/gioithieu">GIỚI THIỆU</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/tintuc">TIN TỨC</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/lienhe">LIÊN HỆ</a></li>
                </ul>

                <!-- Icons -->
                <div class="icons d-flex align-items-center">
                    <!-- Giỏ hàng: yêu cầu đăng nhập -->
                    <a href="javascript:void(0)"
                       class="me-3 requires-auth"
                       data-requires-auth
                       data-next="${pageContext.request.contextPath}/cart"
                       data-msg="Bạn cần đăng nhập để xem giỏ hàng."
                       title="Giỏ hàng">
                        <i class="fas fa-shopping-cart"></i>
                    </a>

                    <!-- Xin chào / Tài khoản -->
                    <c:choose>
                        <c:when test="${not empty khachHang}">
                            <a href="${pageContext.request.contextPath}/khachhang/detail/${khachHang.id}"
                               class="text-white fw-bold">Xin chào ${khachHang.hoVaTen}</a>
                            <a href="${pageContext.request.contextPath}/khachhang/logout" class="text-white fw-bold ms-2" id="logoutLink" title="Đăng xuất">
                                <i class="bi bi-power"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0);"
                               class="text-white fw-bold requires-auth"
                               data-requires-auth
                               data-msg="Bạn cần đăng nhập để tiếp tục.">Xin chào</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>

<!-- ===== MODAL: yêu cầu đăng nhập ===== -->
<div class="modal fade" id="authRequiredModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cần đăng nhập</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body">
                <p id="authRequiredMsg" class="mb-0">Bạn cần đăng nhập để tiếp tục thao tác.</p>
            </div>
            <div class="modal-footer">
                <a id="goLoginBtn" class="btn btn-primary">Đăng nhập</a>
                <a id="goRegisterBtn" class="btn btn-outline-secondary">Đăng ký</a>
                <button class="btn btn-light" data-bs-dismiss="modal">Để sau</button>
            </div>
        </div>
    </div>
</div>

<!-- (… nội dung trang …) -->

<script>
    /* ========= AUTH GUARD (client-side) ========= */
    const CTX = '${pageContext.request.contextPath}';
    const LOGIN_URL = CTX + '/khachhang/dangnhap';
    const REGISTER_URL = CTX + '/khachhang/dangky';
    const IS_LOGGED_IN = ${not empty khachHang ? 'true' : 'false'};

    const authModalEl = document.getElementById('authRequiredModal');
    const authModal = new bootstrap.Modal(authModalEl, { keyboard: true });
    const authMsgEl = document.getElementById('authRequiredMsg');
    const goLoginBtn = document.getElementById('goLoginBtn');
    const goRegisterBtn = document.getElementById('goRegisterBtn');

    /** Hiển thị modal + cấu hình link đăng nhập/đăng ký với ?next=... */
    function openAuthModal(nextUrl, message, showRegister = true){
        const next = encodeURIComponent(nextUrl || (location.pathname + location.search));
        authMsgEl.textContent = message || 'Bạn cần đăng nhập để tiếp tục thao tác.';
        goLoginBtn.setAttribute('href', LOGIN_URL + '?next=' + next);
        goRegisterBtn.setAttribute('href', REGISTER_URL + '?next=' + next);

        if (showRegister){
            goRegisterBtn.classList.remove('d-none');
        }else{
            goRegisterBtn.classList.add('d-none');
        }
        authModal.show();
    }

    /** Handler chung: nếu chưa đăng nhập → mở modal; đã đăng nhập → chuyển tới data-next (nếu có) */
    document.addEventListener('click', function(e){
        const el = e.target.closest('[data-requires-auth], .requires-auth, #btnAddToCart, #btnBuyNow');
        if(!el) return;

        // Lấy thông điệp & đích
        let next = el.getAttribute('data-next');
        if (!next || !next.trim()){
            // nếu không set sẵn thì mặc định ở lại trang hiện tại (sau login quay lại)
            next = location.pathname + location.search;
        }
        const msg = el.getAttribute('data-msg') || 'Bạn cần đăng nhập để tiếp tục thao tác.';

        if (!IS_LOGGED_IN){
            e.preventDefault();
            openAuthModal(next, msg, true);
            return;
        }

        // Đã đăng nhập: nếu phần tử định hướng tới trang khác thì đi luôn
        const href = el.getAttribute('href');
        if (href && href !== 'javascript:void(0)'){
            // để browser xử lý bình thường
            return;
        }
        // nếu là nút “Mua ngay” / “Thêm vào giỏ” đã gán data-next
        if (next){
            e.preventDefault();
            window.location.href = next;
        }
    });

    /* Xác nhận đăng xuất */
    const logout = document.getElementById('logoutLink');
    if (logout) {
        logout.addEventListener('click', function (e) {
            if (!confirm('Bạn có muốn đăng xuất không?')) e.preventDefault();
        });
    }

</script>
</body>
</html>
