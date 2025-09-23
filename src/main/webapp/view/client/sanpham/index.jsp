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
                                    <!-- Xem chi tiết: luôn cho phép -->
                                    <a href="${pageContext.request.contextPath}/sanpham/${p.id}" class="btn btn-primary">Xem chi tiết</a>

                                    <!-- Thêm vào giỏ: yêu cầu đăng nhập -->
                                    <a href="${pageContext.request.contextPath}/cart/add?productId=${p.id}"
                                       class="btn btn-success requires-auth"
                                       data-requires-auth
                                       data-next="${pageContext.request.contextPath}/cart/add?productId=${p.id}"
                                       data-msg="Đăng nhập để thêm vào giỏ.">
                                        Thêm vào giỏ
                                    </a>
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
    .section-title { text-align: center; margin: 40px 0; }
    .section-title h2 { color:#333; font-weight:bold; position:relative; display:inline-block; padding:0 20px; }
    .section-title h2:before, .section-title h2:after { content:''; position:absolute; top:50%; width:50px; height:2px; background:#007bff; }
    .section-title h2:before { left:-70px; } .section-title h2:after { right:-70px; }

    .product-card { border:1px solid #ddd; border-radius:8px; padding:20px; text-align:center; background:#fff;
        box-shadow:0 2px 8px rgba(0,0,0,0.1); transition:all .3s ease; height:100%; }
    .product-card:hover { transform:translateY(-5px); box-shadow:0 6px 20px rgba(0,0,0,0.15); }

    .product-image { width:100%; height:200px; object-fit:cover; margin-bottom:15px; border-radius:6px; }

    .product-title { font-size:18px; font-weight:bold; color:#333; margin-bottom:10px; }
    .product-info h5 { font-size:17px; margin:8px 0; color:#333; overflow:hidden; display:-webkit-box; -webkit-line-clamp:2;
        -webkit-box-orient:vertical; text-overflow:ellipsis; line-height:1.3em; max-height:calc(1.3em * 2); }
    .product-info p { color:#666; font-size:14px; margin:8px 0; text-align:left; }

    .product-actions { margin-top:15px; display:flex; gap:10px; justify-content:center; flex-wrap:wrap; }
    .btn { padding:8px 16px; text-decoration:none; border-radius:4px; display:inline-block; font-size:14px; border:none; cursor:pointer; transition:background-color .3s ease; }
    .btn-primary { background:#007bff; color:#fff; } .btn-primary:hover { background:#0056b3; color:#fff; text-decoration:none; }
    .btn-success { background:#28a745; color:#fff; } .btn-success:hover { background:#1e7e34; color:#fff; text-decoration:none; }

    .alert { padding:20px; border-radius:8px; margin-bottom:20px; }
    .alert-warning { background:#fff3cd; border:1px solid #ffeaa7; color:#856404; }
    .alert-danger { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
</style>

<script>
    /* ===== YÊU CẦU ĐĂNG NHẬP CHO "THÊM VÀO GIỎ" ===== */
    (function(){
        const CTX = '${pageContext.request.contextPath}';
        const IS_LOGGED_IN = ${not empty khachHang ? 'true' : 'false'};
        const LOGIN_URL = CTX + '/khachhang/dangnhap';
        const REGISTER_URL = CTX + '/khachhang/dangky';

        // Tạo modal nếu trang chưa có (tránh trùng ID với header)
        function ensureAuthModal(){
            if (document.getElementById('authRequiredModal')) return;
            const wrap = document.createElement('div');
            wrap.innerHTML = `
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
</div>`;
            document.body.appendChild(wrap.firstElementChild);
        }

        function openAuthModal(nextUrl, message, showRegister = true){
            ensureAuthModal();
            const authModalEl = document.getElementById('authRequiredModal');
            const authMsgEl = document.getElementById('authRequiredMsg');
            const goLoginBtn = document.getElementById('goLoginBtn');
            const goRegisterBtn = document.getElementById('goRegisterBtn');

            const next = encodeURIComponent(nextUrl || (location.pathname + location.search));
            authMsgEl.textContent = message || 'Bạn cần đăng nhập để tiếp tục thao tác.';
            goLoginBtn.setAttribute('href', LOGIN_URL + '?next=' + next);
            goRegisterBtn.setAttribute('href', REGISTER_URL + '?next=' + next);

            if (showRegister) goRegisterBtn.classList.remove('d-none'); else goRegisterBtn.classList.add('d-none');

            const modal = bootstrap.Modal.getOrCreateInstance(authModalEl);
            modal.show();
        }

        // Chặn click "Thêm vào giỏ" nếu chưa đăng nhập
        document.addEventListener('click', function(e){
            const el = e.target.closest('.requires-auth, [data-requires-auth]');
            if(!el) return;

            // URL sẽ thực hiện sau khi đăng nhập xong
            const next = el.getAttribute('data-next') || el.getAttribute('href') || (location.pathname + location.search);
            const msg = el.getAttribute('data-msg') || 'Bạn cần đăng nhập để tiếp tục thao tác.';

            if (!IS_LOGGED_IN){
                e.preventDefault();
                openAuthModal(next, msg, true);
                return;
            }
            // Đã đăng nhập: cho đi theo href bình thường
        });
    })();
</script>
