<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="mt-4">
    <h2 class="mb-4">Quản Lý Thương Hiệu</h2>

    <!-- Form tìm kiếm thương hiệu -->
    <div class="card mb-4" style="border: 1px solid #b85555; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Tìm kiếm
            </h5>
            <div class="row justify-content-center mb-3">
                <div class="col-md-6">
                    <div class="input-group w-100">
                        <input id="input_search" class="form-control" name="key" placeholder="Tìm kiếm tên thương hiệu ..." />
                        <button id="btn_search" class="btn btn-red" type="button" style="background-color: #b85555; color: white;">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- Danh sách thương hiệu -->
    <div class="card mt-4 custom-border">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Danh sách thương hiệu</h5>
                <a href="/admin/brand/create" class="btn btn-pink" style="background-color: #b85555; color: white;">
                    <i class="fa-solid fa-plus"></i> Thêm thương hiệu
                </a>
            </div>
            <table class="table" id="brandTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên thương hiệu</th>
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
        let brandTable = $('#brandTable').DataTable({
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

        // Hàm load dữ liệu thương hiệu
        function loadTableBrand() {
            const search = $('#input_search').val();
            $.ajax({
                url: '/admin/brand/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    brandTable.clear();
                    $.each(data.data, function (index, brand) {
                        brandTable.row.add([
                            index + 1,
                            brand.tenThuongHieu,
                            '<a href="/admin/brand/detail/' + brand.id + '" class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/brand/update/' + brand.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>' +
                            '<button class="btn btn-danger btn-sm btn-delete-brand" data-brand-id="' + brand.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    brandTable.draw();
                },
                error: function () {
                    toastr.error('Lỗi khi lấy dữ liệu thương hiệu');
                }
            });
        }

        // Xử lý tìm kiếm
        $('#btn_search').on('click', function () {
            loadTableBrand();
        });

        // Xóa thương hiệu
        $(document).on('click', '.btn-delete-brand', function () {
            let brandId = $(this).data('brand-id');
            Swal.fire({
                title: 'Bạn có chắc muốn xóa thương hiệu này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/admin/brand/delete',
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(brandId),
                        success: function () {
                            toastr.success('Xóa thương hiệu thành công');
                            loadTableBrand();
                        },
                        error: function () {
                            toastr.error('Xóa thương hiệu lỗi');
                        }
                    });
                }
            });
        });

        // Load dữ liệu lần đầu
        loadTableBrand();
    });
</script>
