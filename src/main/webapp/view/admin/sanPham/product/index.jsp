<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<!-- jQuery (nếu chưa có) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- DataTables core + Bootstrap5 JS -->
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<div class="container">
<div class="card mt-4" style="border: 1px solid #006d7f; background-color: white;">
    <div class="card-body">

        <!-- Tiêu đề và nút Thêm -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 style="color: #001f3d;">Quản Lý Sản Phẩm</h4>
            <a href="/admin/product/add"class="btn btn-teal"><i class="fa-solid fa-plus"></i>
                Thêm Sản Phẩm
            </a>
        </div>

        <!-- Bộ lọc tìm kiếm và trạng thái -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input type="text" id="input_search_product" class="form-control" name="key"
                           placeholder="Nhập tên sản phẩm...">
                    <button class="btn" id="btn_search_product"
                            style="background-color: #001f3d; color: white; border: 1px solid #006d7f;">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </div>
            </div>
            <div class="col-md-6 d-flex align-items-center">
                <label class="me-3" style="font-size: 16px; color: #001f3d;">Trạng Thái:</label>
                <div class="form-check me-3">
                    <input class="form-check-input" id="status_type_all" type="radio" name="status_type" value="" checked>
                    <label class="form-check-label" for="status_type_all">Tất Cả</label>
                </div>
                <div class="form-check me-3">
                    <input class="form-check-input" id="status_type_online" type="radio" name="status_type" value="HOAT_DONG">
                    <label class="form-check-label" for="status_type_online">Đang bán</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" id="status_type_offline" type="radio" name="status_type" value="NGUNG_HOAT_DONG">
                    <label class="form-check-label" for="status_type_offline">Ngừng bán</label>
                </div>
            </div>
        </div>

        <!-- Bảng sản phẩm -->
        <table class="table table-hover " id="productTable">
            <thead style="background-color: #001f3d; color: white;">
            <tr class="text-center">
                <th>#</th>
                <th>Mã Sản Phẩm</th>
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
            <!-- Dữ liệu sẽ được chèn vào đây bởi JavaScript -->
            </tbody>
        </table>

    </div>
</div>
</div>

<style>
    .btn-teal {
        background-color: #001f3d;
        border-radius: 20px;
        color: white;
    }

    .btn-teal:hover {
        background-color: #004080;
        color: white;
    }
    .btn {
        border: 1px solid #cccccc !important;
        border-radius: 4px !important;
    }

    .btn:hover {
        background-color: #004080 !important;
        color: white !important;
    }

    .table th, .table td {
        border: 1px solid #dcdcdc !important; /* Màu viền nhẹ hơn */
        vertical-align: middle;
    }

    .table-striped tbody tr:nth-of-type(odd) {
        background-color: #f9f9f9;
    }

    thead {
        border: 1px solid #dcdcdc !important;
    }
</style>


<script>
    $(document).ready(function () {
        let productTable = $('#productTable').DataTable({
            paging: true,
            searching: false,
            ordering: false,
            info: false,
            lengthChange: false,
            pageLength: 10,
            columnDefs: [
                {"className": "text-center", "targets": "_all"}
            ],
        });

        function loadTableProduct() {
            const search = $('#input_search_product').val();
            const status = $('input[name="status_type"]:checked').val();

            $.ajax({
                url: '/admin/product/list',
                method: 'GET',
                dataType: 'json',
                data: { search: search, status: status },
                success: function (data) {
                    productTable.clear();
                    $.each(data.data, function (index, item) {
                        productTable.row.add([
                            index + 1,
                            item.maSanPham,
                            item.sanPham,
                            item.danhMuc,
                            item.thuongHieu,
                            item.xuatXu,
                            item.soLuong,
                            convertStatusProduct(item.trangThai),
                            '<a href="/admin/product/detail/' + item.id + '" class="btn btn-sm btn-info me-1"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/product/update/' + item.id + '" class="btn btn-sm btn-success me-1"><i class="fa-solid fa-pen"></i></a>'
                        ]);
                    });
                    productTable.draw();
                },
                error: function () {
                    alert('Lỗi khi lấy dữ liệu sản phẩm');
                }
            });
        }

        $('input[name="status_type"]').change(loadTableProduct);
        $('#btn_search_product').click(loadTableProduct);
        loadTableProduct();
    });

    function convertStatusProduct(status) {
        if (status === 'HOAT_DONG') return 'Đang bán';
        if (status === 'NGUNG_HOAT_DONG') return 'Ngừng bán';
        return 'Không xác định';
    }
</script>
