<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <h3>Quản lý nhân viên</h3>
    <div class="card">

        <div class="card-body">
            <h5 class="card-title">Tìm kiếm</h5>
            <div class="row">
                <div class="col-md-6">
                    <input type="text" id="inputCustomer" class="form-control"
                           placeholder="Tìm kiếm tên hoặc sdt nhân viên">
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
                <a href="/admin/staff/create" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Thêm nhân viên</a>
            </div>
            <table class="table" id="staffTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên nhân viên</th>
                    <th>Ngày sinh</th>
                    <th>Giới Tính</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th>Địa chỉ</th>
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
        let staffTable = $('#staffTable').DataTable({
            "paging": true,        // Bật phân trang
            "searching": false,     // Bật tìm kiếm
            "ordering": false,      // Bật sắp xếp
            "info": false,          // Bật thông tin tổng quan
            "lengthChange": false,  // Cho phép thay đổi số lượng bản ghi hiển thị
            "pageLength": 5,       // Số lượng bản ghi trên mỗi trang
            "columnDefs": [
                {"className": "width-table", "targets": "_all"}
            ],
        });

        function loadTableStaff() {
            const search = $('#inputCustomer').val();
            $.ajax({
                url: '/admin/staff/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    staffTable.clear();
                    $.each(data.data, function (index, staff) {
                        staffTable.row.add([
                            index + 1,
                            staff.tenNhanVien,
                            staff.ngaySinh,
                            staff.gioiTinh == 'Male'? 'Nam': 'Nữ',
                            staff.sdt,
                            staff.email,
                            staff.diaChi,
                            '<a  href="/admin/staff/detail/' + staff.id + '"  class="btn btn-warning btn-sm mr-2"><i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/staff/update/' + staff.id + '" class="btn btn-success btn-sm mr-2"><i class="fa-solid fa-pen"></i></a>' +
                            '<button class="btn btn-danger btn-sm btn-delete-staff" data-staff-id="' + staff.id + '"><i class="fa-solid fa-trash"></i></button>'
                        ]);
                    });
                    staffTable.draw();
                },
                error: function (err) {
                    // toastr.error('Lỗi khi lấy dữ liệu nhân viên', err);
                }
            });
        }

        $(document).on('click', '#searchCustomer', function () {
            loadTableStaff()
        });
        loadTableStaff()

        $(document).on('click', '.btn-delete-staff', function () {
            let staffId = $(this).data('staff-id');
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
                        url: '/admin/staff/delete',
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(staffId),
                        success: function (data) {
                            $('#loading').hide();
                            toastr.success('Xóa nhân viên thành công');
                            loadTableStaff()
                        },
                        error: function (err) {
                            $('#loading').hide();
                            toastr.error('Xóa nhân viên lỗi', err);
                        }
                    });
                }
            });
        });
    })

</script>