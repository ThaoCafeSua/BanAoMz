<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<base href="${pageContext.request.contextPath}/" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="container-fluid mt-4">
    <div class="row">

        <!-- Tabs hóa đơn chờ -->
        <div class="card mb-3 shadow-sm">
            <div class="card-header text-white py-2">
                <h6 class="mb-0">Danh sách hóa đơn chờ</h6>
            </div>
            <div class="card-body p-2" id="hoaDonListContainer">
                <ul class="nav nav-pills mb-2" id="hoaDonTabs" role="tablist"></ul>
            </div>
        </div>

        <!-- LEFT: Danh sách sản phẩm -->
        <div class="col-md-7">
            <div class="card mb-3">
                <div class="card-header text-white">
                    <h5 class="mb-0">Danh sách sản phẩm</h5>
                </div>
                <div class="card-body">

                    <!-- Toolbar lọc nhanh -->
                    <div class="pos-toolbar">
                        <input id="filter" class="form-control form-control-sm" placeholder="🔎 Lọc nhanh theo tên sản phẩm…">
                    </div>

                    <div class="scroll-y">
                        <table class="table table-hover" id="productTable">
                            <thead style="background-color:#001f3d;color:white;" class="text-center">
                            <tr>
                                <th>Ảnh</th>
                                <th>Tên</th>
                                <th>SL</th>
                                <th>Giá</th>
                                <th>Thêm</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="sp" items="${sanPhamList}">
                                <tr class="text-center product-row"
                                    data-sanpham-id="${sp.idSanPham}"
                                    data-stock="${sp.soLuongTon}">
                                    <td>
                                        <img src="${empty sp.urlAnh ? '/includes/images/default.png' : sp.urlAnh}"
                                             width="60" height="60"
                                             loading="lazy" decoding="async"
                                             onerror="this.src='/includes/images/default.png'"/>
                                    </td>
                                    <td><c:out value="${sp.tenSanPham}"/></td>
                                    <td>
                                        <span class="stock-badge badge-stock-ok" id="stock-sp-${sp.idSanPham}">${sp.soLuongTon}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sp.giaBan != null}">
                                                <fmt:formatNumber value="${sp.giaBan}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </c:when>
                                            <c:otherwise>0 ₫</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-primary"
                                                data-id="${sp.idSanPham}"
                                                data-ten="${fn:escapeXml(sp.tenSanPham)}"
                                                data-bs-toggle="tooltip" data-bs-placement="top" title="Thêm vào giỏ"
                                                onclick="openModalFromBtn(this)">+</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>

        <!-- RIGHT: Khách + Giỏ + Thanh toán -->
        <div class="col-md-5">
            <!-- Khách hàng -->
            <div class="card mb-3 shadow-sm">
                <div class="card-header text-white">
                    <h6 class="mb-0">Khách hàng</h6>
                </div>
                <div class="card-body p-2">
                    <div class="row g-2">
                        <div class="col">
                            <input type="text" id="nguoiNhan" class="form-control form-control-sm" placeholder="Người nhận">
                            <div class="invalid-feedback">Vui lòng nhập tên người nhận.</div>
                        </div>
                        <div class="col">
                            <input type="text" id="sdtNguoiNhan" class="form-control form-control-sm" placeholder="SĐT người nhận">
                            <div class="invalid-feedback">Vui lòng nhập SĐT hợp lệ (10–11 số, bắt đầu bằng 0).</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Giỏ hàng -->
            <div class="card mb-3 shadow-sm">
                <div class="card-header text-white">
                    <h5 class="mb-0">Giỏ hàng</h5>
                </div>
                <div class="card-body p-2">
                    <table class="table table-bordered table-sm mb-3 align-middle text-center">
                        <thead class="table-light">
                        <tr>
                            <th>Tên</th>
                            <th>SL</th>
                            <th>Giá</th>
                            <th>Xóa</th>
                        </tr>
                        </thead>
                        <tbody id="cartItems"></tbody>
                    </table>

                    <div class="d-flex justify-content-between align-items-center mt-3 p-2 summary-bar">
                        <strong>Tổng tiền:</strong>
                        <strong id="totalAmount" class="text-danger">0 ₫</strong>
                    </div>

                    <button class="btn btn-success w-100 mt-2" id="btnCheckout">💳 Thanh Toán</button>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Modal chọn màu & size -->
