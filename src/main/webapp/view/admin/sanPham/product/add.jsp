<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div>
    <h3>Thêm Sản Phẩm</h3>
    <a href="/admin/product" class="btn mb-4"><i class="fa-solid fa-arrow-left"></i></a>
    <!-- Form thêm sản phẩm -->
    <div class="card" style="border: 2px solid #b85555; background-color: white;">
        <div class="card-body row">
            <div class="col-7">
                <div class="mb-3">
                    <label for="tenSanPham" class="form-label required">Tên Sản Phẩm</label>
                    <input type="text" class="form-control" id="tenSanPham"
                           placeholder="Nhập tên sản phẩm">
                </div>
                <div class="mb-3">
                    <label class="form-label required" for="danhMucSelect">Danh Mục</label>
                    <select class="form-control" id="danhMucSelect" name="danhMuc">
                        <option value="">Chọn danh mục</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="thuongHieuSelect"  class="form-label required">Thương Hiệu</label>
                    <select class="form-control" id="thuongHieuSelect" name="thuongHieu">
                        <option value="">Chọn thương hiệu</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label required" for="xuatXuSelect">Xuất Xứ</label>
                    <select class="form-control" id="xuatXuSelect" name="xuatXu">
                        <option value="">Chọn xuất xứ</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label required" >Trạng Thái</label>
                    <div class="col d-flex">
                        <div class="form-check">
                            <input class="form-check-input" id="status_type_on" type="radio" name="status_product"  value="HOAT_DONG" checked>
                            <label class="form-check-label" for="status_type_on">
                                Đang bán
                            </label>
                        </div>
                        <div class="form-check ml-2">
                            <input class="form-check-input" id="status_type_off" type="radio" name="status_product" value="NGUNG_HOAT_DONG">
                            <label class="form-check-label" for="status_type_off">
                                Ngừng bán
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-5">
                <label class="form-label required" >Hình ảnh</label>
                <input type="file" id="imageInput" class="form-control">
                <div class="mt-4">
                    <img id="imagePreview" src="" class="rounded mx-auto d-block" style="display: none; max-width: 100%; height: auto; padding: 20px">
                </div>
            </div>
        </div>
    </div>


    <!-- Form thêm sản phẩm chi tiết -->
    <div class="card mt-4" style="border: 2px solid #b85555; background-color: white;">
        <div class="card-body">
            <div class="row">
                <div class="col-6">
                    <label for="colorSelect" class="form-label required">Màu Sắc</label>
                    <select class="form-control" id="colorSelect" name="colorSelect" multiple="multiple" data-placeholder="Chọn màu sắc">
                    </select>
                </div>
                <div class="col-6">
                    <label for="massSelect" class="form-label required">Khối Lượng</label>
                    <select class="form-control" id="massSelect" name="massSelect" multiple="multiple" data-placeholder="Chọn khối lượng">
                    </select>
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-end align-items-center mb-2 mr-4">
            <button type="button" class="btn btn-primary ml-4 btn-gen-product-detail">
                <i class="fa-solid fa-plus"></i> Thêm chi tiết sản phẩm
            </button>
        </div>
    </div>

    <!-- Danh sách sản phẩm -->
    <div class="card mt-4" style="border: 2px solid #b85555; background-color: white;">
        <div class="card-header bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-2">Sản Phẩm Chi Tiết</h5>
                <button type="button" class="btn btn-primary ml-4 btn-create-product">
                    <i class="fa-solid fa-plus"></i> Hoàn Tất
                </button>
            </div>

        </div>

        <div class="card-body bg-white">
            <table class="table" id="productTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Màu Sắc</th>
                    <th>Khối Lượng</th>
                    <th>Số Lượng</th>
                    <th>Giá Bán</th>
                    <th>Hành Động</th>
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

        function getDataKhoiLuong() {
            $('#massSelect').empty();
            $.ajax({
                url: '/admin/weight/list',
                method: 'GET',
                dataType: 'json',
                data: {search: ''},
                success: function (response) {
                    massData = response.data
                    response.data.forEach(function (item) {
                        $('#massSelect').append(
                            $('<option></option>').val(item.id).text(item.tenKhoiLuong)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON); // In ra thông báo lỗi
                }
            });
        }
        getDataKhoiLuong()

        function createProduct() {
            let xuatXu = $('#xuatXuSelect').val()
            let danhMuc = $('#danhMucSelect').val()
            let thuongHieu = $('#thuongHieuSelect').val()
            let tenSanPham = $('#tenSanPham').val()
            let trangThai = $("input[name='status_product']:checked").val();
            let urlAnh = $('#imagePreview').attr('src');
            if (!tenSanPham) {
                toastr.error('Tên sản phẩm không được để trống');
                return;
            }
            if (!danhMuc) {
                toastr.error('Danh mục không được để trống');
                return;
            }
            if (!thuongHieu) {
                toastr.error('Thương hiệu không được để trống');
                return;
            }
            if (!xuatXu) {
                toastr.error('Xuất xứ không được để trống');
                return;
            }
            if (!trangThai) {
                toastr.error('Trạng thái sản phẩm không được để trống');
                return;
            }
            if (!urlAnh) {
                toastr.error('Ảnh sản phẩm không được để trống');
                return;
            }
            if (productDetailArr.length == 0){
                toastr.error('Chưa có chi tiết sản phẩm nào');
                return
            }
            let lstChiTiet = productDetailArr.map(item =>{
                return {
                    khoiLuongId: item.mass.id,
                    mauSacId: item.color.id,
                    soLuong: item.quantity,
                    giaBan: item.price
                }
            })
            Swal.fire({
                title: 'Xác nhận hoàn tất thêm sản phẩm ?',
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
                        url: '/admin/product/create',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            tenSanPham: tenSanPham,
                            danhMuc: danhMuc,
                            thuongHieu: thuongHieu,
                            xuatXu: xuatXu,
                            trangThai: trangThai,
                            urlAnh: urlAnh,
                            lstChiTietSanPham: lstChiTiet
                        }),
                        success: function (response) {
                            toastr.success('Thêm sản phẩm thành công');
                            // Chuyển hướng sau khi hiển thị thông báo thành công
                            setTimeout(() => {
                                $('#loading').hide();
                                window.location.href = '/admin/product';
                            }, 500);
                        },
                        error: function (err) {
                            setTimeout(() => {
                                $('#loading').hide();
                            }, 500);
                        }
                    });

                }
            });

        }
        $(document).on('click', '.btn-create-product', function () {
            createProduct()
        });


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

        function loadTableProductDetail(data) {
            data.sort((a, b) => a.color.id - b.color.id);
            productTable.clear();
            $.each(data, function (index, item) {
                productTable.row.add([
                    index+1,
                    item.product,
                    item.color.tenMauSac,
                    item.mass.tenKhoiLuong,
                    '<input class="form-control quantity-input" type="number" min="1" value="' + item.quantity + '" data-index="' + index + '" />',
                    '<input class="form-control price-input" type="number" min="1" value="' + item.price + '" data-index="' + index + '" />',
                    '<button class="btn btn-danger deleteProduct" data-index="' + index + '"><i class="fa-solid fa-trash"></i></button>'
                ]);
            });
            productTable.draw();
        }

        $('#tenSanPham').change(function() {
            genDataProductDetail()
        })
        // $('#colorSelect').change(function() {
        //     genDataProductDetail()
        // })
        // $('#massSelect').change(function() {
        //     genDataProductDetail()
        // })
        $('.btn-gen-product-detail').click(function() {
            genDataProductDetail()
            $('#colorSelect').val('').trigger('change'); // Reset select color
            $('#massSelect').val('').trigger('change'); // Reset select mass
        })
        function genDataProductDetail(){
            let tenSanPham =  $('#tenSanPham').val()

            let colorSelectId = $('#colorSelect').val()
            let colorArr = colorData.filter(item => colorSelectId.includes(String(item.id)));

            let massSelectId = $('#massSelect').val()
            let massArr = massData.filter(item => massSelectId.includes(String(item.id)));
            if (!colorArr.length || !massArr.length) {
                return;
            }
            let productArr = [];
            colorArr.forEach(color => {
                massArr.forEach(mass => {
                    console.log(productDetailArr)
                    // Kiểm tra xem sản phẩm với màu sắc và khối lượng đã tồn tại hay chưa
                    let exists = productDetailArr.some(product => product.color.id === color.id && product.mass.id === mass.id);
                    console.log(exists)
                    if (!exists) { // Nếu chưa tồn tại, thêm vào mảng mới
                        let productDetail = {
                            product: tenSanPham,
                            color: color,
                            mass: mass,
                            quantity: 1,
                            price: 100000
                        };
                        productArr.push(productDetail);
                    }
                });
            });
            productDetailArr = [...productDetailArr, ...productArr]
            loadTableProductDetail(productDetailArr)
        }

        $('#productTable').on('click', '.deleteProduct', function () {
            var indexToDelete = $(this).data('index'); // Lấy index của item cần xóa
            productDetailArr.splice(indexToDelete, 1); // Xóa phần tử tại index từ mảng data
            console.log(productDetailArr);
            loadTableProductDetail(productDetailArr); // Cập nhật lại bảng sau khi xóa
        });

        // Lắng nghe sự kiện thay đổi số lượng
        $('#productTable').on('change', '.quantity-input', function () {
            var indexToUpdate = $(this).data('index'); // Lấy index của item cần cập nhật
            var newQuantity = $(this).val(); // Lấy giá trị mới của số lượng

            // Kiểm tra xem giá trị nhập vào có phải là số và không phải số âm
            if (isNaN(newQuantity) || newQuantity < 0) {
                $(this).val(1); // Đặt lại giá trị trong input thành 100000
                newQuantity = 1; // Cập nhật số lượng trong mảng dữ liệu
            }

            // Cập nhật số lượng trong mảng dữ liệu
            productDetailArr[indexToUpdate].quantity = newQuantity;
            console.log(productDetailArr);

            // Cập nhật lại bảng nếu cần (nếu bạn muốn làm điều này)
            loadTableProductDetail(productDetailArr);
        });


        // Lắng nghe sự kiện thay đổi giá
        $('#productTable').on('change', '.price-input', function () {
            var indexToUpdate = $(this).data('index'); // Lấy index của item cần cập nhật
            var newPrice = $(this).val(); // Lấy giá trị mới của giá

            // Kiểm tra xem giá trị nhập vào có phải là số và không phải số âm
            if (isNaN(newPrice) || newPrice < 0) {
                $(this).val(1); // Đặt lại giá trị trong input thành 100000
                newPrice = 1; // Cập nhật số lượng trong mảng dữ liệu
            }
            // Cập nhật giá trong mảng dữ liệu
            productDetailArr[indexToUpdate].price = newPrice;
            console.log(productDetailArr);

            // Cập nhật lại bảng nếu cần (nếu bạn muốn làm điều này)
            loadTableProductDetail(productDetailArr);
        });

        // Lắng nghe sự kiện thay đổi khi người dùng chọn file
        $('#imageInput').on('change', function() {
            var file = this.files[0]; // Lấy file đầu tiên từ danh sách file đã chọn

            if (file) {
                var formData = new FormData(); // Khởi tạo FormData
                formData.append('file', file); // Thêm file vào FormData (key là 'image')
                $.ajax({
                    url: '/files/upload', // URL API upload ảnh
                    type: 'POST',
                    data: formData,
                    processData: false, // Không xử lý dữ liệu
                    contentType: false, // Không gửi content-type (FormData sẽ tự động xử lý)
                    success: function(response) {
                        console.log('Upload thành công:', response);
                        $('#imagePreview').attr('src', response.data).show(); // Hiển thị ảnh đã upload
                    },
                    error: function(xhr, status, error) {
                        console.error('Có lỗi xảy ra:', error);
                    }
                });
            }
        });

    })

</script>