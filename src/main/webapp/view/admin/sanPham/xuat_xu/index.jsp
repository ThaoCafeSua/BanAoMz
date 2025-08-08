<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Xuất Xứ</title>

    <!-- Toastr & jQuery -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

    <style>
        .custom-border {
            border: 1px solid #001f3d; padding: 20px; margin-bottom: 20px; border-radius: 8px;
        }
        .btn-teal {
            background-color: #001f3d; border-radius: 20px; color: white;
        }
        .btn-teal:hover {
            background-color: #004080; color: white;
        }
        #input_search {
            border-radius: 20px; padding: 10px; border: 1px solid #001f3d;
        }
        #btn_search {
            border-radius: 20px; padding: 10px 20px; background-color: #001f3d; color: white;
        }
        #btn_search:hover {
            background-color: #004080; color: white;
        }
        .table th, .table td {
            text-align: center; vertical-align: middle;
        }
        .table {
            margin-top: 20px; border-radius: 8px;
        }
        .card-title {
            font-size: 20px; font-weight: bold;
        }
        .btn-info {
            background-color: #001f3d; border-color: #001f3d; margin-right: 5px;
        }
        .btn-info:hover {
            background-color: #004080; border-color: #004080;
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
    <h2 class="mb-4">Quản Lý Xuất Xứ</h2>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mb-4" style="border: 1px solid #006d7f; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3"><i class="fas fa-filter"></i> Tìm kiếm</h5>

            <div class="row justify-content-center mb-3">
                <div class="col-md-8">
                    <div class="input-group mb-3">
                        <input id="input_search" class="form-control" placeholder="Nhập tên xuất xứ..." />
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
                <h5 class="card-title">Danh sách xuất xứ</h5>
                <a href="/admin/origin/create" class="btn btn-teal"><i class="fa-solid fa-plus"></i> Thêm Xuất Xứ</a>
            </div>
            <table class="table" id="originTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên Xuất Xứ</th>
                    <th>Trạng Thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        let originTable = $('#originTable').DataTable({
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

        function loadTableOrigin() {
            const search = $('#input_search').val();
            const status = $('input[name="status_type"]:checked').val();

            $.ajax({
                url: '/admin/origin/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search, status: status},
                success: function (response) {
                    originTable.clear();
                    if (response.data.length === 0) {
                        toastr.warning('Không tìm thấy xuất xứ nào phù hợp.', 'Thông báo');
                    }
                    $.each(response.data, function (index, origin) {
                        originTable.row.add([
                            index + 1,
                            origin.tenXuatXu,
                            convertStatus(origin.trangThai),
                            '<a href="/admin/origin/detail/' + origin.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/origin/update/' + origin.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>'
                        ]);
                    });
                    originTable.draw();
                },
                error: function () {
                    toastr.error('Đã xảy ra lỗi khi tải xuất xứ.', 'Lỗi hệ thống');
                }
            });
        }

        function convertStatus(status) {
            if (status === 'HOAT_DONG') return 'Hoạt Động';
            if (status === 'NGUNG_HOAT_DONG') return 'Ngừng Hoạt Động';
            return 'Không xác định';
        }

        $('#btn_search').click(loadTableOrigin);
        $('input[name="status_type"]').change(loadTableOrigin);

        loadTableOrigin();
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
