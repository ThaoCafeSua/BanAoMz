<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Toastr CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<!-- Toastr JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container mt-4">
    <h2 class="mb-4">Quản Lý Danh Mục</h2>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mb-4" style="border: 1px solid #006d7f; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Tìm kiếm
            </h5>

            <div class="row justify-content-center mb-3">
                <div class="col-md-6">
                    <div class="input-group w-100">
                        <input id="input_search" class="form-control" name="key" placeholder="Tìm kiếm tên danh mục ..." />
                        <button id="btn_search" class="btn btn-teal" type="submit">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="card mt-4 custom-border"> <!-- Áp dụng custom-border cho card danh sách -->
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Danh sách danh mục</h5>
                <a href="/admin/category/create" class="btn btn-teal"><i class="fa-solid fa-plus"></i> Thêm danh mục</a>
            </div>
            <table class="table" id="customerTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên danh mục</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Custom Styles -->
<style>
    .custom-border {
        border: 1px solid  #001f3d;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 8px;
    }
    /* Thay đổi màu sắc các nút */
    .btn-teal {
        background-color: #001f3d; /* Màu nền xanh than */
        border-radius: 20px;
        color: white; /* Màu chữ trắng */
    }

    .btn-teal:hover {
        background-color: #004080; /* Thay đổi màu nền khi hover */
        color: white; /* Màu chữ vẫn là trắng */
    }

    #input_search {
        border-radius: 20px;
        padding: 10px;
        border: 1px solid #001f3d; /* Viền cho ô tìm kiếm */
    }

    #btn_search {
        border-radius: 20px;
        padding: 10px 20px;
        background-color: #001f3d; /* Nền cho nút tìm kiếm */
        color: white; /* Màu chữ trắng */
    }

    #btn_search:hover {
        background-color: #004080; /* Màu nền khi hover */
        color: white; /* Màu chữ vẫn là trắng */
    }

    .table th, .table td {
        text-align: center;
        vertical-align: middle;
    }

    .table {
        margin-top: 20px;
        border-radius: 8px;
    }

    .card-title {
        font-size: 20px;
        font-weight: bold;
    }

    #input_search {
        border-radius: 20px;
        padding: 10px;
        border: 1px solid #001f3d; /* Thêm viền cho input */
    }
    /* Màu xanh dương cho các nút */
    .btn-info {
        background-color: #001f3d; /* Màu xanh dương đậm */
        border-color: #001f3d; /* Màu viền */
        margin-right: 5px; /* Tạo khoảng cách giữa icon và chữ */

    }
    .btn-info:hover {
        background-color: #004080; /* Màu nền khi hover (xanh dương nhạt hơn) */
        border-color: #004080; /* Màu viền khi hover */
    }

    /* Chỉnh màu icon bên trong button */
    .btn-info i {
        color: white; /* Màu trắng cho các icon */
    }

    /* Màu nền khi hover */
    .btn-info:hover i {
        color: white; /* Giữ màu icon trắng khi hover */
    }


</style>
<script>
    $(document).ready(function () {
        let categoryTable = $('#customerTable').DataTable({
            "paging": true,
            "searching": false,
            "ordering": false,
            "info": false,
            "lengthChange": false,
            "pageLength": 5,
            "columnDefs": [{"className": "text-center", "targets": "_all"}],
            "language": {
                "emptyTable": "Không có dữ liệu"
            }
        });

        function loadTableCategory() {
            const search = $('#input_search').val();
            $.ajax({
                url: '/admin/category/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (response) {
                    categoryTable.clear();
                    if (response.data.length === 0) {
                        toastr.warning('Không tìm thấy danh mục nào phù hợp.', 'Thông báo');
                    }
                    $.each(response.data, function (index, category) {
                        categoryTable.row.add([
                            index + 1,
                            category.tenDanhMuc,
                            '<a href="/admin/category/detail/' + category.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/category/update/' + category.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>'
                        ]);
                    });
                    categoryTable.draw();
                },
                error: function (xhr, status, error) {
                    console.error(error);
                    toastr.error('Đã xảy ra lỗi khi tải danh mục.', 'Lỗi hệ thống');
                }
            });
        }

        $('#btn_search').click(function () {
            loadTableCategory();
        });

        loadTableCategory();
    });

</script>
