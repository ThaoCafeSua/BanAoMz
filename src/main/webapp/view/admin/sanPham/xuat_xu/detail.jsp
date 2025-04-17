<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <h3>Chi tiết Xuất Xứ</h3>
    <a href="/admin/origin" class="btn mb-2"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    <div class="card">
        <div class="card-body">
            <input type="hidden" class="form-control" name="id" id="id" value="${xuatXu.id}">
            <div class="mb-3">
                <label class="form-label">Tên Màu Sắc</label>
                <input type="text" readonly class="form-control" name="tenMauSac" value="${xuatXu.tenXuatXu}">
            </div>
        </div>
    </div>
</div>