<div class="modal fade" id="variantModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chọn màu và size cho <span id="modalTenSanPham"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modalSanPhamId"/>
                <div class="mb-3">
                    <label>Màu sắc:</label>
                    <select class="form-select" id="selectMauSac"></select>
                </div>
                <div class="mb-3">
                    <label>Size:</label>
                    <select class="form-select" id="selectSize"></select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-primary" onclick="chonThuocTinh()">Xác nhận</button>
            </div>
        </div>
    </div>
</div>

<style>
    :root{
        --brand:#001f3d;
        --brand-2:#0d3b66;
        --accent:#ffc107;
        --ok:#28a745;
        --low:#fd7e14;
        --zero:#dc3545;
        --surface:#f7f9fc;
    }
    body{background:var(--surface);}
    .card{border:0; border-radius:14px; box-shadow:0 6px 18px rgba(0,0,0,.06);}
    .card-header{
        border:0; color:#fff; border-top-left-radius:14px; border-top-right-radius:14px;
        background:linear-gradient(135deg,var(--brand),#01325f);
    }

    .form-control-sm,.form-select-sm{padding:6px 10px; font-size:.9rem; border-radius:10px}
    .table th,.table td{border:1px solid #e9edf3 !important; vertical-align:middle !important}
    .table-hover tbody tr:hover{background:#f6f9ff}
    #productTable thead th{position:sticky; top:0; z-index:1}

    #hoaDonTabs .nav-link{border-radius:999px; background:#fff; border:1px solid #e6ebf2; transition:all .2s; font-weight:600; padding:6px 12px;}
    #hoaDonTabs .nav-link:hover{transform:translateY(-1px)}
    #hoaDonTabs .nav-link.active{background:var(--brand); color:#fff; border:2px solid var(--accent)}
    #hoaDonTabs .badge{font-weight:700}
    #hoaDonTabs .tab-title{font-weight:600;}
    #hoaDonTabs .close-tab{line-height:1;}

    #totalAmount{font-size:1.25rem}
    .summary-bar{background:#fff3cd; border:1px dashed #ffe08a; border-radius:10px}

    .pos-toolbar{display:flex; gap:.5rem; align-items:center; margin-bottom:.75rem}
    .pos-toolbar .form-control{max-width:360px}
    .scroll-y{max-height:60vh; overflow:auto}

    .btn{border-radius:10px}
    .btn-primary{background:var(--brand); border-color:var(--brand)}
    .btn-primary:hover{background:var(--brand-2); border-color:var(--brand-2)}
    .btn-success{background:#2eb85c; border-color:#2eb85c}
    .btn-success:hover{background:#25a24f; border-color:#25a24f}
</style>

<script>
    /* =========================
       Helpers & constants
    ========================= */
    const PHUONG_THUC_MAC_DINH = 'TIEN_MAT';
    const modal = new bootstrap.Modal(document.getElementById('variantModal'));
    const MAX_HOA_DON_CHO = 10; // TỐI ĐA 10 HĐ CHỜ

    // Debounce
    const _debounce = (fn, t = 250) => {
        let h; return function(...args){ clearTimeout(h); h = setTimeout(()=>fn.apply(this,args), t); };
    };

    // Loading (jqXHR không có .finally)
    function withLoading(p){
        $('button, input, select').prop('disabled', true);
        return $.when(p).always(()=> $('button, input, select').prop('disabled', false));
    }

    // Phone helpers
    function normPhone(v){ return (v||'').replace(/\D/g,'').replace(/^0+/, '0'); }
    function validVNPhone(v){ return /^0\d{9,10}$/.test(v); }

    // Input invalid helpers
    function setInvalid($el, msg){ $el.addClass('is-invalid'); const $fb=$el.next('.invalid-feedback'); if($fb.length) $fb.text(msg||''); }
    function clearInvalid($el){ $el.removeClass('is-invalid'); }

    /* ====== DAILY INVOICE SERIES (reset 24h) ====== */
    function todayYMD(){
        const d = new Date();
        const y = d.getFullYear();
        const m = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${y}-${m}-${day}`;
    }
    function resetDailyCounterIfNeeded(){
        const key = 'hoaDonSeriesDate';
        const today = todayYMD();
        const stored = localStorage.getItem(key);
        if (stored !== today){
            localStorage.setItem(key, today);
            localStorage.setItem('hoaDonCounter', '1'); // lần tạo tiếp theo sẽ ra HD01
        }
    }
    function nextInvoiceCode(width = 2){
        resetDailyCounterIfNeeded();
        let counter = parseInt(localStorage.getItem('hoaDonCounter')) || 1;

        // tránh trùng với danh sách hiện tại
        const used = new Set((hoaDonList || []).map(h => String(h.id)));
        let code, guard = 0;
        while (guard++ < 200){
            code = 'HD' + String(counter).padStart(width, '0');
            counter++;
            if (!used.has(code)) break;
        }
        localStorage.setItem('hoaDonCounter', String(counter));
        return code;
    }

    // Validate khách hàng
    function validateCustomer(){
        const $name = $('#nguoiNhan');
        const $phone= $('#sdtNguoiNhan');
        const name  = ($name.val()||'').trim();
        let phone   = normPhone($phone.val()); $phone.val(phone);

        let ok = true;
        if(!name){ setInvalid($name,'Vui lòng nhập tên người nhận.'); ok=false; } else clearInvalid($name);
        if(!phone){ setInvalid($phone,'Vui lòng nhập số điện thoại.'); ok=false; }
        else if(!validVNPhone(phone)){ setInvalid($phone,'SĐT chưa hợp lệ (10–11 số, bắt đầu bằng 0).'); ok=false; } else clearInvalid($phone);

        if(!ok) alert('Thiếu thông tin khách hàng: vui lòng nhập TÊN và SĐT hợp lệ.');
        return ok;
    }

    /* =========================
       State + Migration
    ========================= */
    let hoaDonList = [];
    try{ hoaDonList = JSON.parse(localStorage.getItem('hoaDonList')) || []; }catch(e){ hoaDonList = []; }
    if(!Array.isArray(hoaDonList)) hoaDonList = [];
    let currentHoaDonId = hoaDonList.length ? hoaDonList[0].id : null;

    // Giữ tối đa 10 cái mới nhất
    function trimHoaDonToMax(){
        if (hoaDonList.length > MAX_HOA_DON_CHO){
            hoaDonList = hoaDonList.slice(-MAX_HOA_DON_CHO);
            if (!hoaDonList.find(h=>h.id===currentHoaDonId)){
                currentHoaDonId = hoaDonList.length ? hoaDonList[0].id : null;
            }
            saveHoaDonList();
        }
    }

    (function ensureHoaDonIds(){
        // dùng series theo ngày nếu thiếu id
        let changed=false;
        hoaDonList.forEach(h=>{
            if(!h) return;
            if(!h.id){ h.id = nextInvoiceCode(2); changed=true; }
            if(!Array.isArray(h.items)) { h.items=[]; changed=true; }
        });
        if(changed){ saveHoaDonList(); currentHoaDonId = hoaDonList.length ? hoaDonList[0].id : null; }
        trimHoaDonToMax();
    })();

    function saveHoaDonList(){ localStorage.setItem('hoaDonList', JSON.stringify(hoaDonList)); }

    /* =========================
       Stock computing (ALL tabs)
    ========================= */
    // Tổng số đã đặt theo từng sản phẩm trên *mọi* hóa đơn
    function buildQtyBySanPhamAllTabs(){
        const map={};
        (hoaDonList||[]).forEach(hd=>{
            (hd.items||[]).forEach(it=>{
                const spId = String(it.idSanPham||''); if(!spId) return;
                map[spId] = (map[spId]||0) + (parseInt(it.soLuong||0,10)||0);
            });
        });
        return map;
    }

    // Tổng số đã đặt theo từng BIẾN THỂ
    function buildQtyBySpctAllTabs(){
        const map = {};
        (hoaDonList||[]).forEach(hd=>{
            (hd.items||[]).forEach(it=>{
                const k = String(it.idSPCT || it.idSpct || '');
                if(!k) return;
                map[k] = (map[k]||0) + (parseInt(it.soLuong||0,10)||0);
            });
        });
        return map;
    }

    // Render tồn hiển thị
    function recalcAllVisibleStocks(){
        const qtyMap = buildQtyBySanPhamAllTabs();

        $('#productTable tbody tr.product-row').each(function(){
            const $tr  = $(this);
            const spId = String($tr.data('sanpham-id'));
            const base = parseInt($tr.data('stock'),10) || 0;
            const used = parseInt(qtyMap[spId]||0,10) || 0;
            const avail= Math.max(0, base - used);

            const $span = $('#stock-sp-'+spId);
            $span.text(avail)
                .removeClass('badge-stock-ok badge-stock-low badge-stock-zero')
                .addClass( avail===0 ? 'badge-stock-zero' : (avail<=10 ? 'badge-stock-low' : 'badge-stock-ok') );

            const $btnAdd = $tr.find('button[data-id="'+spId+'"]');
            $btnAdd.prop('disabled', avail===0)
                .toggleClass('btn-secondary', avail===0)
                .toggleClass('btn-primary',  avail>0)
                .attr('title', avail===0 ? 'Hết hàng' : 'Thêm vào giỏ');
        });

        // cập nhật badge số món trên tab
        $('#hoaDonTabs .nav-link[data-hdid]').each(function(){
            const id = this.dataset.hdid;
            const hd = hoaDonList.find(h=>h.id===id); if(!hd) return;
            const count = (hd.items||[]).reduce((s,i)=> s + (parseInt(i.soLuong||0,10)||0), 0);
            const badge = this.querySelector('.invoice-count'); if(badge) badge.textContent = count;
        });
    }

    /* =========================
       Tabs hóa đơn
    ========================= */
    function renderHoaDonList(){
        trimHoaDonToMax();

        const container = document.getElementById('hoaDonListContainer');
        const tabList = document.createElement('ul');
        tabList.className='nav nav-pills mb-2'; tabList.id='hoaDonTabs'; tabList.setAttribute('role','tablist');

        const displayList = hoaDonList.slice(-MAX_HOA_DON_CHO);

        displayList.forEach(hd=>{
            const li = document.createElement('li'); li.className='nav-item me-1'; li.setAttribute('role','presentation');

            const btn = document.createElement('button');
            btn.className = 'nav-link d-flex align-items-center gap-1' + (hd.id===currentHoaDonId?' active':'');
            btn.dataset.hdid = hd.id;

            const title = document.createElement('span'); title.className='tab-title'; title.textContent=hd.id||'HD?';
            const count = (hd.items||[]).reduce((s,i)=> s+(parseInt(i.soLuong||0,10)||0), 0);
            const badge = document.createElement('span'); badge.className='invoice-count badge bg-warning text-dark ms-2'; badge.textContent=count;

            const close = document.createElement('span'); close.className='close-tab ms-2 text-danger fw-bold'; close.innerHTML='&times;'; close.style.cursor='pointer';
            close.onclick=(e)=>{ e.stopPropagation(); xoaHoaDon(hd.id); };

            btn.onclick = ()=>{ currentHoaDonId=hd.id; saveHoaDonList(); renderHoaDonList(); loadCart(); recalcAllVisibleStocks(); bindCustomerInputs(); };

            btn.append(title, badge, close); li.appendChild(btn); tabList.appendChild(li);
        });

        // Nút thêm HĐ: disable nếu đã đủ 10
        const liAdd=document.createElement('li'); liAdd.className='nav-item';
        const btnAdd=document.createElement('button');
        const canAdd = hoaDonList.length < MAX_HOA_DON_CHO;
        btnAdd.className='nav-link fw-bold ' + (canAdd ? 'text-success' : 'text-muted');
        btnAdd.textContent='+';
        btnAdd.title = canAdd ? 'Thêm hóa đơn chờ' : ('Đã đạt tối đa ' + MAX_HOA_DON_CHO + ' hóa đơn chờ');
        btnAdd.disabled = !canAdd;
        btnAdd.onclick = ()=> { if(canAdd) taoHoaDonMoiVaRender(); };
        liAdd.appendChild(btnAdd); tabList.appendChild(liAdd);

        container.innerHTML=''; container.appendChild(tabList);
    }

    // TẠO HÓA ĐƠN MỚI (giới hạn 10, series theo ngày)
    function taoHoaDonMoiVaRender(){
        trimHoaDonToMax();
        if (hoaDonList.length >= MAX_HOA_DON_CHO){
            alert('Chỉ được tạo tối đa ' + MAX_HOA_DON_CHO + ' hóa đơn chờ.');
            return;
        }
        const id = nextInvoiceCode(2); // -> HD01, HD02...
        hoaDonList.push({ id, items: [] });
        currentHoaDonId = id;
        saveHoaDonList(); renderHoaDonList(); loadCart(); recalcAllVisibleStocks(); bindCustomerInputs();
    }

    function xoaHoaDon(id){
        hoaDonList = hoaDonList.filter(h=>h.id!==id);
        if(currentHoaDonId===id) currentHoaDonId = hoaDonList.length ? hoaDonList[0].id : null;
        saveHoaDonList(); renderHoaDonList(); loadCart(); recalcAllVisibleStocks(); bindCustomerInputs();
    }

    /* =========================
       Modal chọn thuộc tính
    ========================= */
    function openModalFromBtn(btn){
        const id  = $(btn).data('id');
        const ten = $(btn).data('ten');
        openModal(id, ten);
    }

    function openModal(idSanPham, tenSanPham){
        $('#modalSanPhamId').val(idSanPham);
        $('#modalTenSanPham').text(tenSanPham);

        $.get('/admin/banHang/lay-thuoc-tinh', { idSanPham }, function (data) {
            const mauSacList = data.mauSacList || [];
            const sizeList   = data.sizeList   || [];
            const chiTietList= data.sanPhamChiTietList || [];

            const sizeTheoMau = {};
            chiTietList.forEach(it=>{
                if(!sizeTheoMau[it.idMauSac]) sizeTheoMau[it.idMauSac]=new Set();
                sizeTheoMau[it.idMauSac].add(it.idSize);
            });

            const $mau = $('#selectMauSac').empty();
            const $size= $('#selectSize').empty();
            mauSacList.forEach(m=> $mau.append($('<option>').val(m.id).text(m.ten)));
            $mau.off('change').on('change', function(){
                const selected = $(this).val(); $size.empty();
                const ok = sizeTheoMau[selected] || new Set();
                sizeList.forEach(s=>{ if(ok.has(s.id)) $size.append($('<option>').val(s.id).text(s.ten)); });
            }).trigger('change');

            modal.show();
        });
    }

    // Thêm vào giỏ: kiểm tra *tồn tổng* trên tất cả HD + tồn biến thể
    function chonThuocTinh(){
        const idSanPham = $('#modalSanPhamId').val();
        const idMau     = $('#selectMauSac').val();
        const idSize    = $('#selectSize').val();
        if(!idMau || !idSize || !currentHoaDonId){ alert('Vui lòng chọn đầy đủ và tạo hóa đơn.'); return; }

        $.get('/admin/banHang/tim-san-pham-chi-tiet', { idSanPham, idMauSac:idMau, idSize }, function(res){
            if(!res.id){ alert('Không tìm thấy sản phẩm phù hợp!'); return; }
            if(res.soLuongTon<=0){ alert('Sản phẩm đã hết hàng.'); return; }

            // Check tồn tổng theo sản phẩm (ảnh chụp trên UI)
            const $row   = $('#productTable tbody tr.product-row[data-sanpham-id="'+idSanPham+'"]');
            const base   = parseInt($row.data('stock'),10) || 0; // tồn gốc
            const usedAllByProduct = parseInt(buildQtyBySanPhamAllTabs()[String(idSanPham)]||0,10) || 0;
            if(usedAllByProduct + 1 > base){
                alert('Vượt quá tồn kho còn lại của sản phẩm này (tính trên tất cả hóa đơn).');
                return;
            }

            // Check theo BIẾN THỂ trên toàn bộ hóa đơn
            const usedSpctAll = (buildQtyBySpctAllTabs()[String(res.id)]||0);
            const spctTon = parseInt(res.soLuongTon||0,10);
            if (usedSpctAll + 1 > spctTon){
                const left = Math.max(0, spctTon - usedSpctAll);
                alert('Biến thể này chỉ còn ' + left + ' chiếc khả dụng trên các hóa đơn đang mở.');
                return;
            }

            const hd = hoaDonList.find(h=>h.id===currentHoaDonId); if(!hd) return;
            const ex = hd.items.find(i=>i.idSPCT===res.id);

            // trần cho HĐ hiện tại = tồn biến thể - phần đã giữ ở HĐ khác
            const usedOther = usedSpctAll - (ex ? ex.soLuong : 0);
            const maxForThisOrder = Math.max(0, spctTon - usedOther);

            if(ex){
                if(ex.soLuong < maxForThisOrder) ex.soLuong += 1;
                else return alert('Đã đạt tối đa ('+maxForThisOrder+') cho biến thể này ở hóa đơn hiện tại.');
            } else {
                if (maxForThisOrder <= 0) return alert('Hết khả dụng cho biến thể này.');
                hd.items.push({
                    idSPCT: res.id, idSanPham: parseInt(idSanPham,10),
                    ten: res.tenSanPham, mau: res.tenMauSac, size: res.tenSize,
                    soLuong: 1, giaBan: res.giaBan||0, soLuongTon: spctTon
                });
            }

            saveHoaDonList(); modal.hide(); loadCart(); recalcAllVisibleStocks();
        });
    }

    /* =========================
       Giỏ hàng
    ========================= */
    function loadCart(){
        const hd = hoaDonList.find(h=>h.id===currentHoaDonId);
        if(!hd){
            $('#cartItems').html('<tr><td colspan="4" class="text-center">Chưa có hóa đơn nào</td></tr>');
            $('#totalAmount').text('0 ₫'); return;
        }

        const usedSpctAll = buildQtyBySpctAllTabs();

        let html='', total=0;
        hd.items.forEach(item=>{
            const name = (item.ten||'Không tên') + ' - ' + (item.mau||'') + ' - ' + (item.size||'');
            const qty  = item.soLuong||0, price=item.giaBan||0, ton=item.soLuongTon||0, tt=qty*price;

            // max cho HĐ hiện tại = tồn biến thể - phần đã giữ ở HĐ khác
            const usedOther = (usedSpctAll[String(item.idSPCT)]||0) - qty;
            const maxForThisOrder = Math.max(1, Math.max(0, ton - usedOther));

            html += '<tr class="text-center">';
            html += '<td>'+name+'</td>';
            html += '<td><input type="number" class="form-control form-control-sm text-center qty-input" '+
                'data-idspct="'+item.idSPCT+'" min="1" max="'+maxForThisOrder+'" value="'+qty+'" '+
                'oninput="capNhatSoLuongLocal(\''+item.idSPCT+'\', this.value)" /></td>';
            html += '<td>'+ tt.toLocaleString('vi-VN') +' ₫</td>';
            html += '<td><button class="btn btn-danger btn-sm" onclick="xoaSanPhamLocal(\''+item.idSPCT+'\')">X</button></td>';
            html += '</tr>';
            total += tt;
        });
        if(hd.items.length===0) html='<tr><td colspan="4" class="text-center">Giỏ hàng trống</td></tr>';

        $('#cartItems').html(html);
        $('#totalAmount').text(total.toLocaleString('vi-VN')+' ₫');
    }

    function capNhatSoLuongLocal(idSPCT, soLuongMoi){
        const hd = hoaDonList.find(h=>h.id===currentHoaDonId); if(!hd) return;
        const item = hd.items.find(i=>String(i.idSPCT)===String(idSPCT)); if(!item) return;

        let val = parseInt(soLuongMoi,10);

        if(isNaN(val) || val < 1){ alert('Số lượng phải ≥ 1.'); val = 1; }

        // kẹp theo khả dụng biến thể (trừ phần đã giữ ở HĐ khác)
        const usedAll = buildQtyBySpctAllTabs();
        const usedOther = (usedAll[String(item.idSPCT)]||0) - (item.soLuong||0);
        const hardMax = Math.max(1, Math.max(0, (item.soLuongTon||0) - usedOther));

        if(val > hardMax){ alert('Vượt quá tồn khả dụng. Tối đa: '+hardMax); val = hardMax; }

        if(val !== item.soLuong){ item.soLuong = val; saveHoaDonList(); }
        loadCart(); recalcAllVisibleStocks();
    }
    window.capNhatSoLuongLocal = _debounce(capNhatSoLuongLocal, 250);

    function xoaSanPhamLocal(idSPCT){
        if(!confirm('Xoá sản phẩm này khỏi giỏ?')) return;
        const hd = hoaDonList.find(h=>h.id===currentHoaDonId); if(!hd) return;
        hd.items = hd.items.filter(i=>String(i.idSPCT)!==String(idSPCT));
        saveHoaDonList(); loadCart(); recalcAllVisibleStocks(); bindCustomerInputs();
    }

    /* =========================
       Inputs khách hàng
    ========================= */
    function bindCustomerInputs(){
        const hd = hoaDonList.find(h=>h.id===currentHoaDonId);
        if(!hd){ $('#nguoiNhan').val(''); $('#sdtNguoiNhan').val(''); return; }
        $('#nguoiNhan').val(hd.nguoiNhan||'');
        $('#sdtNguoiNhan').val(hd.sdtNguoiNhan||'');
        $('#nguoiNhan, #sdtNguoiNhan').off('input.bindCustomer').on('input.bindCustomer', function(){
            clearInvalid($(this));
            const h = hoaDonList.find(x=>x.id===currentHoaDonId); if(!h) return;
            h.nguoiNhan = ($('#nguoiNhan').val()||'').trim();
            h.sdtNguoiNhan = ($('#sdtNguoiNhan').val()||'').trim();
            saveHoaDonList();
        });
    }

    $('#sdtNguoiNhan').off('blur.normPhone').on('blur.normPhone', function(){
        const v = normPhone($(this).val()); $(this).val(v);
        if(v && !validVNPhone(v)) setInvalid($(this),'Số điện thoại chưa hợp lệ (10–11 số, bắt đầu bằng 0).');
        else clearInvalid($(this));
        const h = hoaDonList.find(x=>x.id===currentHoaDonId); if(h){ h.sdtNguoiNhan=v; saveHoaDonList(); }
    });

    /* =========================
       Khởi tạo
    ========================= */
    // Reset series theo ngày ngay khi load, và kiểm tra lại mỗi phút
    resetDailyCounterIfNeeded();
    setInterval(resetDailyCounterIfNeeded, 60 * 1000);

    renderHoaDonList(); loadCart(); recalcAllVisibleStocks(); bindCustomerInputs();

    // Tooltip
    [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]')).forEach(el => new bootstrap.Tooltip(el));

    // Enter trong modal = xác nhận
    document.getElementById('variantModal').addEventListener('keydown', function(e){
        if(e.key==='Enter'){ e.preventDefault(); chonThuocTinh(); }
    });

    // Lọc nhanh theo tên
    $('#filter').on('input', function(){
        const q = ($(this).val()||'').toLowerCase().trim();
        $('#productTable tbody tr').each(function(){
            const name = $(this).find('td:nth-child(2)').text().toLowerCase();
            $(this).toggle(!q || name.includes(q));
        });
    });

    // Chặn ký tự lạ khi nhập SL
    $(document).on('keydown', '#cartItems input.qty-input', function(e){
        const bad = ['-','+','e','E','.',' ', '/',',']; if(bad.includes(e.key)) e.preventDefault();
    });
    // Blur: kẹp lại giá trị
    $(document).on('blur', '#cartItems input.qty-input', function(){
        if(this.value==='') this.value = this.min || 1;
        window.capNhatSoLuongLocal(this.dataset.idspct, this.value);
    });

    /* =========================
       Thanh toán (+ giảm tồn gốc ngay)
    ========================= */
    function buildSoldMapFromHoaDon(hd){
        const map={}; (hd.items||[]).forEach(it=>{
            const spId=String(it.idSanPham||''); if(!spId) return;
            map[spId]=(map[spId]||0)+(parseInt(it.soLuong||0,10)||0);
        }); return map;
    }
    function applySoldToBaseStock(soldMap){
        $('#productTable tbody tr.product-row').each(function(){
            const $tr=$(this); const spId=String($tr.data('sanpham-id'));
            const dec=parseInt(soldMap[spId]||0,10)||0; if(dec<=0) return;
            const base=parseInt($tr.data('stock'),10)||0; const next=Math.max(0, base-dec);
            $tr.data('stock', next); $tr.attr('data-stock', next);
        });
    }

    $('#btnCheckout').on('click', function(){
        const hd = hoaDonList.find(h=>h.id===currentHoaDonId);
        if(!hd || hd.items.length===0) return alert('Giỏ hàng trống.');
        if(!validateCustomer()) return;

        const payload = {
            danhSachSanPham: hd.items.map(it=>({ idSanPhamChiTiet: it.idSPCT, soLuong: it.soLuong })),
            idKhachHang: null,
            idPhieuGiamGia: null,
            phuongThucThanhToan: PHUONG_THUC_MAC_DINH,
            tenNguoiNhan: ($('#nguoiNhan').val()||'').trim(),
            sdtNguoiNhan: ($('#sdtNguoiNhan').val()||'').trim()
        };

        withLoading($.ajax({
            url:'/admin/banHang/thanh-toan', type:'POST', contentType:'application/json', data: JSON.stringify(payload)
        })).done(function(hoaDon){
            alert('Thanh toán thành công!\nMã HĐ: '+ (hoaDon?.maHoaDon || '—'));

            const soldMap = buildSoldMapFromHoaDon(hd);
            applySoldToBaseStock(soldMap);

            hoaDonList = hoaDonList.filter(h=>h.id!==currentHoaDonId);
            currentHoaDonId = hoaDonList.length ? hoaDonList[0].id : null;
            saveHoaDonList(); renderHoaDonList(); loadCart(); recalcAllVisibleStocks();
            $('#nguoiNhan,#sdtNguoiNhan').val(''); bindCustomerInputs();
        }).fail(function(xhr){
            alert('Lỗi thanh toán: ' + (xhr.responseText||''));
        });
    });

    /* =========================
       Đồng bộ đa tab (storage event)
    ========================= */
    window.addEventListener('storage', function(e){
        if (e.key === 'hoaDonList'){
            try { hoaDonList = JSON.parse(e.newValue)||[]; } catch(_) { hoaDonList = []; }
            if (!hoaDonList.find(h=>h.id===currentHoaDonId)){
                currentHoaDonId = hoaDonList.length ? hoaDonList[0].id : null;
            }
            trimHoaDonToMax();
            renderHoaDonList(); loadCart(); recalcAllVisibleStocks(); bindCustomerInputs();
        }
        if (e.key === 'hoaDonSeriesDate' || e.key === 'hoaDonCounter'){
            // lần tạo tiếp theo sẽ dùng series mới
        }
    });
</script>
