<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <h3>Chi tiết Thương Hiệu</h3>
    <a href="/admin/brand" class="btn mb-2"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    <div class="card">
        <div class="card-body">
            <!-- Hidden ID -->
            <input type="hidden" class="form-control" name="id" id="id" value="${thuongHieu.id}">
            <div class="mb-3">
                <label class="form-label">Tên Thương Hiệu</label>
                <input type="text" class="form-control" name="tenThuongHieu" readonly value="${thuongHieu.tenThuongHieu}">
            </div>
        </div>
    </div>
</div>

