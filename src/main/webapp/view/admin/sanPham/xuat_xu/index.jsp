<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2 class="mb-4">Quản Lý Xuất Xứ</h2>

    <!-- Form tìm kiếm xuất xứ -->
    <div class="card mb-4" style="border: 1px solid #b85555; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Tìm kiếm
            </h5>
            <div class="row justify-content-center mb-3">
                <div class="col-md-6">
                    <div class="input-group w-100">
                        <input id="inputOrigin" class="form-control" name="key" placeholder="Tìm kiếm tên xuất xứ ..." />
                        <button id="searchOrigin" class="btn btn-red" type="button" style="background-color: #b85555; color: white;">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Danh sách xuất xứ -->
    <div class="card mt-4 custom-border">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Danh sách xuất xứ</h5>
                <a href="/admin/origin/create" class="btn btn-pink" style="background-color: #b85555; color: white;">
                    <i class="fa-solid fa-plus"></i> Thêm xuất xứ
                </a>
            </div>
            <table class="table" id="originTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên xuất xứ</th>
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
        border: 1px solid #b85555;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 8px;
    }

    .btn-red {
        background-color: #b85555;
        color: white;
    }

    .table th, .table td {
        text-align: center;
        vertical-align: middle;
    }

    .card-title {
        font-size: 20px;
        font-weight: bold;
    }
</style>

<!-- Script xử lý các chức năng -->
<script>
    $(document).ready(function () {
        // Khởi tạo DataTable
        let originTable = $('#originTable').DataTable({
            "paging": true,
            "searching": false,
            "ordering": false,
            "info": false,
            "lengthChange": false,
            "pageLength": 5,
            "columnDefs": [
                {"className": "text-center", "targets": "_all"}
            ],
            "language": {
                "emptyTable": "Không có dữ liệu"
            }
        });

        // Hàm load dữ liệu xuất xứ
        function loadTableOrigin() {
            const search = $('#inputOrigin').val();
            $.ajax({
                url: '/admin/origin/list', // Chỉnh URL theo xuất xứ
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    originTable.clear();
                    $.each(data.data, function (index, origin) {
                        originTable.row.add([
                            index + 1,
                            origin.tenXuatXu,
                            '<a href="/admin/origin/detail/' + origin.id + '" class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/origin/update/' + origin.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>' +
                            '<button class="btn btn-danger btn-sm btn-delete-origin" data-origin-id="' + origin.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    originTable.draw();
                },
                error: function () {
                    toastr.error('Lỗi khi lấy dữ liệu xuất xứ');
                }
            });
        }

        // Xử lý tìm kiếm
        $('#searchOrigin').on('click', function () {
            loadTableOrigin();
        });

        // Xóa xuất xứ
        $(document).on('click', '.btn-delete-origin', function () {
            let originId = $(this).data('origin-id');
            Swal.fire({
                title: 'Bạn có chắc muốn xóa xuất xứ này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/admin/origin/delete', // Chỉnh URL cho xóa xuất xứ
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(originId),
                        success: function () {
                            toastr.success('Xóa xuất xứ thành công');
                            loadTableOrigin();
                        },
                        error: function () {
                            toastr.error('Xóa xuất xứ lỗi');
                        }
                    });
                }
            });
        });

        // Load dữ liệu lần đầu
        loadTableOrigin();
    });
</script>
