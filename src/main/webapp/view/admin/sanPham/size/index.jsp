<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Toastr CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<!-- Toastr JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container mt-4">
    <h2 class="mb-4">Quản Lý Size</h2>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mb-4" style="border: 1px solid #006d7f; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Tìm kiếm
            </h5>

            <div class="row justify-content-center mb-3">
                <div class="col-md-6">
                    <div class="input-group w-100">
                        <input id="input_search" class="form-control" name="key" placeholder="Tìm kiếm tên size ..." />
                        <button id="btn_search" class="btn btn-teal" type="submit">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="card mt-4 custom-border">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Danh sách size</h5>
                <a href="/admin/size/create" class="btn btn-teal"><i class="fa-solid fa-plus"></i> Thêm size</a>
            </div>
            <table class="table" id="sizeTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên size</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>

<style>
    .custom-border {
        border: 1px solid  #001f3d;
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
<script>
    $(document).ready(function () {
        let sizeTable = $('#sizeTable').DataTable({
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

        function loadTableSize() {
            const search = $('#input_search').val();
            $.ajax({
                url: '/admin/size/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (response) {
                    sizeTable.clear();
                    if (response.data.length === 0) {
                        toastr.warning('Không tìm thấy size nào phù hợp.', 'Thông báo');
                    }
                    $.each(response.data, function (index, size) {
                        sizeTable.row.add([
                            index + 1,
                            size.tenSize,
                            '<a href="/admin/size/detail/' + size.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/size/update/' + size.id + '" class="btn btn-info btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>'
                        ]);
                    });
                    sizeTable.draw();
                },
                error: function (xhr, status, error) {
                    console.error(error);
                    toastr.error('Đã xảy ra lỗi khi tải size.', 'Lỗi hệ thống');
                }
            });
        }

        $('#btn_search').click(function () {
            loadTableSize();
        });

        loadTableSize();
    });
</script>
