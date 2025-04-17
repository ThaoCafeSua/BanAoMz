<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="container mt-4">
    <h2 class="mb-4" style="color: #001f3d;">Thống Kê</h2>

    <!-- Thống kê tổng quan -->
    <div class="row">
        <!-- Tổng doanh thu -->
        <div class="col-md-3">
            <div class="card mb-4">
                <div class="card-body text-center">
                    <h5 class="card-title">Tổng Doanh Thu Hôm Nay</h5>
                    <h4 class="text-success" id="moneyDay"></h4>
                </div>
            </div>
        </div>
        <!-- Tổng doanh thu -->
        <div class="col-md-3">
            <div class="card mb-4">
                <div class="card-body text-center">
                    <h5 class="card-title">Tổng Doanh Thu Tháng Này</h5>
                    <h4 class="text-success" id="moneyMonth"></h4>
                </div>
            </div>
        </div>
        <!-- Tổng doanh thu -->
        <div class="col-md-3">
            <div class="card mb-4">
                <div class="card-body text-center">
                    <h5 class="card-title">Tổng Doanh Thu Năm Nay</h5>
                    <h4 class="text-success" id="moneyYear"></h4>
                </div>
            </div>
        </div>
        <!-- Số lượng tồn kho -->
        <div class="col-md-3">
            <div class="card mb-4">
                <div class="card-body text-center">
                    <h5 class="card-title">Số Lượng Tồn Kho</h5>
                    <h4 class="text-warning" id="soLuongTon"></h4>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Doanh Thu Theo Khoảng Ngày</h5>
                    <h4 class="text-warning" id="doanhThuTheoKhoang">0</h4>
                    <div class="my-2" style="padding-top: 40px">
                        <label class="form-label">Chọn Ngày: </label>
                        <div style="display: flex">
                            <input type="date" class="form-control" id="dateInputStr" name="date">
                            <input type="date" class="form-control ml-2" id="dateInputEnd" name="date">
                            <div class="col-12">
                                <button class="btn btn-primary" type="submit" id="btn_search">Tìm Kiếm</button>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>

    </div>

    <!-- Biểu đồ thống kê -->
    <div class="row">
        <!-- Biểu đồ doanh thu -->
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Biểu Đồ Doanh Thu</h5>
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
        <!-- Biểu đồ số lượng bán -->
        <div class="col-md-6">
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Biểu Đồ Số Lượng Bán</h5>
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
        </div>
    </div>
    <div class="card mb-4">
        <div style="padding: 20px">
            <h5 class="card-title">Thống Kê Theo Tháng</h5>
            <table class="table col-12" id="doanhThuTable" >
                <thead>
                <tr style="width: 100%">
                    <th>Tháng</th>
                    <th>Doanh Thu</th>
                    <th>Số Lượng Bán</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <!-- Thống kê theo thời gian -->
    <div class="row">
        <div class="col-md-12">

        </div>
    </div>
</div>

<!-- Custom Styles -->
<!-- Custom Styles -->
<style>
    /* Đổi màu chữ tiêu đề và nội dung */
    .card-title {
        font-size: 18px;
        font-weight: bold;
        color: #003366; /* Màu chữ xanh than */
    }

    #revenueChart, #salesChart {
        height: 300px;  /* Hoặc chiều cao bạn muốn */
        width: 100%;    /* Đảm bảo biểu đồ chiếm toàn bộ chiều rộng */
    }

    .card-body {
        padding: 20px;
        height: 350px;  /* Đảm bảo chiều cao của phần tử chứa */
        display: flex;  /* Sử dụng flexbox */
        flex-direction: column;  /* Đặt hướng của các phần tử là theo cột */
        justify-content: center;  /* Căn giữa theo chiều dọc */
        align-items: center;  /* Căn giữa theo chiều ngang */
        padding: 10px;  /* Giảm bớt khoảng cách bên trong ô */
    }

    .card-body h4 {
        font-size: 18px;  /* Giảm kích thước font của nội dung */
        color: #003366;  /* Màu chữ xanh than */
    }

    /* Tùy chỉnh bảng */
    .table th, .table td {
        text-align: center;
        vertical-align: middle;
        border: 1px solid #003366;  /* Kẻ bảng bằng màu xanh than */
        color: #003366; /* Màu chữ xanh than trong bảng */
    }

    /* Tạo màu nền cho các hàng khi di chuột qua */
    .table tbody tr:hover {
        background-color: #e0e0e0; /* Màu nền nhạt khi di chuột qua */
    }

    /* Định dạng các button */
    .btn-primary {
        background-color: #003366; /* Màu nền button */
        border-color: #003366; /* Màu viền button */
    }

    .btn-primary:hover {
        background-color: #002244; /* Màu nền khi hover */
        border-color: #002244; /* Màu viền khi hover */
    }

