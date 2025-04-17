<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <h3>Chi tiết Khối Lượng</h3>
    <a href="/admin/weight" class="btn mb-2"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    <div class="card">
        <div class="card-body">
            <input type="hidden" class="form-control" name="id" id="id" value="${khoiLuong.id}">
            <div class="mb-3">
                <label class="form-label">Tên Khối lượng:</label>
                <input type="text" class="form-control" name="tenKhoiLuong" value="${khoiLuong.tenKhoiLuong}">
            </div>
        </div>
    </div>
</div>
