<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Thương Hiệu</title>

    <!-- Toastr -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <style>
        .custom-border {
            border: 1px solid #001f3d;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        .btn-teal {
            background-color: #001f3d;
            border-radius: 20px;
            color: white;
        }
        .btn-teal:hover {
            background-color: #004080;
            color: white;
        }
        #input_search {
            border-radius: 20px;
            padding: 10px;
            border: 1px solid #001f3d;
        }
        #btn_search {
            border-radius: 20px;
            padding: 10px 20px;
            background-color: #001f3d;
            color: white;
        }
        #btn_search:hover {
            background-color: #004080;
            color: white;
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
        .btn-info {
            background-color: #001f3d;
            border-color: #001f3d;
            margin-right: 5px;
        }
        .btn-info:hover {
            background-color: #004080;
            border-color: #004080;
        }
        .btn-info i {
            color: white;
        }
        .btn-info:hover i {
            color: white;
        }
    </style>
</head>

<body>

<div class="container mt-4">
    <h2 class="mb-4">Quản Lý Thương Hiệu</h2>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mb-4" style="border: 1px solid #006d7f; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3"><i class="fas fa-filter"></i> Tìm kiếm</h5>

            <div class="row justify-content-center mb-3">
                <div class="col-md-8">
                    <div class="input-group mb-3">
                        <input id="input_search" class="form-control" name="key" placeholder="Nhập tên thương hiệu ..." />
                        <button id="btn_search" class="btn btn-teal" type="button">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>

                    <div class="d-flex justify-content-center gap-4 mt-2">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status_type" id="status_all" value="" checked>
                            <label class="form-check-label" for="status_all">Tất cả</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status_type" id="status_active" value="HOAT_DONG">
                            <label class="form-check-label" for="status_active">Hoạt động</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status_type" id="status_inactive" value="NGUNG_HOAT_DONG">
                            <label class="form-check-label" for="status_inactive">Ngừng hoạt động</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mt-4 custom-border">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Danh sách thương hiệu</h5>
                <a href="/admin/brand/create" class="btn btn-teal"><i class="fa-solid fa-plus"></i> Thêm thương hiệu</a>
            </div>
            <table class="table" id="brandTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên Thương Hiệu</th>
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        let brandTable = $('#brandTable').DataTable({
            paging: true,
            searching: false,
            ordering: false,
            info: false,
            lengthChange: false,
            pageLength: 5,
            columnDefs: [{className: "text-center", targets: "_all"}],
            language: {
                emptyTable: "Không có dữ liệu"
            }
        });

        function loadTableBrand() {
            const search = $('#input_search').val();
            const status = $('input[name="status_type"]:checked').val();

            $.ajax({
                url: '/admin/brand/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search, status: status},
                success: function (response) {
                    brandTable.clear();
                    if (response.data.length === 0) {
                        alert('Không tìm thấy thương hiệu nào phù hợp.');
                    }
                    $.each(response.data, function (index, brand) {
                        brandTable.row.add([
                            index + 1,
                            brand.tenThuongHieu,
                            convertStatus(brand.trangThai),
                            '<a href="/admin/brand/detail/' + brand.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/brand/update/' + brand.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>'
                        ]);
                    });
                    brandTable.draw();
                },
                error: function () {
                    alert('Đã xảy ra lỗi khi tải thương hiệu.');
                }
            });
        }

        function convertStatus(status) {
            if (status === 'HOAT_DONG') return 'Hoạt Động';
            if (status === 'NGUNG_HOAT_DONG') return 'Ngừng Hoạt Động';
            return 'Không xác định';
        }

        $('input[name="status_type"]').change(loadTableBrand);
        $('#btn_search').click(loadTableBrand);

        loadTableBrand();
    });

</script>
<c:if test="${not empty successMessage}">
    <script>
        $(document).ready(function () {
            toastr.success("${successMessage}");
        });
    </script>
</c:if>


</body>
</html>
