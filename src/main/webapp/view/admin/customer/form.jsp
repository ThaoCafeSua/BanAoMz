<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<%-- Chuẩn hoá giá trị ngày sinh để nhét vào input type="date" --%>
<fmt:formatDate value="${customer.ngaySinh}" pattern="yyyy-MM-dd" var="dobRaw"/>
<c:set var="dobVal" value="${fn:trim(dobRaw)}"/>

<div class="container">
    <h3 style="color: #001f3d;" class="mt-4">Khách hàng</h3>
    <a href="/admin/customer" class="btn btn-outline-secondary btn-sm mb-3">
        <i class="fa-solid fa-arrow-left"></i>
    </a>

    <div class="card" style="border: 1px solid #006d7f; border-radius: 10px;">
        <div class="card-body">
            <form id="customerForm" action="${action}" method="post" novalidate>
                <input type="hidden" name="id" id="id" value="${customer.id}"/>

                <!-- Tên khách hàng -->
                <div class="mb-3">
                    <label for="nameKh" class="form-label">Tên khách hàng</label>
                    <input type="text" class="form-control" name="hoVaTen" id="nameKh"
                           placeholder="Nhập tên khách hàng" value="${customer.hoVaTen}">
                </div>

                <!-- Giới tính -->
                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <div class="d-flex">
                        <c:forEach var="entry" items="${gender}">
                            <div class="me-4">
                                <input type="radio" id="gender${entry.key}" name="gioiTinh" value="${entry.key}"
                                       <c:if test="${customer.gioiTinh != null and customer.gioiTinh == entry.key}">checked</c:if>>
                                <label for="gender${entry.key}" class="form-check-label">${entry.value}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Ngày sinh -->
                <div class="mb-3">
                    <label for="dateKh" class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" id="dateKh" name="ngaySinh"
                           style="width:200px"
                           max="${today}"
                           value="${empty dobVal ? '' : dobVal}">
                    <div class="invalid-feedback" id="dobInvalid">Ngày sinh không được ở tương lai.</div>
                </div>

                <!-- Số điện thoại -->
                <div class="mb-3">
                    <label for="phoneKh" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phoneKh" name="soDienThoai"
                           value="${customer.soDienThoai}" placeholder="Nhập số điện thoại">
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label for="emailKh" class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="emailKh"
                           value="${customer.email}" placeholder="Nhập email khách hàng">
                </div>

                <!-- Mật khẩu -->
                <div class="mb-3">
                    <label for="matKhau" class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" name="matKhau" id="matKhau"
                           value="${customer.matKhau}" placeholder="Nhập mật khẩu khách hàng">
                </div>

                <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-teal">${btnText}</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .btn-teal { background-color:#001f3d;color:white;border-radius:20px;padding:6px 20px;border:1px solid #cccccc; }
    .btn-teal:hover { background-color:#004080;color:white; }
    .btn { border:1px solid #cccccc !important;border-radius:4px !important; }
    .btn:hover { background-color:#004080 !important;color:white !important; }
    .form-label { color:#001f3d;font-weight:500; }
    .form-control { border-radius:8px;border:1px solid #dcdcdc; }
    .card { background-color:white;border:1px solid #dcdcdc; }
    .is-invalid { border-color:#dc3545 !important; }
    .invalid-feedback { display:none; }
    .form-control.is-invalid + .invalid-feedback { display:block; }
    #toast-container{ z-index:99999 !important; }
</style>

<script>
    // Helpers ngày
    function parseYMD(str){
        const [y,m,d] = (str||'').split('-').map(Number);
        if(!y||!m||!d) return null;
        return new Date(y, m-1, d, 0,0,0,0);
    }
    function startOfToday(){ const t=new Date(); t.setHours(0,0,0,0); return t; }
    function markInvalid($el,msg){ $el.addClass('is-invalid'); if(msg) $('#dobInvalid').text(msg); }
    function clearInvalid($el){ $el.removeClass('is-invalid'); }

    function validateForm(e){
        e.preventDefault();

        const $form  = $("#customerForm");
        const name   = $("#nameKh").val().trim();
        const phone  = $("#phoneKh").val().trim();
        const email  = $("#emailKh").val().trim();
        const gender = $('input[name="gioiTinh"]:checked').val();
        const dobStr = $("#dateKh").val();
        const pw     = $("#matKhau").val();

        clearInvalid($("#dateKh"));

        if(!name){ toastr.error("Tên khách hàng không được để trống"); return; }
        if(!gender){ toastr.error("Vui lòng chọn giới tính."); return; }

        if(!dobStr){
            markInvalid($("#dateKh"), "Vui lòng nhập ngày sinh."); toastr.error("Vui lòng nhập ngày sinh."); return;
        }
        const dob = parseYMD(dobStr), today = startOfToday();
        if(!dob || isNaN(dob.getTime())){ markInvalid($("#dateKh"), "Ngày sinh không hợp lệ."); toastr.error("Ngày sinh không hợp lệ."); return; }
        if(dob > today){ markInvalid($("#dateKh"), "Ngày sinh không được ở tương lai."); toastr.error("Ngày sinh không được ở tương lai."); return; }

        if(!/^\d{10,11}$/.test(phone)){ toastr.error("Số điện thoại không hợp lệ. Vui lòng nhập 10–11 chữ số."); return; }
        if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)){ toastr.error("Email không hợp lệ."); return; }
        if(!pw || pw.length < 6){ toastr.error("Mật khẩu phải có ít nhất 6 ký tự."); return; }

        Swal.fire({
            title: 'Xác nhận ${fn:escapeXml(btnText)}?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then((result)=>{ if(result.isConfirmed){ $form[0].submit(); } });
    }

    $(function(){
        // Fallback đặt max nếu controller chưa truyền today
        const $date = $("#dateKh");
        if(!$date.attr('max')){ $date.attr('max', new Date().toISOString().split('T')[0]); }
        $date.on('input change', function(){ clearInvalid($(this)); });

        $("#customerForm").on("submit", validateForm);
    });
</script>

<c:if test="${not empty sessionScope.error}">
    <script>toastr.error('${fn:escapeXml(sessionScope.error)}');</script>
    <c:remove var="error" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.success}">
    <script>toastr.success('${fn:escapeXml(sessionScope.success)}');</script>
    <c:remove var="success" scope="session"/>
</c:if>
