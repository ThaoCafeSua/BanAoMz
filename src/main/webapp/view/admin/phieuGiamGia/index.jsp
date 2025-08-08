<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>

        <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

        <div class="container">
            <div class="card mt-4" style="border: 1px solid #006d7f; background-color: white;">
                <div class="card-body">

                    <!-- Tiêu đề và nút Thêm -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 style="color: #001f3d;">Quản Lý Phiếu Giảm Giá</h4>
                        <a href="/admin/phieu-giam-gia/create" class="btn btn-teal">
                            <i class="fa-solid fa-plus"></i> Thêm Phiếu Giảm Giá
                        </a>
                    </div>

                    <!-- Bộ lọc tìm kiếm -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" id="input_search_voucher" class="form-control" name="key"
                                    placeholder="Nhập tên phiếu giảm giá...">
                                <button class="btn" id="btn_search_voucher"
                                    style="background-color: #001f3d; color: white; border: 1px solid #006d7f;">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bảng phiếu giảm giá -->
                    <table class="table table-hover" id="voucherTable">
                        <thead style="background-color: #001f3d; color: white;">
                            <tr class="text-center">
                                <th>#</th>
                                <th>Mã Phiếu</th>
                                <th>Tên Phiếu</th>
                                <th>Giá Trị Giảm</th>
                                <th>Điều Kiện Áp Dụng</th>
                                <th>Ngày Bắt Đầu</th>
                                <th>Ngày Kết Thúc</th>
                                <th>Số Lượng</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Dữ liệu sẽ được chèn vào đây bởi JavaScript -->
                        </tbody>
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

            .btn {
                border: 1px solid #cccccc !important;
                border-radius: 4px !important;
            }

            .btn:hover {
                background-color: #004080 !important;
                color: white !important;
            }

            .table th,
            .table td {
                border: 1px solid #dcdcdc !important;
                vertical-align: middle;
            }

            .table-striped tbody tr:nth-of-type(odd) {
                background-color: #f9f9f9;
            }

            thead {
                border: 1px solid #dcdcdc !important;
            }
        </style>

        <script>
            $(document).ready(function () {
                let voucherTable = $('#voucherTable').DataTable({
                    paging: true,
                    searching: false,
                    ordering: false,
                    info: false,
                    lengthChange: false,
                    pageLength: 10,
                    columnDefs: [
                        { "className": "text-center", "targets": "_all" }
                    ],
                });

                function loadTableVoucher() {
                    const search = $('#input_search_voucher').val();

                    $.ajax({
                        url: '/admin/phieu-giam-gia/list',
                        method: 'GET',
                        dataType: 'json',
                        data: { search: search },
                        success: function (data) {
                            voucherTable.clear();
                            $.each(data.data, function (index, item) {
                                voucherTable.row.add([
                                    index + 1,
                                    item.maPhieuGiamGia,
                                    item.tenPhieuGiamGia,
                                    item.giaTriGiam,
                                    item.dieuKienApDung,
                                    item.ngayBatDau,
                                    item.ngayKetThuc,
                                    item.soLuong,
                                    '<a href="/admin/phieu-giam-gia/detail/' + item.id + '" class="btn btn-sm btn-info me-1"><i class="fa-solid fa-info"></i></a>' +
                                    '<a href="/admin/phieu-giam-gia/update/' + item.id + '" class="btn btn-sm btn-success me-1"><i class="fa-solid fa-pen"></i></a>'
                                ]);
                            });
                            voucherTable.draw();
                        },
                        error: function () {
                            alert('Lỗi khi lấy dữ liệu phiếu giảm giá');
                        }
                    });
                }

                $('#btn_search_voucher').click(loadTableVoucher);
                loadTableVoucher();
            });
        </script>