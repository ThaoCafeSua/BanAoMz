<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container mt-3">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="/sanpham">Sản phẩm</a></li>
            <li class="breadcrumb-item active" aria-current="page">${sanPham.tenSanPham}</li>
        </ol>
    </nav>

    <div class="product-detail">
        <div class="row">
            <div class="col-md-6">
                <div class="product-image-container">
                    <c:choose>
                        <c:when test="${not empty sanPham.urlAnh}">
                            <img src="${sanPham.urlAnh}" alt="${sanPham.tenSanPham}" class="main-product-image">
                        </c:when>
                        <c:otherwise>
                            <div class="no-image">
                                <i class="fas fa-image"></i>
                                <p>Không có hình ảnh</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-md-6">
                <div class="product-info">
                    <h1 class="product-title">${sanPham.tenSanPham}</h1>
                    <span class="product-code me-5">Đã Bán: <strong>${sanPham.soLuongDaBan}</strong></span>
                    <span class="product-code">Số lượng: <strong>${sanPham.soLuong}</strong></span>


                    <div class="product-details mt-2">
                        <div class="detail-item">
                            <span class="label">Thương hiệu:</span>
                            <span class="value">${sanPham.thuongHieu}</span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Danh mục:</span>
                            <span class="value">${sanPham.danhMuc}</span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Xuất xứ:</span>
                            <span class="value">${sanPham.xuatXu}</span>
                        </div>
                        <div class="detail-item" style="font-size: 25px">
                            <c:choose>
                                <c:when test="${not empty sanPham.giaBan}">
                                    <span class="label">Giá bán:</span>
                                    <span class="value">
                                <fmt:formatNumber value="${sanPham.giaBan}" type="number" pattern="#,###"/>đ
                            </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="label">Giá bán:</span>
                                    <span class="value">0đ</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="detail">
                            <c:forEach var="m" items="${mauSacs}" varStatus="st">
                                <c:set var="mauId" value="${m.id != null ? m.id : fn:replace(m.ten, ' ', '_')}"/>
                                <input type="radio"
                                       class="btn-check"
                                       name="mauSac"
                                       id="mau-${mauId}"
                                       value="${m.id != null ? m.id : m.ten}"
                                    ${st.first ? "checked" : ""}
                                    ${m.soLuong > 0 ? "" : "disabled"} />
                                <label class="color-option" for="mau-${mauId}">
                                        ${m.ten}
                                    <c:if test="${m.soLuong == 0}">(Hết hàng)</c:if>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                        <!-- SIZE -->
                        <div class="detail-item">
                            <div class="value">
                                <c:forEach var="s" items="${sizes}" varStatus="stS">
                                    <c:set var="sizeId" value="${s.id}"/>
                                    <input type="radio"
                                           class="btn-check"
                                           name="size"
                                           id="size-${sizeId}"
                                           value="${sizeId}"
                                        ${stS.first ? "checked" : ""}
                                        ${s.soLuong > 0 ? "" : "disabled"} />
                                    <label class="size-option" for="size-${sizeId}">
                                            ${s.ten}
                                        <c:if test="${s.soLuong == 0}">(Hết hàng)</c:if>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    <div class="product-actions">
                        <button class="btn btn-success btn-lg" onclick="addToCart(${sanPham.id})">
                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </button>
                        <button class="btn btn-primary btn-lg" onclick="buyNow(${sanPham.id})">
                            <i class="fas fa-bolt"></i> Mua ngay
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-12">
                <div class="product-description">
                    <h3>Mô tả sản phẩm</h3>
                    <p>Đây là sản phẩm chất lượng cao được nhập khẩu từ ${sanPham.xuatXu}.
                        Sản phẩm thuộc thương hiệu ${sanPham.thuongHieu} nổi tiếng với chất lượng và độ bền cao.</p>

                    <h4>Thông tin chi tiết:</h4>
                    <ul>
                        <li>Thương hiệu: ${sanPham.thuongHieu}</li>
                        <li>Danh mục: ${sanPham.danhMuc}</li>
                        <li>Xuất xứ: ${sanPham.xuatXu}</li>
                        <li>Mã sản phẩm: ${sanPham.maSanPham}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .breadcrumb {
        background-color: transparent;
        padding: 0;
        margin-bottom: 30px;
    }

    .breadcrumb-item + .breadcrumb-item::before {
        content: ">";
        color: #6c757d;
        text-decoration: none;
    }

    .breadcrumb-item a {
        color: #007bff;
        text-decoration: none;
    }

    .breadcrumb-item a:hover {
        color: #0056b3;
        text-decoration: none;
    }

    .product-detail {
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .product-image-container {
        text-align: center;
    }

    .main-product-image {
        width: 100%;
        max-width: 400px;
        height: 400px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #ddd;
    }

    .no-image {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 400px;
        background: #f8f9fa;
        border: 2px dashed #dee2e6;
        border-radius: 8px;
        color: #6c757d;
    }

    .no-image i {
        font-size: 60px;
        margin-bottom: 15px;
    }

    .product-title {
        font-size: 32px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .product-code {
        color: #666;
        margin-bottom: 20px;
        font-size: 16px;
    }

    .product-details {
        margin-bottom: 30px;
    }

    .detail-item {
        display: flex;
        margin-bottom: 12px;
        padding: 8px 0;
        border-bottom: 1px solid #f0f0f0;
    }

    .detail-item .label {
        font-weight: bold;
        color: #333;
        width: 120px;
        flex-shrink: 0;
    }

    .detail-item .value {
        color: #666;
        flex: 1;
    }

    .status-HOAT_DONG {
        color: #28a745;
        font-weight: bold;
    }

    .status-NGUNG_HOAT_DONG {
        color: #dc3545;
        font-weight: bold;
    }

    .product-actions {
        display: flex;
        gap: 15px;
        margin-top: 30px;
        flex-wrap: wrap;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-lg {
        padding: 15px 30px;
        font-size: 18px;
    }

    .btn-success {
        background-color: #28a745;
        color: white;
    }

    .btn-success:hover {
        background-color: #1e7e34;
        transform: translateY(-2px);
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }

    .btn-primary:hover {
        background-color: #0056b3;
        transform: translateY(-2px);
    }

    .product-description {
        background: #f8f9fa;
        padding: 30px;
        border-radius: 8px;
        margin-top: 30px;
    }

    .product-description h3 {
        color: #333;
        margin-bottom: 20px;
        border-bottom: 2px solid #007bff;
        padding-bottom: 10px;
    }

    .product-description h4 {
        color: #555;
        margin: 20px 0 10px 0;
    }

    .product-description ul {
        margin-left: 20px;
    }

    .product-description li {
        margin-bottom: 8px;
        color: #666;
    }

    @media (max-width: 768px) {
        .product-actions {
            flex-direction: column;
        }

        .btn {
            width: 100%;
            justify-content: center;
        }

        .product-title {
            font-size: 24px;
        }

        .detail-item {
            flex-direction: column;
        }

        .detail-item .label {
            width: auto;
            margin-bottom: 5px;
        }
    }

    /* mặc định */
    .color-option {
        text-align: center;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 8px 16px;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s ease;
        margin-right: 8px;
    }

    /* hover */
    .color-option:hover {
        background-color: #f5f5f5;
    }

    /* checked */
    .btn-check:checked + .color-option {
        background-color: #8e9095; /* xám */
        color: #fff;
        border-color: #007bff;
    }

    /* checked + hover */
    .btn-check:checked + .color-option:hover {
        background-color: #3399ff; /* xanh nhạt hơn khi hover */
    }


    .size-option {
        text-align:center;
        background-color:#fff;
        border:1px solid #ddd;
        border-radius:6px;
        padding:8px 16px;
        font-weight:bold;
        cursor:pointer;
        transition:background-color .3s ease;
        margin-right:8px;
    }
    .size-option:hover { background-color:#f5f5f5; }
    .btn-check:checked + .size-option {
        background-color:#8e9095;
        color:#fff;
        border-color:#007bff;
    }
    .btn-check:checked + .size-option:hover { background-color:#3399ff; }
</style>

<meta name="_csrf" content="${_csrf != null ? _csrf.token : ''}"/>
<meta name="_csrf_header" content="${_csrf != null ? _csrf.headerName : ''}"/>

<script>
    // ====== Config & helpers ======
    const PRODUCT_ID = ${sanPham.id};
    const VAR_URL = '/sanpham/api/variants/' + PRODUCT_ID;   // trả về [{spctId,mauId,sizeId,soLuong,giaBan}]
    const CART_ADD = '/cart/add';

    function csrfHeaders() {
        const t = document.querySelector('meta[name="_csrf"]')?.content;
        const h = document.querySelector('meta[name="_csrf_header"]')?.content;
        return (t && h) ? { [h]: t } : {};
    }
    function getSelected(name) {
        const el = document.querySelector('input[name="'+name+'"]:checked');
        return el ? el.value : null;
    }

    const variantMap = {};
    let VARIANTS = [];

    (function buildVariantMapFromServerCombos(){
        <c:forEach var="c" items="${combos}">
        (function(){
            var m = '${c.mauId}';
            var s = '${c.sizeId}';
            var q = '${c.soLuong}';
            if (!variantMap[m]) variantMap[m] = {};
            if (Number(q) > 0) variantMap[m][s] = true;
        })();
        </c:forEach>
    })();

    async function loadVariants() {
        try {
            const res = await fetch(VAR_URL, { credentials: 'same-origin' });
            if (!res.ok) throw new Error('HTTP ' + res.status);
            VARIANTS = await res.json();
        } catch (e) {
            console.error('Không load được biến thể:', e);
            VARIANTS = []; // fallback rỗng
        }
    }

    // ====== UI: bật/tắt size theo màu ======
    function refreshSizesByColor() {
        const mauId = getSelected('mauSac');
        const allowed = variantMap[mauId] || {};
        const allSizeInputs = document.querySelectorAll('input[name="size"]');
        let hasEnabled = false;
        allSizeInputs.forEach(input => {
            const ok = !!allowed[input.value];
            input.disabled = !ok;
            const lbl = document.querySelector('label[for="'+input.id+'"]');
            if (lbl) lbl.classList.toggle('disabled-option', !ok);
            if (ok && !hasEnabled) { input.checked = true; hasEnabled = true; }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        // đổi màu -> làm tươi size
        document.querySelectorAll('input[name="mauSac"]').forEach(r => {
            r.addEventListener('change', refreshSizesByColor);
        });
        refreshSizesByColor();
        loadVariants();
    });

    function findSpctIdLocal(mauId, sizeId) {
        mauId = String(mauId); sizeId = String(sizeId);
        const v = VARIANTS.find(it => String(it.mauId) === mauId && String(it.sizeId) === sizeId);
        return v ? v.spctId : null;
    }

    async function resolveSpctIdRemote(mauId, sizeId) {
        const url = '/sanpham/api/spct-id?spId=' + encodeURIComponent(PRODUCT_ID) +
            '&mauId=' + encodeURIComponent(mauId) +
            '&sizeId=' + encodeURIComponent(sizeId);
        const res = await fetch(url, { credentials: 'same-origin' });
        if (!res.ok) return null;
        const txt = await res.text();
        const id = Number(txt);
        return Number.isFinite(id) ? id : null;
    }

    // ====== Thêm vào giỏ / Mua ngay ======
    async function addToCart(productId) {
        const mauId = getSelected('mauSac');
        const sizeId = getSelected('size');
        if (!mauId) { alert('Vui lòng chọn màu'); return; }
        if (!sizeId) { alert('Vui lòng chọn size'); return; }

        let spctId = findSpctIdLocal(mauId, sizeId);
        if (!spctId) spctId = await resolveSpctIdRemote(mauId, sizeId);
        if (!spctId) { alert('Không xác định được biến thể (spctId).'); return; }

        // Gọi /cart/add
        const body = new URLSearchParams({ spctId: String(spctId), soLuong: '1' });
        const res = await fetch(CART_ADD, {
            method: 'POST',
            headers: { 'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8', ...csrfHeaders() },
            body, credentials: 'same-origin'
        });
        if (!res.ok) { alert('Thêm giỏ thất bại'); return; }
        alert('Đã thêm vào giỏ!');
    }

    async function buyNow(productId) {
        await addToCart(productId);
        window.location.href = '/cart';
    }

    window.addToCart = addToCart;
    window.buyNow    = buyNow;
</script>
