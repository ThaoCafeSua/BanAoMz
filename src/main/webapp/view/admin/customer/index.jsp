<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <h3>Quản lý khách hàng</h3>
    <div class="card">

        <div class="card-body">
            <h5 class="card-title">Tìm kiếm</h5>
            <div class="row">
                <div class="col-md-6">
                    <input type="text" id="inputCustomer" class="form-control"
                           placeholder="Tìm kiếm tên hoặc sdt khách hàng">
                </div>
                <div class="col-md-2">
                    <button class="btn btn-primary" id="searchCustomer">Tìm kiếm</button>
                </div>
            </div>

        </div>
    </div>
    <div class="card mt-4">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Danh sách</h5>
                <a href="/admin/customer/create" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Thêm khách
                    hàng</a>
            </div>
            <table class="table" id="customerTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên khách hàng</th>
                    <th>Ngày sinh</th>
                    <th>Giới Tính</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th>Hành động</th>
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
        let customerTable = $('#customerTable').DataTable({
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

        function loadTableCustomer() {
            const search = $('#inputCustomer').val();
            $.ajax({
                url: '/admin/customer/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    customerTable.clear();
                    $.each(data.data, function (index, customer) {
                        customerTable.row.add([
                            index + 1,
                            customer.hoVaTen,
                            customer.ngaySinh,
                            customer.gioiTinh == 'Male'? 'Nam': 'Nữ',
                            customer.soDienThoai,
                            customer.email,
                            '<a  href="/admin/customer/detail/' + customer.id + '"  class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/customer/update/' + customer.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>' +
                            '<button class="btn btn-danger btn-sm btn-delete-customer" data-customer-id="' + customer.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    customerTable.draw();
                },
                error: function (err) {
                    // toastr.error('Lỗi khi lấy dữ liệu khách hàng', err);
                }
            });
        }

        $(document).on('click', '#searchCustomer', function () {
            loadTableCustomer()
        });
        loadTableCustomer()

        $(document).on('click', '.btn-delete-customer', function () {
            let customerId = $(this).data('customer-id');
            Swal.fire({
                title: 'Bạn có chắc muốn xóa?',
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
                        url: '/admin/customer/delete',
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(customerId),
                        success: function (data) {
                            $('#loading').hide();
                            toastr.success('Xóa khách hàng thành công');
                            loadTableCustomer()
                        },
                        error: function (err) {
                            $('#loading').hide();
                            toastr.error('Xóa khách hàng lỗi', err);
                        }
                    });
                }
            });
        });
    })

</script>