<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- CSRF meta cho Spring Security (nếu có) --%>
<meta name="_csrf" content="${_csrf != null ? _csrf.token : ''}"/>
<meta name="_csrf_header" content="${_csrf != null ? _csrf.headerName : ''}"/>

<style>
    .cart-container {
        background-color: #f9f9f9;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 31, 61, 0.1);
    }
    .cart-header h5 {
        color: #001f3d;
        font-weight: 700;
        border-bottom: 2px solid #001f3d;
        padding-bottom: 10px;
        margin-bottom: 0;
    }
    #cart-items-container {
        min-height: 150px;
        padding: 20px;
        border: 1px dashed #ccc;
        border-radius: 6px;
        background-color: #fff;
    }
    .cart-summary {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        gap: 16px;
        border-top: 1px solid #001f3d;
        padding-top: 16px;
        align-items: center;
    }
    .cart-summary h5 {
        margin: 0;
        color: #001f3d;
        font-weight: 600;
    }
    .cart-summary .text-danger {
        font-size: 20px;
        font-weight: 700;
    }
    #btn-checkout {
        background-color: #001f3d;
        border-color: #001f3d;
        font-weight: 600;
        padding: 10px 22px;
        border-radius: 30px;
        transition: all 0.25s ease;
    }
    #btn-checkout:hover { background-color: #003366; border-color: #003366; }
    .qty-input { width: 90px; text-align: center; }
    .img-thumb { width: 60px; height: 60px; object-fit: cover; border-radius: 6px; }
    .actions-row { display:flex; gap:10px; flex-wrap:wrap; }
    .muted { color:#6c757d; }
    .form-checkout { display:none; width:100%; background:#fff; border:1px solid #e9ecef; border-radius:8px; padding:16px; }
    .form-checkout .form-label { font-weight: 600; }
</style>

<div class="container cart-container">
    <div class="cart-header mt-2 mb-3 d-flex align-items-center justify-content-between">
        <h5>Giỏ hàng của bạn</h5>
        <div class="actions-row">
            <button class="btn btn-outline-secondary btn-sm" id="btn-refresh">Tải lại</button>
            <button class="btn btn-outline-danger btn-sm" id="btn-clear">Xoá toàn bộ</button>
        </div>
    </div>

    <!-- Cart items -->
    <div class="my-3" id="cart-items-container">
        <p class="text-center muted">Đang tải giỏ hàng…</p>
    </div>

    <!-- Summary -->
    <div class="cart-summary my-3">
        <div>
            <h5>Tổng tiền: <span class="text-danger" id="total-amount">0₫</span></h5>
            <div class="muted" id="summary-note"></div>
        </div>
        <div class="actions-row">
            <a href="/" class="btn btn-outline-primary">Tiếp tục mua</a>
            <button class="btn btn-primary" id="btn-checkout">Thanh toán</button>
        </div>
    </div>

    <!-- Checkout form (toggle) -->
    <form class="form-checkout" id="checkout-form">
        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label" for="hoTen">Họ và tên</label>
                <input type="text" class="form-control" id="hoTen" placeholder="Nguyễn Văn A" required>
            </div>
            <div class="col-md-4">
                <label class="form-label" for="sdt">Số điện thoại</label>
                <input type="tel" class="form-control" id="sdt" placeholder="09xxxxxxxx" required>
            </div>
            <div class="col-12">
                <label class="form-label" for="diaChi">Địa chỉ nhận hàng</label>
                <input type="text" class="form-control" id="diaChi" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành" required>
            </div>
            <div class="col-12 d-flex gap-2">
                <button type="submit" class="btn btn-success">Xác nhận đặt hàng</button>
                <button type="button" class="btn btn-light" id="btn-cancel-checkout">Huỷ</button>
            </div>
        </div>
    </form>
</div>

<script>
    // =================== API endpoints ===================
    const API = {
        items:   '/cart/items',
        update:  '/cart/update',
        remove:  '/cart/remove',
        clear:   '/cart/clear',
        checkout:'/cart/checkout'
    };

    // =================== Helpers ===================
    function vnd(n) {
        const x = Number(n || 0);
        return x.toLocaleString('vi-VN') + '₫';
    }

    function getCsrfHeaders() {
        const token = document.querySelector('meta[name="_csrf"]')?.content;
        const headerName = document.querySelector('meta[name="_csrf_header"]')?.content;
        return (token && headerName) ? { [headerName]: token } : {};
    }

    async function getJSON(url) {
        const res = await fetch(url, { credentials: 'same-origin' });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.json();
    }

    async function postForm(url, dataObj) {
        const body = new URLSearchParams();
        Object.entries(dataObj || {}).forEach(([k, v]) => body.append(k, v));
        const res = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8', ...getCsrfHeaders() },
            body,
            credentials: 'same-origin'
        });
        const ct = res.headers.get('content-type') || '';
        if (ct.includes('application/json')) return res.json();
        return res.text(); // remove/clear trả rỗng
    }

    // =================== Map server DTO -> view model ===================
    // Kỳ vọng backend trả về CartItemDTO: { spctId, ten, anh, gia, soLuong, mau, size, tenHienThi }
    function mapCartItem(row) {
        return {
            spctId:     Number(row.spctId ?? row.id ?? 0),
            ten:        row.ten || 'Sản phẩm',
            tenHienThi: (row.tenHienThi || '').trim(),
            mau:        row.mau || null,
            size:       row.size || null,
            anh:        row.anh || '/images/no-image.png', // đổi fallback nếu cần
            gia:        Number(row.gia ?? 0),
            soLuong:    Number(row.soLuong ?? 0)
        };
    }

    // =================== State ===================
    let items = []; // [{spctId, ten, tenHienThi, mau, size, anh, gia, soLuong}]

    // =================== Render ===================
    function renderCart() {
        const container = document.getElementById('cart-items-container');
        if (!items.length) {
            container.innerHTML = "<p class='text-center muted'>Giỏ hàng trống</p>";
            document.getElementById('total-amount').innerText = '0₫';
            document.getElementById('summary-note').innerText = '';
            return;
        }

        let total = 0;
        let html = `
      <div class="table-responsive">
        <table class="table table-bordered align-middle text-center">
          <thead class="table-light">
            <tr>
              <th>Ảnh</th>
              <th>Tên sản phẩm</th>
              <th>Giá</th>
              <th style="width:130px">Số lượng</th>
              <th>Thành tiền</th>
              <th>Xoá</th>
            </tr>
          </thead>
          <tbody>
    `;

        items.forEach((it, idx) => {
            const thanhTien = (Number(it.gia) || 0) * (Number(it.soLuong) || 0);
            total += thanhTien;

            const name =
                it.ten +
                (it.mau  ? ' - Màu: '  + it.mau  : '') +
                (it.size ? ' - Size: ' + it.size : '');

            html += `
        <tr>
          <td><img class="img-thumb" src="\${it.anh}" alt="\${it.ten}"></td>
          <td class="text-start">\${name}</td>
          <td>\${vnd(it.gia)}</td>
          <td>
            <input type="number" min="1" class="form-control qty-input"
                   value="\${it.soLuong}" onchange="onQtyChange(\${idx}, this.value)">
          </td>
          <td><strong>\${vnd(thanhTien)}</strong></td>
          <td>
            <button class="btn btn-sm btn-danger" onclick="onRemove(\${idx})">Xoá</button>
          </td>
        </tr>
      `;
        });

        html += `</tbody></table></div>`;
        container.innerHTML = html;

        document.getElementById('total-amount').innerText = vnd(total);
        document.getElementById('summary-note').innerText = `Đã chọn \${items.length} sản phẩm`;
    }

    // =================== Actions ===================
    async function loadCart() {
        try {
            document.getElementById('cart-items-container').innerHTML =
                "<p class='text-center muted'>Đang tải giỏ hàng…</p>";
            const data = await getJSON(API.items);
            // console.table(data); // bật nếu muốn debug keys trả về
            items = Array.isArray(data) ? data.map(mapCartItem) : [];
            renderCart();
        } catch (e) {
            document.getElementById('cart-items-container').innerHTML =
                "<p class='text-center text-danger'>Không tải được giỏ hàng. Vui lòng thử lại.</p>";
            console.error(e);
        }
    }

    window.onQtyChange = async function(idx, val) {
        const qty = Math.max(1, parseInt(val || '1', 10));
        const it = items[idx];
        try {
            await postForm(API.update, { spctId: it.spctId, soLuong: qty });
            items[idx].soLuong = qty;
            renderCart();
        } catch (e) {
            alert('Cập nhật số lượng thất bại.');
            console.error(e);
        }
    };

    window.onRemove = async function(idx) {
        const it = items[idx];
        if (!confirm('Xoá sản phẩm này khỏi giỏ?')) return;
        try {
            await postForm(API.remove, { spctId: it.spctId });
            items.splice(idx, 1);
            renderCart();
        } catch (e) {
            alert('Xoá thất bại.');
            console.error(e);
        }
    };

    document.getElementById('btn-clear').addEventListener('click', async () => {
        if (!items.length) return;
        if (!confirm('Xoá toàn bộ giỏ hàng?')) return;
        try {
            await postForm(API.clear, {});
            items = [];
            renderCart();
        } catch (e) {
            alert('Không xoá được giỏ.');
            console.error(e);
        }
    });

    // =================== Checkout ===================
    const formEl = document.getElementById('checkout-form');

    document.getElementById('btn-checkout').addEventListener('click', () => {
        if (!items.length) {
            alert('Giỏ hàng trống, không thể thanh toán!');
            return;
        }
        formEl.style.display = (formEl.style.display === 'none' || !formEl.style.display) ? 'block' : 'none';
    });

    document.getElementById('btn-cancel-checkout').addEventListener('click', () => {
        formEl.style.display = 'none';
    });

    formEl.addEventListener('submit', async (e) => {
        e.preventDefault();
        const hoTen  = document.getElementById('hoTen').value.trim();
        const sdt    = document.getElementById('sdt').value.trim();
        const diaChi = document.getElementById('diaChi').value.trim();
        if (!hoTen || !sdt || !diaChi) {
            alert('Vui lòng điền đầy đủ thông tin.');
            return;
        }
        try {
            const resp = await postForm(API.checkout, { hoTen, sdt, diaChi });
            alert(typeof resp === 'string' ? resp : 'Đặt hàng thành công');
            items = [];
            renderCart();
            formEl.reset();
            formEl.style.display = 'none';
        } catch (e) {
            alert('Thanh toán thất bại.');
            console.error(e);
        }
    });

    // =================== Buttons & Init ===================
    document.getElementById('btn-refresh').addEventListener('click', loadCart);
    loadCart();

    fetch('/cart/whoami',{credentials:'same-origin'}).then(r=>r.json()).then(console.log)

</script>
