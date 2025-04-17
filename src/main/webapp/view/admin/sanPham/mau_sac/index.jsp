<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2 class="mb-4">Quản Lý Màu Sắc</h2>

    <div class="card mb-4" style="border: 1px solid #b85555; background-color: white;">
        <div class="card-body">
            <h5 class="mb-3">
                <i class="fas fa-filter"></i> Tìm kiếm
            </h5>

            <div class="row justify-content-center mb-3">
                <div class="col-md-6">
                    <div class="input-group w-100">
                        <input id="input_search"  class="form-control" name="key" placeholder="Tìm kiếm tên màu sắc ..." />
                        <button id="btn_search" class="btn btn-red" id="btn_search" style="background-color: #b85555; color: white;">
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
                <h5 class="card-title">Danh sách màu sắc</h5>
                <a href="/admin/color/create" class="btn btn-pink" style="background-color: #b85555; color: white;">
                    <i class="fa-solid fa-plus"></i> Thêm màu sắc
                </a>
            </div>
            <table class="table" id="colorTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên màu sắc</th>
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
</style>

<script>
    $(document).ready(function () {
        let colorTable = $('#colorTable').DataTable({
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

        function loadTableColor() {
            const search = $('#input_search').val();
            $.ajax({
                url: '/admin/color/list',  // Đổi URL để lấy dữ liệu màu sắc
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    colorTable.clear();
                    $.each(data.data, function (index, color) {
                        colorTable.row.add([
                            index + 1,
                            color.tenMauSac,
                            '<a href="/admin/color/detail/' + color.id + '" class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/color/update/' + color.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>' +
                            '<button class="btn btn-danger btn-sm btn-delete-color" data-color-id="' + color.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    colorTable.draw();
                },
                error: function (err) {
                    // toastr.error('Lỗi khi lấy dữ liệu màu sắc', err);  // Thông báo lỗi lấy màu sắc
                }
            });
        }

        $(document).on('click', '#btn_search', function () {
            loadTableColor();  // Gọi hàm loadTableColor
        });
        loadTableColor();  // Gọi lần đầu để load màu sắc

        $(document).on('click', '.btn-delete-color', function () {
            let colorId = $(this).data('color-id');
            Swal.fire({
                title: 'Bạn có chắc muốn xóa màu sắc này?',
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
                        url: '/admin/color/delete',  // Đổi URL để xóa màu sắc
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(colorId),
                        success: function (data) {
                            $('#loading').hide();
                            toastr.success('Xóa màu sắc thành công');
                            loadTableColor();  // Tải lại danh sách màu sắc
                        },
                        error: function (err) {
                            $('#loading').hide();
                            toastr.error('Xóa màu sắc lỗi', err);
                        }
                    });
                }
            });
        });
    });
</script>