</style>


<!-- Biểu đồ sử dụng Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    $(document).ready(function () {
        // Biểu đồ doanh thu
        const ctxRevenue = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(ctxRevenue, {
            type: 'line', // Loại biểu đồ
            data: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5'],
                datasets: [{
                    label: 'Doanh Thu (VNĐ)',
                    data: [0, 0, 0, 0, 0],  // Chưa có dữ liệu
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2,
                    fill: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Biểu đồ số lượng bán
        const ctxSales = document.getElementById('salesChart').getContext('2d');
        const salesChart = new Chart(ctxSales, {
            type: 'bar', // Loại biểu đồ
            data: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5'],
                datasets: [{
                    label: 'Số Lượng Bán',
                    data: [0, 0, 0, 0, 0],  // Chưa có dữ liệu
                    backgroundColor: 'rgba(255, 159, 64, 0.2)',
                    borderColor: 'rgba(255, 159, 64, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Dữ liệu thống kê
        $('#totalRevenue').text('0 VNĐ');
        $('#totalSales').text('0');
        $('#bestSeller').text('Chưa có dữ liệu');
        $('#stockRemaining').text('0');

        loadDoanhThu()
        function loadDoanhThu() {
            $.ajax({
                url: '/admin/doanh-thu',
                method: 'GET',
                success: function (data) {
                    let result = data.data
                    $('#moneyDay').text(formatCurrency(result.day));
                    $('#moneyMonth').text(formatCurrency(result.month));
                    $('#moneyYear').text(formatCurrency(result.year));
                    $('#soLuongTon').text(result.soLuongTon);
                },
                error: function (err) {

                }
            });
        }


        let doanhThuTable = $('#doanhThuTable').DataTable({
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
        loadTableDoanhThu()
        function loadTableDoanhThu() {
            $.ajax({
                url: '/admin/doanh-thu-table',
                method: 'GET',
                success: function (response) {
                    let data = response.data.sort((a, b) => a.month - b.month);

                    doanhThuTable.clear();
                    $.each(response.data, function (index, item) {
                        doanhThuTable.row.add([
                            item.month,
                            formatCurrency(item.doanhThu),
                            item.soLuongBan
                        ]);
                    });
                    doanhThuTable.draw();


                    // Dữ liệu trả về từ API
                    const months = data.map(item => 'Tháng ' + item.month);
                    const revenueData = data.map(item => item.doanhThu);
                    const salesData = data.map(item => item.soLuongBan);

                    // Cập nhật biểu đồ doanh thu
                    revenueChart.data.labels = months;
                    revenueChart.data.datasets[0].data = revenueData;
                    revenueChart.update();

                    // Cập nhật biểu đồ số lượng bán
                    salesChart.data.labels = months;
                    salesChart.data.datasets[0].data = salesData;
                    salesChart.update();
                },
                error: function (err) {
                    // toastr.error('Lỗi khi lấy dữ liệu nhân viên', err);
                }
            });
        }
        function getDoanhThuTheoKhoangNgay(startDate, endDate) {
            $.ajax({
                url: '/admin/doanh-thu-khoang-ngay',
                method: 'GET',
                data: {
                    startDate: startDate,
                    endDate: endDate
                },
                success: function(response) {
                    // Hiển thị kết quả doanh thu
                    $('#doanhThuTheoKhoang').text(formatCurrency(response.data));
                },
                error: function(xhr, status, error) {
                    console.error('Có lỗi xảy ra: ' + error);
                }
            });
        }

        $('#btn_search').click(function() {
            // Lấy giá trị ngày bắt đầu và ngày kết thúc từ input
            const startDate = $('#dateInputStr').val();
            const endDate = $('#dateInputEnd').val();

            // Kiểm tra xem người dùng có chọn đầy đủ ngày hay không
            if (!startDate || !endDate) {
                toastr.error("Vui lòng chọn đầy đủ ngày bắt đầu và kết thúc.");
                return;
            }
            // Gọi hàm AJAX để lấy doanh thu
            getDoanhThuTheoKhoangNgay(startDate, endDate);
        });
    });
</script>
