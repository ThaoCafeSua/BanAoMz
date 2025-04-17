<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2 class="mb-4">Quản Lý Danh Mục</h2>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mb-4" style="border: 1px solid #b85555; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Tìm kiếm
            </h5>

            <div class="row justify-content-center mb-3">
                <div class="col-md-6">
                    <div class="input-group w-100">
                        <input id="input_search" class="form-control" name="key" placeholder="Tìm kiếm tên danh mục ..." />
                        <button id="btn_search" class="btn btn-red" type="submit" style="background-color: #b85555; color: white;">
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
                <a href="/admin/category/create" class="btn btn-pink" style="background-color: #b85555; color: white;"><i class="fa-solid fa-plus" ></i> Thêm danh mục</a>
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
        border: 1px solid #b85555;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 8px;
    }

    .btn-teal {
        background-color: #008080;
        border-radius: 20px;
        width: 50px;
        height: 30px;
        font-size: 12px;
    }

    .btn-purple {
        background-color: #800080;
        border-radius: 20px;
        width: 50px;
        height: 30px;
        font-size: 12px;
    }

    .btn-orange {
        background-color: #FFA500;
        border-radius: 20px;
        width: 50px;
        height: 30px;
        font-size: 12px;
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

    #inputCustomer {
        border-radius: 20px;
        padding: 10px;
    }

    #searchCustomer {
        border-radius: 20px;
        padding: 10px 20px;
    }
</style>
<script>
    $(document).ready(function () {
        let categoryTable = $('#customerTable').DataTable({
            "paging": true,        // Bật phân trang
            "searching": false,    // Bật tìm kiếm
            "ordering": false,     // Bật sắp xếp
            "info": false,         // Bật thông tin tổng quan
            "lengthChange": false, // Cho phép thay đổi số lượng bản ghi hiển thị
            "pageLength": 5,       // Số lượng bản ghi trên mỗi trang
            "columnDefs": [
                {"className": "text-center", "targets": "_all"}
            ],
            "language": {
                "emptyTable": "Không có dữ liệu" // Thay đổi thông báo khi không có dữ liệu
            }
        });

        function loadTableCategory() {
            const search = $('#input_search').val();
            $.ajax({
                url: '/admin/category/list',  // Đổi URL để lấy dữ liệu danh mục
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    categoryTable.clear();
                    $.each(data.data, function (index, category) {
                        categoryTable.row.add([
                            index + 1,
                            category.tenDanhMuc,
                            '<a href="/admin/category/detail/' + category.id + '" class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/category/update/' + category.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>' +
                            '<button class="btn btn-danger btn-sm btn-delete-category" data-category-id="' + category.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    categoryTable.draw();
                },
                error: function (err) {
                    // toastr.error('Lỗi khi lấy dữ liệu danh mục', err);  // Thông báo lỗi lấy danh mục
                }
            });
        }

        $(document).on('click', '#btn_search', function () {
            loadTableCategory();  // Gọi hàm loadTableCategory
        });
        loadTableCategory();  // Gọi lần đầu để load danh mục

        $(document).on('click', '.btn-delete-category', function () {
            let categoryId = $(this).data('category-id');
            Swal.fire({
                title: 'Bạn có chắc muốn xóa danh mục này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    $('#loading').show();
                    $.ajax({
                        url: '/admin/category/delete',  // Đổi URL để xóa danh mục
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(categoryId),
                        success: function (data) {
                            $('#loading').hide();
                            toastr.success('Xóa danh mục thành công');
                            loadTableCategory();  // Tải lại danh sách danh mục
                        },
                        error: function (err) {
                            $('#loading').hide();
                            toastr.error('Xóa danh mục lỗi', err);
                        }
                    });
                }
            });
        });
    });
</script>
