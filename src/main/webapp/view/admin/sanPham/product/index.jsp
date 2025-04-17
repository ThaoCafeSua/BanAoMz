<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div>
    <!-- Tiêu đề Quản lý Sản Phẩm -->
    <h2 class="mb-4">Quản Lý Sản Phẩm</h2>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mt-4" style="border: 2px solid #b85555; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Bộ Lọc
            </h5>
            <div class="row" style="align-items: center">
                <div class="col-md-6">
                    <div class="input-group mb-3">
                        <input type="text" id="input_search_product" class="form-control"  name="key" placeholder="Nhập tên sản phẩm...">
                        <button class="btn btn-outline-secondary" id="btn_search_product" type="button" style="background-color: #b85555; color: white;"><i class="fas fa-search"></i> Tìm kiếm</button>
                    </div>
                </div>
                <div class="col-md-6 pl-4">
                    <div class="col d-flex">
                        <label style="font-size: 18px">Trạng Thái:</label>
                        <div class="d-flex ml-4">
                            <div class="form-check">
                                <input class="form-check-input" id="status_type_all" type="radio" name="status_type"  value="" checked>
                                <label class="form-check-label" for="status_type_all">
                                    Tất Cả
                                </label>
                            </div>
                            <div class="form-check ml-2">
                                <input class="form-check-input" id="status_type_online" type="radio" name="status_type" value="HOAT_DONG">
                                <label class="form-check-label" for="status_type_online">
                                    Đang bán
                                </label>
                            </div>
                            <div class="form-check ml-2">
                                <input class="form-check-input" id="status_type_offline" type="radio" name="status_type" value="NGUNG_HOAT_DONG">
                                <label class="form-check-label" for="status_type_offline">
                                    Ngừng bán
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-row mb-4">
<%--                <div class="col">--%>
<%--                    <label for="danhMuc">Danh mục</label>--%>
<%--                    <select class="form-control" id="danhMuc" name="danhMuc">--%>
<%--                        <option value="">Chọn danh mục</option>--%>
<%--                        <c:forEach items="${dsDanhMuc}" var="dm">--%>
<%--                            <option value="${dm.id}">${dm.tenDanhMuc}</option>--%>
<%--                        </c:forEach>--%>
<%--                    </select>--%>
<%--                </div>--%>

<%--                <div class="col">--%>
<%--                    <label for="xuatXu">Xuất xứ</label>--%>
<%--                    <select class="form-control" id="xuatXu" name="xuatXu">--%>
<%--                        <option value="">Chọn xuất xứ</option>--%>
<%--                        <c:forEach items="${dsXuatXu}" var="xx">--%>
<%--                            <option value="${xx.id}">${xx.tenXuatXu}</option>--%>
<%--                        </c:forEach>--%>
<%--                    </select>--%>
<%--                </div>--%>

<%--                <div class="col">--%>
<%--                    <label for="thuongHieu">Thương hiệu</label>--%>
<%--                    <select class="form-control" id="thuongHieu" name="thuongHieu">--%>
<%--                        <option value="">Chọn thương hiệu</option>--%>
<%--                        <c:forEach items="${dsThuongHieu}" var="th">--%>
<%--                            <option value="${th.id}">${th.tenThuongHieu}</option>--%>
<%--                        </c:forEach>--%>
<%--                    </select>--%>
<%--                </div>--%>
            </div>
        </div>
    </div>
    <!-- Danh sách sản phẩm -->
    <div class="card mt-4" style="border: 2px solid #b85555; background-color: white;">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-4">Danh Sách Sản Phẩm</h5>
                <a href="/admin/product/add" class="btn btn-pink" style="background-color: #b85555; color: white;">
                    + Thêm Sản Phẩm
                </a>
            </div>
        </div>

        <div class="card-body bg-white">
            <table class="table" id="productTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Danh Mục</th>
                    <th>Thương Hiệu</th>
                    <th>Xuất Xứ</th>
                    <th>Số Lượng</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        let productTable = $('#productTable').DataTable({
            "paging": true,        // Bật phân trang
            "searching": false,     // Bật tìm kiếm
            "ordering": false,      // Bật sắp xếp
            "info": false,          // Bật thông tin tổng quan
            "lengthChange": false,  // Cho phép thay đổi số lượng bản ghi hiển thị
            "pageLength": 5,       // Số lượng bản ghi trên mỗi trang
            "columnDefs": [
                {"className": "text-center", "targets": "_all"}
            ],
        });
        $('input[name="status_type"]').change(function () {
            loadTableProduct();
        });
        function loadTableProduct() {
            const search = $('#input_search_product').val();
            const status = $('input[name="status_type"]:checked').val();

            $.ajax({
                url: '/admin/product/list',
                method: 'GET',
                dataType: 'json',
                data: {
                    search: search,
                    status: status
                },
                success: function (data) {
                    productTable.clear();
                    $.each(data.data, function (index, item) {
                        productTable.row.add([
                            index + 1,
                            item.sanPham,
                            item.danhMuc,
                            item.thuongHieu,
                            item.xuatXu,
                            item.soLuong,
                            convertStatusProduct(item.trangThai),
                            '<a  href="/admin/product/detail/' + item.id + '"  class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/product/update/' + item.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>'+
                            '<button class="btn btn-danger btn-sm btn-delete-product" data-product-id="' + item.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    productTable.draw();
                },
                error: function (err) {
                    // toastr.error('Lỗi khi lấy dữ liệu', err);
                }
            });
        }

        $(document).on('click', '#btn_search_product', function () {
            loadTableProduct()
        });
        loadTableProduct()

        // Xóa thương hiệu
        $(document).on('click', '.btn-delete-product', function () {
            let id = $(this).data('product-id');
            Swal.fire({
                title: 'Bạn có chắc muốn xóa sản phẩm này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/admin/product/delete',
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(id),
                        success: function () {
                            toastr.success('Xóa sản phẩm thành công');
                            loadTableProduct();
                        },
                        error: function () {
                            toastr.error('Xóa sản phẩm lỗi');
                        }
                    });
                }
            });
        });
    })

</script>