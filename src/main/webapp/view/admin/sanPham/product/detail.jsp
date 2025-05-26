<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .card {
        border: 1px solid #006d7f !important;
        background-color: white;
    }
    .card-header {
        background-color: white !important;
        color: black;
        font-weight: bold;
    }
    .table th, .table td {
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

<div class="container">
    <h3>Thông Tin Sản Phẩm</h3>
    <a href="/admin/product" class="btn mb-4"><i class="fa-solid fa-arrow-left"></i></a>
    <!-- Form thêm sản phẩm -->
    <div class="card">
        <div class="card-body row">
            <div class="col-7">
                <div class="mb-3">
                    <label for="tenSanPham" class="form-label required">Tên Sản Phẩm</label>
                    <input type="text" class="form-control" id="tenSanPham" disabled
                           placeholder="Nhập tên sản phẩm">
                </div>
                <div class="mb-3">
                    <label class="form-label required" for="danhMucSelect">Danh Mục</label>
                    <select class="form-control" id="danhMucSelect" name="danhMuc" disabled>
                        <option value="">Chọn danh mục</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="thuongHieuSelect"  class="form-label required">Thương Hiệu</label>
                    <select class="form-control" id="thuongHieuSelect" name="thuongHieu" disabled>
                        <option value="">Chọn thương hiệu</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label required" for="xuatXuSelect">Xuất Xứ</label>
                    <select class="form-control" id="xuatXuSelect" name="xuatXu" disabled>
                        <option value="">Chọn xuất xứ</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label required" >Trạng Thái</label>
                    <div class="col d-flex">
                        <div class="form-check">
                            <input disabled class="form-check-input" id="status_type_on" type="radio" name="status_product"  value="HOAT_DONG" checked>
                            <label class="form-check-label" for="status_type_on">
                                Đang bán
                            </label>
                        </div>
                        <div class="form-check ml-2">
                            <input disabled class="form-check-input" id="status_type_off" type="radio" name="status_product" value="NGUNG_HOAT_DONG">
                            <label class="form-check-label" for="status_type_off">
                                Ngừng bán
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-5">
                <label class="form-label required" >Hình ảnh</label>
                <div class="mt-4">
                    <img id="imagePreview" src="" class="rounded mx-auto d-block" style="display: none; max-width: 100%; height: auto; padding: 20px">
                </div>
            </div>
        </div>
    </div>

    <!-- Danh sách sản phẩm -->
    <div class="card mt-4">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-2">Sản Phẩm Chi Tiết</h5>
            </div>
        </div>

        <div class="card-body">
            <table class="table" id="productTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Màu Sắc</th>
                    <th>Size</th>
                    <th>Số Lượng</th>
                    <th>Giá Bán</th>
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
        let colorData = []
        let massData = []
        let productDetailArr = [];
        let sanPhamId = "${sanPhamId}";

        $('#colorSelect').select2();
        $('#massSelect').select2();

        function getDataDanhMuc() {
            $('#danhMucSelect').empty();
            $('#danhMucSelect').append('<option value="" selected disabled>Chọn danh mục</option>');
            $.ajax({
                url: '/admin/category/list',
                method: 'GET',
                dataType: 'json',
                data: {search: ''},
                success: function (response) {
                    response.data.forEach(function (item) {
                        $('#danhMucSelect').append(
                            $('<option></option>').val(item.id).text(item.tenDanhMuc)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON); // In ra thông báo lỗi
                }
            });
        }
        getDataDanhMuc()

        function getDataThuongHieu() {
            $('#thuongHieuSelect').empty();
            $('#thuongHieuSelect').append('<option value="" selected disabled>Chọn thương hiệu</option>');
            $.ajax({
                url: '/admin/brand/list',
                method: 'GET',
                dataType: 'json',
                data: {search: ''},
                success: function (response) {
                    response.data.forEach(function (item) {
                        $('#thuongHieuSelect').append(
                            $('<option></option>').val(item.id).text(item.tenThuongHieu)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON); // In ra thông báo lỗi
                }
            });
        }
        getDataThuongHieu()

        function getDataXuatXu() {
            $('#xuatXuSelect').empty();
            $('#xuatXuSelect').append('<option value="" selected disabled>Chọn xuất xứ</option>');
            $.ajax({
                url: '/admin/origin/list',
                method: 'GET',
                dataType: 'json',
                data: {search: ''},
                success: function (response) {
                    response.data.forEach(function (item) {
                        $('#xuatXuSelect').append(
                            $('<option></option>').val(item.id).text(item.tenXuatXu)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON); // In ra thông báo lỗi
                }
            });
        }
        getDataXuatXu()

        function getDataMauSac() {
            $('#colorSelect').empty();
            $.ajax({
                url: '/admin/color/list',
                method: 'GET',
                dataType: 'json',
                data: {search: ''},
                success: function (response) {
                    colorData = response.data
                    response.data.forEach(function (item) {
                        $('#colorSelect').append(
                            $('<option></option>').val(item.id).text(item.tenMauSac)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON); // In ra thông báo lỗi
                }
            });
        }
        getDataMauSac()

        function getDataSize() {
            $('#massSelect').empty();
            $.ajax({
                url: '/admin/size/list',
                method: 'GET',
                dataType: 'json',
                data: {search: ''},
                success: function (response) {
                    massData = response.data;
                    response.data.forEach(function (item) {
                        $('#massSelect').append(
                            $('<option></option>').val(item.id).text(item.tenSize)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON);
                }
            });
        }
        getDataSize();

        function getDetailProduct() {
            $.ajax({
                url: '/admin/product/detail',
                method: 'POST',
                contentType: 'application/json',
                data: sanPhamId,
                success: function (response) {
                    let data = response.data;

                    loadDataProdcutDetail(data)
                    productDetailArr = response.data.lstChiTietSanPham.map(item => {
                        return {
                            tenSanPham: data.tenSanPham, // Gán giá trị cho thuộc tính tenSanPham
                            ...item // Sao chép các thuộc tính từ item
                        };
                    });
                    loadTableProductDetail(productDetailArr)

                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON); // In ra thông báo lỗi
                }
            });
        }
        getDetailProduct()



        let productTable = $('#productTable').DataTable({
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

        function loadDataProdcutDetail(data){
            $('#xuatXuSelect').val(data.xuatXu.id); // Gán giá trị ID của xuất xứ
            $('#danhMucSelect').val(data.danhMuc.id); // Gán giá trị ID của danh mục
            $('#thuongHieuSelect').val(data.thuongHieu.id); // Gán giá trị ID của thương hiệu
            $('#tenSanPham').val(data.tenSanPham); // Gán tên sản phẩm
            $("input[name='status_product'][value='" + data.trangThai + "']").prop('checked', true); // Gán trạng thái
            $('#imagePreview').attr('src', data.urlAnh); // Gán URL ảnh
            // let lstMauSac = data.lstChiTietSanPham.map(item => item.mauSac.id); // Lấy danh sách ID màu sắc
            // $('#colorSelect').val(lstMauSac).trigger('change'); // Gán giá trị vào select và kích hoạt sự kiện change (nếu dùng thư viện)
            //
            // let lstKhoiLuong = data.lstChiTietSanPham.map(item => item.khoiLuong.id); // Lấy danh sách ID màu sắc
            // $('#massSelect').val(lstKhoiLuong).trigger('change');
        }

        function loadTableProductDetail(data) {
            let productTable = $('#productTable').DataTable();
            productTable.clear();
            $.each(data, function (index, item) {
                productTable.row.add([
                    index + 1,
                    item.tenSanPham,
                    item.mauSac?.tenMauSac || '',
                    item.size?.tenSize || '',
                    item.soLuong,
                    item.giaBan?.toLocaleString('vi-VN') + ' ₫'
                ]);
            });
            productTable.draw();
        }

    })

</script>