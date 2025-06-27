<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<div class="container">
    <div class="card mt-4" style="border: 1px solid #006d7f; background-color: white;">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 style="color: #001f3d;">Quản Lý Nhân Viên</h4>
                <a href="/admin/employee/create" class="btn btn-teal">
                    <i class="fa-solid fa-plus"></i> Thêm Nhân Viên
                </a>
            </div>

            <!-- Tìm kiếm -->
            <div class="row mb-3 justify-content-center">
                <div class="col-md-6">
                    <div class="input-group">
                        <input type="text" id="inputEmployee" class="form-control" placeholder="Nhập tên hoặc SĐT nhân viên...">
                        <button class="btn" id="searchEmployee"
                                style="background-color: #001f3d; color: white; border: 1px solid #006d7f;">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>
            </div>

            <!-- Bảng nhân viên -->
            <table class="table table-hover" id="employeeTable">
                <thead style="background-color: #001f3d; color: white;">
                <tr class="text-center">
                    <th>STT</th>
                    <th>Chức vụ</th>
                    <th>Tên Nhân Viên</th>
                    <th>SĐT</th>
                    <th>Địa Chỉ</th>
                    <th>Email</th>
                    <th>Ngày Sinh</th>
                    <th>Giới Tính</th>
<%--                    <th>Mật khẩu</th>--%>
<%--                    <th>Ngày Tạo</th>--%>
                    <th>Ngày sửa</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<style>
    .btn-teal {
        background-color: #001f3d;
        border-radius: 20px;
        color: white;
    }

    .btn-teal:hover {
        background-color: #004080;
        color: white;
    }

    .table th, .table td {
        border: 1px solid #dcdcdc !important;
        vertical-align: middle;
    }
</style>

<script>
    $(document).ready(function () {
        const employeeTable = $('#employeeTable').DataTable({
            paging: true,
            searching: false,
            ordering: false,
            info: false,
            lengthChange: false,
            pageLength: 10,
            columnDefs: [
                {"className": "text-center", "targets": "_all"}
            ]
        });

        function loadTableEmployee() {
            const search = $('#inputEmployee').val();
            $.ajax({
                url: '/admin/employee/list',
                method: 'GET',
                dataType: 'json',
                data: {search: search},
                success: function (data) {
                    employeeTable.clear();
                    $.each(data.data, function (index, emp) {
                        employeeTable.row.add([
                            index + 1,
                            emp.chucVuTen ?? '',
                            emp.tenNhanVien,
                            emp.soDienThoai,
                            emp.diaChi,
                            emp.email,
                            emp.ngaySinh,
                            emp.gioiTinh == 'Male' ? 'Nam' : 'Nữ',
                            //emp.matKhau,
                            // emp.ngayTao,
                            emp.ngaySua,
                            '<a href="/admin/employee/detail/' + emp.id + '" class="btn btn-info btn-sm me-1">' +
                            '<i class="fa-solid fa-info"></i></a>' +
                            '<a href="/admin/employee/update/' + emp.id + '" class="btn btn-success btn-sm">' +
                            '<i class="fa-solid fa-pen"></i></a>'
                        ]);
                    });
                    employeeTable.draw();
                },
                error: function () {
                    toastr.error('Lỗi khi tải danh sách nhân viên');
                }
            });
        }

        $('#searchEmployee').click(function () {
            loadTableEmployee();
        });

        loadTableEmployee(); // Load khi mở trang
    });
</script>
