<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta name="_csrf" content="${_csrf != null ? _csrf.token : ''}"/>
<meta name="_csrf_header" content="${_csrf != null ? _csrf.headerName : ''}"/>

<%-- (Tuỳ chọn) Tìm kiếm trong select
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tom-select/dist/css/tom-select.css">
<script src="https://cdn.jsdelivr.net/npm/tom-select/dist/js/tom-select.complete.min.js"></script>
--%>

<style>
    .cart-container{background:#f9f9f9;padding:30px;border-radius:10px;box-shadow:0 0 10px rgba(0,31,61,.1)}
    .cart-header h5{color:#001f3d;font-weight:700;border-bottom:2px solid #001f3d;padding-bottom:10px;margin-bottom:0}
    #cart-items-container{min-height:150px;padding:20px;border:1px dashed #ccc;border-radius:6px;background:#fff}
    .cart-summary{display:flex;flex-wrap:wrap;justify-content:space-between;gap:16px;border-top:1px solid #001f3d;padding-top:16px;align-items:center}
    .cart-summary h5{margin:0;color:#001f3d;font-weight:600}
    .img-thumb{width:60px;height:60px;object-fit:cover;border-radius:6px}
    .actions-row{display:flex;gap:10px;flex-wrap:wrap}
    .muted{color:#6c757d}
    .form-checkout{display:none;width:100%;background:#fff;border:1px solid #e9ecef;border-radius:8px;padding:16px}
    .form-checkout .form-label{font-weight:600}
    .totals small{color:#6c757d}
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
        <div class="totals">
            <div><strong>Tạm tính:</strong> <span id="subtotal-amount">0₫</span></div>
            <div><strong>Phí vận chuyển:</strong> <span id="ship-amount">0₫</span>
                <small id="ship-note" class="ms-1"></small>
            </div>
            <h5 class="mt-2">Tổng thanh toán: <span class="text-danger" id="grand-amount">0₫</span></h5>
            <div class="muted" id="summary-note"></div>
        </div>
        <div class="actions-row">
            <a href="/" class="btn btn-outline-primary">Tiếp tục mua</a>
            <button class="btn btn-primary" id="btn-checkout">Thanh toán</button>
        </div>
    </div>

    <!-- Checkout form -->
    <form class="form-checkout" id="checkout-form">
        <div class="row g-3">
            <!-- Chỉ còn Họ tên + SĐT ở trên -->
            <div class="col-md-4">
                <label class="form-label" for="hoTen">Họ và tên</label>
                <input type="text" class="form-control" id="hoTen" placeholder="Nguyễn Văn A" required>
            </div>
            <div class="col-md-4">
                <label class="form-label" for="sdt">Số điện thoại</label>
                <input type="tel" class="form-control" id="sdt" placeholder="09xxxxxxxx" required>
            </div>

            <!-- GHN: Chọn địa chỉ + Địa chỉ chi tiết -->
            <div class="col-12">
                <div class="border rounded p-3">
                    <h6 class="mb-3">Địa chỉ giao hàng (GHN)</h6>

                    <div class="row g-2">
                        <div class="col-md-4">
                            <label class="form-label">Tỉnh / Thành phố</label>
                            <select id="provinceSelect" class="form-select" placeholder="Chọn Tỉnh - Thành phố"></select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Quận / Huyện</label>
                            <select id="districtSelect" class="form-select" placeholder="Chọn Quận - Huyện" disabled></select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phường / Xã</label>
                            <select id="wardSelect" class="form-select" placeholder="Chọn Phường - Xã" disabled></select>
                        </div>
                    </div>

                    <!-- Ô Địa chỉ chi tiết chuyển xuống đây -->
                    <div class="row g-2 mt-2">
                        <div class="col-12">
                            <label class="form-label" for="diaChi">Địa chỉ chi tiết</label>
                            <input type="text" class="form-control" id="diaChi" placeholder="Số nhà, đường…" required>
                        </div>
                    </div>

                    <!-- Hidden fields dùng nội bộ -->
                    <input id="toDistrictId" type="hidden">
                    <input id="toWardCode"  type="hidden">

                    <div class="mt-2 small text-muted" id="shipBreakdown"></div>
                </div>
            </div>

            <div class="col-12 d-flex gap-2">
                <button type="submit" class="btn btn-success">Xác nhận đặt hàng</button>
                <button type="button" class="btn btn-light" id="btn-cancel-checkout">Huỷ</button>
            </div>
        </div>
    </form>
</div>

<script>
    /* ============== BASE & ENDPOINTS ============== */
    const BASE = '${pageContext.request.contextPath}';
    const API = {
        items:    BASE + '/cart/items',
        update:   BASE + '/cart/update',
        remove:   BASE + '/cart/remove',
        clear:    BASE + '/cart/clear',
        checkout: BASE + '/cart/checkout',
        me:       BASE + '/khachhang/api/me' // tự fill khi đã đăng nhập
    };
    const GHN = {
        provinces: BASE + '/api/ghn/provinces',
        districts: pid => BASE + '/api/ghn/districts?provinceId=' + encodeURIComponent(pid),
        wards:     did => BASE + '/api/ghn/wards?districtId=' + encodeURIComponent(did),
        services:  BASE + '/api/ghn/services',
        fee:       BASE + '/api/ghn/fee'
    };

    /* ============== HELPERS ============== */
    const vnd = n => (Number(n||0)).toLocaleString('vi-VN') + '₫';
    function getCsrfHeaders(){
        const t=document.querySelector('meta[name="_csrf"]')?.content;
        const h=document.querySelector('meta[name="_csrf_header"]')?.content;
        return (t&&h)?{[h]:t}:{ };
    }
    async function getJSON(url){
        const res=await fetch(url,{credentials:'same-origin'});
        const data=await res.json().catch(()=>null);
        if(!res.ok) throw Object.assign(new Error('HTTP '+res.status), {status:res.status, data});
        return data;
    }
    // POST form nhưng KHÔNG throw để tự xử lý 409
    async function sendForm(url,obj){
        const body=new URLSearchParams();
        Object.entries(obj||{}).forEach(([k,v])=>body.append(k, v==null?'':v));
        const res=await fetch(url,{
            method:'POST',
            headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',...getCsrfHeaders()},
            body,
            credentials:'same-origin'
        });
        const ct=res.headers.get('content-type')||'';
        const data = ct.includes('application/json') ? await res.json().catch(()=>null)
            : await res.text().catch(()=>null);
        return { ok: res.ok, status: res.status, data, response: res };
    }
    async function postForm(url,obj){
        const r=await sendForm(url,obj);
        if(!r.ok) throw new Error(r.data?.message||r.data||('HTTP '+r.status));
        return r.data;
    }
    async function apiJson(url,method,body){
        const res=await fetch(url,{
            method,
            headers:{'Content-Type':'application/json',...getCsrfHeaders()},
            body:body?JSON.stringify(body):undefined,
            credentials:'same-origin'
        });
        const ct=res.headers.get('content-type')||'';
        const data=ct.includes('application/json')?await res.json():await res.text();
        if(!res.ok) throw new Error(typeof data==='string'?data:(data.message||'Lỗi API'));
        return data;
    }
    function pick(o,...ks){ for(const k of ks){ const v=o?o[k]:undefined; if(v!==undefined&&v!==null&&v!=='') return v; } }
    function fillSelect(sel,arr,placeholder){
        sel.innerHTML='';
        if(placeholder) sel.insertAdjacentHTML('beforeend','<option value="">'+placeholder+'</option>');
        (arr||[]).forEach(it=>sel.insertAdjacentHTML('beforeend','<option value="'+it.val+'">'+it.label+'</option>'));
        sel.disabled=!arr||!arr.length;
    }
    function escapeHtml(s){
        return String(s).replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
    }

    // Chuẩn hoá để khớp tên tỉnh/huyện/xã
    function normalize(txt){
        return (txt||'').toLowerCase()
            .normalize('NFD').replace(/[\u0300-\u036f]/g,'')
            .replace(/\b(tp\.?|thanh pho|tinh|quan|huyen|thi xa|thi tran|phuong|xa)\b/g,'')
            .replace(/-/g,' ').replace(/\s+/g,' ').trim();
    }
    function findOptionByLabel(sel, name){
        if(!sel || !name) return null;
        const target = normalize(name);
        let best=null;
        for(const opt of sel.options){
            const lab = normalize(opt.textContent||opt.innerText||'');
            if(lab===target) return opt;
            if(!best && lab.includes(target)) best=opt;
        }
        return best;
    }
    function setSelectByName(sel, name){
        const opt=findOptionByLabel(sel,name);
        if(opt){ sel.value=opt.value; sel.dispatchEvent(new Event('change',{bubbles:true})); return true; }
        return false;
    }
    function waitForOptions(sel, min=2, timeoutMs=6000){
        return new Promise(resolve=>{
            const start=Date.now();
            const id=setInterval(()=>{
                if(sel && sel.options && sel.options.length>=min){ clearInterval(id); resolve(true); }
                else if(Date.now()-start>timeoutMs){ clearInterval(id); resolve(false); }
            },100);
        });
    }

    /* ============== STATE ============== */
    let items = [];
    const DEFAULT_SERVICE_ID = 53320; // Hàng nhẹ
    const DEFAULT_DIM = { weight:500, length:20, width:15, height:10 };
    const shipping = {
        total: 0, serviceId: null, toDistrictId: null, toWardCode: null,
        weight: DEFAULT_DIM.weight, length: DEFAULT_DIM.length, width: DEFAULT_DIM.width, height: DEFAULT_DIM.height,
        leadtime: null, breakdown: ''
    };

    /* ============== CART UI ============== */
    // Nếu BE trả về khaDung/available/stock thì đọc để đặt max ở input
    function mapCartItem(r){
        return {
            spctId: Number(r.spctId??r.id??0),
            ten: r.ten||'Sản phẩm',
            mau: r.mau||null,
            size: r.size||null,
            anh: r.anh||'/images/no-image.png',
            gia: Number(r.gia??0),
            soLuong: Number(r.soLuong??0),
            max: Number(r.khaDung ?? r.available ?? r.stock ?? 0)
        };
    }
    function subtotal(){
        return items.reduce((s,it)=>s+(Number(it.gia)||0)*(Number(it.soLuong)||0),0);
    }
    function updateTotals(){
        const sub=subtotal();
        document.getElementById('subtotal-amount').textContent=vnd(sub);
        document.getElementById('ship-amount').textContent=vnd(shipping.total||0);
        document.getElementById('grand-amount').textContent=vnd(sub+(shipping.total||0));
        document.getElementById('ship-note').textContent=shipping.serviceId?('(DV #'+shipping.serviceId+')'):'(chưa tính phí)';
    }
    function invalidateShipping(){
        shipping.total=0; shipping.breakdown='';
        const el=document.getElementById('shipBreakdown'); if(el) el.textContent='';
        updateTotals();
    }

    // Kẹp giá trị ngay khi người dùng gõ
    window.clampQty = (idx, max, input) => {
        let v = parseInt(input.value || '1', 10);
        if (isNaN(v) || v < 1) v = 1;
        if (max && v > max) v = max;
        input.value = v;
    };

    function renderCart(){
        const container = document.getElementById('cart-items-container');
        if(!items.length){
            container.innerHTML = "<p class='text-center muted'>Giỏ hàng trống</p>";
            document.getElementById('summary-note').innerText = '';
            updateTotals();
            return;
        }

        let html = '<div class="table-responsive"><table class="table table-bordered align-middle text-center">'
            + '<thead class="table-light"><tr>'
            + '<th>Ảnh</th><th>Tên sản phẩm</th><th>Giá</th>'
            + '<th style="width:130px">Số lượng</th><th>Thành tiền</th><th>Xoá</th>'
            + '</tr></thead><tbody>';

        items.forEach((it, idx) => {
            const name = it.ten + (it.mau ? ' - Màu: ' + it.mau : '') + (it.size ? ' - Size: ' + it.size : '');
            const tt = (Number(it.gia)||0) * (Number(it.soLuong)||0);
            const maxAttr = it.max ? ' max="'+it.max+'"' : '';

            html += '<tr>'
                +   '<td><img class="img-thumb" src="' + it.anh + '" alt="' + escapeHtml(it.ten) + '"></td>'
                +   '<td class="text-start">' + escapeHtml(name) + '</td>'
                +   '<td>' + vnd(it.gia) + '</td>'
                +   '<td>'
                +     '<input id="qty-' + idx + '" type="number" min="1"' + maxAttr + ' class="form-control"'
                +            ' value="' + it.soLuong + '"'
                +            ' oninput="clampQty(' + idx + ',' + (it.max||0) + ',this)"'
                +            ' onchange="onQtyChange(' + idx + ', this.value)">'
                +   '</td>'
                +   '<td><strong>' + vnd(tt) + '</strong></td>'
                +   '<td><button class="btn btn-sm btn-danger" onclick="onRemove(' + idx + ')">Xoá</button></td>'
                + '</tr>';
        });

        html += '</tbody></table></div>';

        container.innerHTML = html;
        document.getElementById('summary-note').innerText = 'Đã chọn ' + items.length + ' sản phẩm';
        updateTotals();
    }

    async function loadCart(){
        try{
            document.getElementById('cart-items-container').innerHTML="<p class='text-center muted'>Đang tải giỏ hàng…</p>";
            const data=await getJSON(API.items);
            items=Array.isArray(data)?data.map(mapCartItem):[];
            renderCart();
        }catch(e){
            document.getElementById('cart-items-container').innerHTML="<p class='text-center text-danger'>Không tải được giỏ hàng.</p>";
            console.error(e);
        }
    }

    /* ============== CART ACTIONS (CHẶN VƯỢT TỒN KHO) ============== */
    window.onQtyChange = async (idx,val)=>{
        const input = document.getElementById('qty-'+idx);
        let qty=Math.max(1,parseInt(val||'1',10));
        const max = Number(items[idx].max||0);
        if (max && qty > max) qty = max; // chặn ngay ở FE

        const spctId=items[idx].spctId;
        const res = await sendForm(API.update,{ spctId, soLuong:qty });

        if(res.ok){
            items[idx].soLuong=qty;
            renderCart(); invalidateShipping(); autoLoadServiceAndFee();
            return;
        }
        if(res.status===409){
            // BE có thể trả {message, allowed | max | khaDung, appliedQty}
            const applied = Number(res.data?.appliedQty ?? res.data?.allowed ?? res.data?.max ?? res.data?.khaDung ?? 1);
            items[idx].soLuong = applied;
            if(input) input.value = applied;
            renderCart(); invalidateShipping(); autoLoadServiceAndFee();
            alert(res.data?.message || 'Số lượng vượt tồn kho, đã điều chỉnh.');
            return;
        }
        alert((res.data && (res.data.message||res.data)) || 'Cập nhật số lượng thất bại.');
        console.error('update error', res);
    };

    window.onRemove = async (idx)=>{
        if(!confirm('Xoá sản phẩm này khỏi giỏ?')) return;
        const spctId=items[idx].spctId;
        const res = await sendForm(API.remove,{ spctId });
        if(res.ok){
            items.splice(idx,1);
            renderCart(); invalidateShipping(); autoLoadServiceAndFee();
        }else{
            alert('Xoá thất bại.'); console.error(res);
        }
    };

    document.getElementById('btn-clear').addEventListener('click', async ()=>{
        if(!items.length) return;
        if(!confirm('Xoá toàn bộ giỏ hàng?')) return;
        const res = await sendForm(API.clear,{});
        if(res.ok){ items=[]; renderCart(); invalidateShipping(); } else { alert('Không xoá được giỏ.'); }
    });

    /* ============== GHN: ADDRESS PICKERS + AUTO FEE ============== */
    async function initAddressPickers(){
        const pSel=document.getElementById('provinceSelect'),
            dSel=document.getElementById('districtSelect'),
            wSel=document.getElementById('wardSelect');

        try{
            const provRes=await getJSON(GHN.provinces);
            const provList=Array.isArray(provRes)?provRes:(provRes.data||provRes.provinces||[]);
            const provs=provList.map(p=>({val:pick(p,'provinceId','ProvinceID','code','ProvinceCode','id'),label:pick(p,'provinceName','ProvinceName','name','province')})).filter(x=>x.val&&x.label);
            fillSelect(pSel,provs,'Chọn Tỉnh - Thành phố'); dSel.disabled=true; wSel.disabled=true;
        }catch(e){ console.error('Load provinces failed',e); }

        pSel.addEventListener('change', async ()=>{
            const pid=Number(pSel.value);
            document.getElementById('toDistrictId').value=''; document.getElementById('toWardCode').value='';
            wSel.innerHTML=''; wSel.disabled=true; invalidateShipping();
            if(!pid){ dSel.innerHTML=''; dSel.disabled=true; return; }

            const distRes=await getJSON(GHN.districts(pid));
            const distList=Array.isArray(distRes)?distRes:(distRes.data||distRes.districts||[]);
            const dists=distList.map(d=>({val:pick(d,'districtId','DistrictID','code','DistrictCode','id'),label:pick(d,'districtName','DistrictName','name','district')})).filter(x=>x.val&&x.label);
            fillSelect(dSel,dists,'Chọn Quận - Huyện');
        });

        dSel.addEventListener('change', async ()=>{
            const did=Number(dSel.value);
            document.getElementById('toDistrictId').value = did || '';
            document.getElementById('toWardCode').value   = '';
            invalidateShipping();
            if(!did){ wSel.innerHTML=''; wSel.disabled=true; return; }

            const wardRes=await getJSON(GHN.wards(did));
            const wardList=Array.isArray(wardRes)?wardRes:(wardRes.data||wardRes.wards||[]);
            const wards=wardList.map(w=>({val:pick(w,'wardCode','WardCode','code','id'),label:pick(w,'wardName','WardName','name','ward')})).filter(x=>x.val&&x.label);
            fillSelect(wSel,wards,'Chọn Phường - Xã');
        });

        wSel.addEventListener('change', ()=>{
            document.getElementById('toWardCode').value = wSel.value || '';
            autoLoadServiceAndFee(); // tự tính phí ngay
        });

        if(window.TomSelect){
            new TomSelect('#provinceSelect',{create:false,sortField:{field:'text',direction:'asc'}});
            new TomSelect('#districtSelect',{create:false,sortField:{field:'text',direction:'asc'}});
            new TomSelect('#wardSelect',{create:false,sortField:{field:'text',direction:'asc'}});
        }
    }

    function getToAddress(){
        const toDistrictId = Number(document.getElementById('toDistrictId').value || document.getElementById('districtSelect')?.value) || null;
        const toWardCode   = (document.getElementById('toWardCode').value || document.getElementById('wardSelect')?.value || '').trim() || null;
        return { toDistrictId, toWardCode };
    }
    function setBusy(b){ /* hook nếu cần spinner */ }
    function pickServiceId(services){
        if(!Array.isArray(services)||!services.length) return null;
        const fid=s=>s?.serviceId??s?.service_id??s?.serviceTypeId??s?.service_type_id;
        const prefer=services.find(s=>String(fid(s))===String(DEFAULT_SERVICE_ID));
        return fid(prefer||services[0])||null;
    }
    async function autoLoadServiceAndFee(){
        const {toDistrictId,toWardCode} = getToAddress();
        if(!toDistrictId || !toWardCode){ invalidateShipping(); return; }
        try{
            setBusy(true);
            const services = await apiJson(GHN.services,'POST',{toDistrictId,toWardCode});
            const chosenId = pickServiceId(services);
            if(!chosenId){ invalidateShipping(); alert('Không có dịch vụ GHN phù hợp.'); return; }

            const dims = { ...DEFAULT_DIM };
            const resp = await apiJson(GHN.fee,'POST',{ serviceId:Number(chosenId), toDistrictId, toWardCode, ...dims });

            const total      = Number(resp.total ?? resp.data?.total ?? 0);
            const serviceFee = resp.serviceFee ?? resp.data?.serviceFee ?? null;
            const insurance  = resp.insuranceFee ?? resp.data?.insuranceFee ?? null;
            const lead       = resp.leadtime ?? resp.data?.leadtime ?? null;

            shipping.total=total; shipping.serviceId=Number(chosenId);
            shipping.toDistrictId=toDistrictId; shipping.toWardCode=toWardCode;
            shipping.weight=dims.weight; shipping.length=dims.length; shipping.width=dims.width; shipping.height=dims.height;
            shipping.leadtime=lead;

            const bd=[]; if(serviceFee!=null) bd.push('Phí GHN: '+vnd(serviceFee));
            if(insurance!=null) bd.push('Bảo hiểm: '+vnd(insurance));
            if(lead) bd.push('Dự kiến: '+new Date(lead*1000).toLocaleString('vi-VN'));
            shipping.breakdown = bd.join(' • ');
            const bdEl=document.getElementById('shipBreakdown'); if(bdEl) bdEl.textContent=shipping.breakdown;
            const noteEl=document.getElementById('ship-note'); if(noteEl) noteEl.textContent='(DV #'+chosenId+')';
            updateTotals();
        }catch(e){
            console.error(e); invalidateShipping(); alert('Không lấy được phí GHN: '+(e?.message||'Lỗi không xác định'));
        }finally{ setBusy(false); }
    }

    /* ============== PREFILL TỪ TÀI KHOẢN ============== */
    async function prefillFromAccount(){
        try{
            const me = await getJSON(API.me); // {loggedIn, hoTen/hoVaTen, soDienThoai, diaChiChiTiet, tinh,huyen,xa}
            if(!me || !me.loggedIn) return;

            const nameCandidate = me.hoTen || me.hoVaTen || me.fullName || me.ten || me.name || "";
            if(nameCandidate) document.getElementById('hoTen').value = nameCandidate;
            if(me.soDienThoai) document.getElementById('sdt').value = me.soDienThoai;
            if(me.diaChiChiTiet) document.getElementById('diaChi').value = me.diaChiChiTiet;

            const pSel=document.getElementById('provinceSelect');
            const dSel=document.getElementById('districtSelect');
            const wSel=document.getElementById('wardSelect');

            const okP = await waitForOptions(pSel, 2);
            if(!okP) return;

            if(me.tinh) setSelectByName(pSel, me.tinh);
            await waitForOptions(dSel, 2);
            if(me.huyen) setSelectByName(dSel, me.huyen);
            await waitForOptions(wSel, 2);
            if(me.xa){
                setSelectByName(wSel, me.xa);
                document.getElementById('toWardCode').value = wSel.value || '';
            }
            autoLoadServiceAndFee();
        }catch(e){
            console.warn('Không tự điền được từ tài khoản:', e);
        }
    }

    /* ============== CHECKOUT ============== */
    const formEl=document.getElementById('checkout-form');
    document.getElementById('btn-checkout').addEventListener('click', ()=>{
        if(!items.length){ alert('Giỏ hàng trống, không thể thanh toán!'); return; }
        formEl.style.display=(formEl.style.display==='none'||!formEl.style.display)?'block':'none';
    });
    document.getElementById('btn-cancel-checkout').addEventListener('click', ()=> formEl.style.display='none');

    formEl.addEventListener('submit', async (e)=>{
        e.preventDefault();
        const hoTen=document.getElementById('hoTen').value.trim();
        const sdt=document.getElementById('sdt').value.trim();
        const diaChi=document.getElementById('diaChi').value.trim();
        if(!hoTen||!sdt||!diaChi){ alert('Vui lòng điền đầy đủ thông tin.'); return; }

        try{
            const resp = await postForm(API.checkout,{
                hoTen,sdt,diaChi,
                shipServiceId:shipping.serviceId??'',
                shipToDistrictId:shipping.toDistrictId??'',
                shipToWardCode:shipping.toWardCode??'',
                shipWeight:shipping.weight??'',
                shipLength:shipping.length??'',
                shipWidth:shipping.width??'',
                shipHeight:shipping.height??'',
                shipFee:shipping.total??0
            });
            alert(typeof resp==='string'?resp:'Đặt hàng thành công');
            items=[]; renderCart(); invalidateShipping(); formEl.reset(); formEl.style.display='none';
        }catch(e2){
            alert('Thanh toán thất bại.'); console.error(e2);
        }
    });

    /* ============== INIT ============== */
    document.getElementById('btn-refresh').addEventListener('click', loadCart);
    (async function init(){
        await loadCart();
        await initAddressPickers();
        await prefillFromAccount();
    })();
</script>

