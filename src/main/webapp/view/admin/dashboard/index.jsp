<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ====== CSS & JS libs ====== -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>
<link href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container mt-4">
    <div class="d-flex align-items-center gap-3 mb-3">
        <i class="fa-solid fa-chart-line fa-xl text-primary"></i>
        <h2 class="mb-0 fw-bold" style="color:#001f3d">Thống kê</h2>
    </div>

    <!-- KPI Cards -->
    <div class="row g-3 mb-3">
        <div class="col-md-3">
            <div class="kpi-card card shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <span class="kpi-title">Doanh thu hôm nay</span>
                        <span class="kpi-icon bg-success-subtle text-success"><i class="fa-solid fa-sack-dollar"></i></span>
                    </div>
                    <div class="kpi-value text-success mt-2" id="moneyDay">0 đ</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="kpi-card card shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <span class="kpi-title">Doanh thu tháng này</span>
                        <span class="kpi-icon bg-primary-subtle text-primary"><i class="fa-solid fa-calendar-days"></i></span>
                    </div>
                    <div class="kpi-value text-primary mt-2" id="moneyMonth">0 đ</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="kpi-card card shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <span class="kpi-title">Doanh thu năm nay</span>
                        <span class="kpi-icon bg-info-subtle text-info"><i class="fa-solid fa-calendar"></i></span>
                    </div>
                    <div class="kpi-value text-info mt-2" id="moneyYear">0 đ</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="kpi-card card shadow-sm">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <span class="kpi-title">Số lượng tồn kho</span>
                        <span class="kpi-icon bg-warning-subtle text-warning"><i class="fa-solid fa-warehouse"></i></span>
                    </div>
                    <div class="kpi-value text-warning mt-2" id="soLuongTon">0</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Doanh thu theo khoảng ngày -->
    <div class="row g-3 mb-3">
        <div class="col-lg-6">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <h5 class="card-title mb-0">Doanh thu theo khoảng ngày</h5>
                        <div class="badge rounded-pill text-bg-warning-subtle border border-warning-subtle text-warning-emphasis px-3">
                            <i class="fa-regular fa-money-bill-1 me-1"></i><span id="doanhThuTheoKhoang">0 đ</span>
                        </div>
                    </div>

                    <div class="row g-2 align-items-end mt-1">
                        <div class="col">
                            <label class="form-label small mb-1">Từ ngày</label>
                            <input type="date" class="form-control" id="dateInputStr">
                        </div>
                        <div class="col">
                            <label class="form-label small mb-1">Đến ngày</label>
                            <input type="date" class="form-control" id="dateInputEnd">
                        </div>
                        <div class="col-auto">
                            <button class="btn btn-primary" id="btn_search"><i class="fa-solid fa-magnifying-glass me-1"></i>Tìm kiếm</button>
                        </div>
                    </div>

                    <div class="small text-muted mt-2">Chọn khoảng ngày rồi bấm <strong>Tìm kiếm</strong>.</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts -->
    <div class="row g-3 mb-3">
        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Biểu đồ doanh thu</h5>
                    <div style="height:320px">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Biểu đồ số lượng bán</h5>
                    <div style="height:320px">
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bảng theo tháng -->
    <div class="card shadow-sm mb-5">
        <div class="card-body">
            <h5 class="card-title mb-3">Thống kê theo tháng</h5>
            <table class="table table-striped align-middle" id="doanhThuTable" style="width:100%">
                <thead class="table-light">
                <tr>
                    <th>Tháng</th>
                    <th>Doanh thu</th>
                    <th>Số lượng bán</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<style>
    :root{
        --brand:#001f3d;
    }
    .kpi-card .kpi-title{ font-size:.9rem; color:#6b7280; }
    .kpi-card .kpi-value{ font-size:1.6rem; font-weight:800; }
    .kpi-card .kpi-icon{
        width:40px; height:40px; display:grid; place-items:center; border-radius:10px;
        font-size:1rem;
    }
    .card-title{ color:var(--brand); font-weight:700; }
</style>

<script>
    // ===== Helpers =====
    function formatCurrency(n){
        if (n === null || n === undefined) return '0 đ';
        const num = Number(n) || 0;
        return num.toLocaleString('vi-VN') + ' đ';
    }
    function toastError(msg){ toastr.error(msg || 'Có lỗi xảy ra'); }
    toastr.options = { positionClass: "toast-bottom-right", timeOut: 2000 };

    // ===== Charts init =====
    const ctxRevenue = document.getElementById('revenueChart').getContext('2d');
    const ctxSales   = document.getElementById('salesChart').getContext('2d');

    // Gradient cho line chart
    function makeGradient(ctx){
        const g = ctx.createLinearGradient(0,0,0,300);
        g.addColorStop(0,'rgba(13,59,102,0.25)');
        g.addColorStop(1,'rgba(13,59,102,0)');
        return g;
    }

    const revenueChart = new Chart(ctxRevenue, {
        type: 'line',
        data: { labels: [], datasets: [{
                label: 'Doanh thu (đ)',
                data: [],
                borderColor:'#0d3b66',
                backgroundColor: makeGradient(ctxRevenue),
                borderWidth:2,
                tension:.25,
                fill:true,
                pointRadius:3,
                pointHoverRadius:4
            }]},
        options: {
            responsive:true, maintainAspectRatio:false,
            plugins:{ legend:{display:false}, tooltip:{ callbacks:{
                        label:(ctx)=> ' ' + formatCurrency(ctx.parsed.y)
                    }}},
            scales:{
                x:{ grid:{display:false} },
                y:{ ticks:{ callback:(v)=> v.toLocaleString('vi-VN') }, grid:{ color:'rgba(0,0,0,.05)'} }
            }
        }
    });

    const salesChart = new Chart(ctxSales, {
        type: 'bar',
        data: { labels: [], datasets: [{
                label: 'Số lượng bán',
                data: [],
                backgroundColor:'rgba(255,159,64,0.35)',
                borderColor:'rgba(255,159,64,1)', borderWidth:1,
                borderRadius:6
            }]},
        options:{
            responsive:true, maintainAspectRatio:false,
            plugins:{ legend:{display:false} },
            scales:{ x:{ grid:{display:false} }, y:{ beginAtZero:true } }
        }
    });

    // ===== Load KPI tổng quan =====
    function loadDoanhThu() {
        $.ajax({
            url:'/admin/doanh-thu', method:'GET'
        }).done(function(res){
            const r = res?.data || {};
            $('#moneyDay').text(formatCurrency(r.day));
            $('#moneyMonth').text(formatCurrency(r.month));
            $('#moneyYear').text(formatCurrency(r.year));
            $('#soLuongTon').text(r.soLuongTon ?? 0);
        }).fail(function(){
            toastError('Không lấy được doanh thu tổng quan');
        });
    }

    // ===== Bảng theo tháng + cập nhật Charts =====
    let doanhThuTable;
    function initTable(){
        doanhThuTable = $('#doanhThuTable').DataTable({
            paging:true, searching:false, ordering:false, info:false, lengthChange:false, pageLength:6,
            language:{ emptyTable:'Chưa có dữ liệu' }
        });
    }

    function loadTableDoanhThu(){
        $.ajax({ url:'/admin/doanh-thu-table', method:'GET' })
            .done(function(resp){
                const data = (resp?.data || []).sort((a,b)=> a.month - b.month);

                doanhThuTable.clear();
                data.forEach(it=>{
                    doanhThuTable.row.add([
                        'Tháng ' + it.month,
                        formatCurrency(it.doanhThu),
                        it.soLuongBan ?? 0
                    ]);
                });
                doanhThuTable.draw();

                const months = data.map(it=> 'Tháng ' + it.month);
                const revenueData = data.map(it=> it.doanhThu || 0);
                const salesData   = data.map(it=> it.soLuongBan || 0);

                revenueChart.data.labels = months;
                revenueChart.data.datasets[0].data = revenueData;
                revenueChart.update();

                salesChart.data.labels = months;
                salesChart.data.datasets[0].data = salesData;
                salesChart.update();
            })
            .fail(function(){ toastError('Không lấy được thống kê theo tháng'); });
    }

    // ===== Doanh thu theo khoảng ngày =====
    function getDoanhThuTheoKhoangNgay(startDate, endDate){
        return $.ajax({
            url:'/admin/doanh-thu-khoang-ngay', method:'GET', data:{ startDate, endDate }
        }).done(function(resp){
            $('#doanhThuTheoKhoang').text(formatCurrency(resp?.data || 0));
        }).fail(function(){
            toastError('Không lấy được doanh thu theo khoảng ngày');
        });
    }

    // ===== Page init =====
    $(function(){
        initTable();
        loadDoanhThu();
        loadTableDoanhThu();

        // Tìm kiếm theo khoảng ngày
        $('#btn_search').on('click', function(){
            const start = $('#dateInputStr').val();
            const end   = $('#dateInputEnd').val();
            if(!start || !end){
                toastr.error('Vui lòng chọn đầy đủ ngày bắt đầu và kết thúc.');
                return;
            }
            getDoanhThuTheoKhoangNgay(start, end);
        });

        // Enter ở input date cũng trigger tìm
        $('#dateInputStr,#dateInputEnd').on('keydown', function(e){
            if(e.key === 'Enter') $('#btn_search').click();
        });
    });
</script>
