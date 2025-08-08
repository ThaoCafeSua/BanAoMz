<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .title-primary {
        color: #001f3d;
        font-weight: bold;
    }

    .label-primary {
        color: #001f3d;
        font-weight: 500;
    }
</style>

<div>
    <h3 class="title-primary">Chi tiết Xuất Xứ</h3>

    <a href="/admin/origin" class="btn mb-2">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>

    <div class="card">
        <div class="card-body">
            <input type="hidden" class="form-control" name="id" id="id" value="${xuatXu.id}">

            <div class="mb-3">
                <label class="form-label label-primary">Tên Xuất Xứ:</label>
                <input type="text" class="form-control" name="tenXuatXu" readonly value="${xuatXu.tenXuatXu}">
            </div>

            <div class="mb-3">
                <label class="form-label label-primary">Trạng Thái:</label>
                <div>
                    <label>
                        <input type="radio" name="trangThai" value="HOAT_DONG"
                               <c:if test="${xuatXu.trangThai eq 'HOAT_DONG'}">checked</c:if> disabled>
                        Hoạt Động
                    </label>
                    &nbsp;&nbsp;
                    <label>
                        <input type="radio" name="trangThai" value="NGUNG_HOAT_DONG"
                               <c:if test="${xuatXu.trangThai eq 'NGUNG_HOAT_DONG'}">checked</c:if> disabled>
                        Ngừng Hoạt Động
                    </label>
                </div>
            </div>

        </div>
    </div>
</div>
