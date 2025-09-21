<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Toastr CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
<!-- Toastr JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<!-- Đặt lên đầu trang JSP, ngay sau các taglib -->
<script type="text/javascript">
    const contextPath = '${pageContext.request.contextPath}';
</script>

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
    /* Toggle Switch */
    .switch {
        position: relative;
        display: inline-block;
        width: 46px;
        height: 24px;
    }
    /* Phần tử input phải phủ lên toàn bộ switch nhưng vẫn ẩn bằng opacity */
    .switch input{
        opacity: 0;
        position: absolute;
        inset: 0;        /* top:0; right:0; bottom:0; left:0 */
        cursor: pointer;
        z-index: 2;      /* đảm bảo nằm trên .slider */
        width: 100%;     /* quan trọng: nhận click toàn vùng */
        height: 100%;
    }

    /* Phần nền và khung của thanh trượt */
    .slider{
        position: absolute;
        inset: 0;                 /* top:0; right:0; bottom:0; left:0 */
        background-color:#ccc;    /* xám khi tắt */
        border-radius:34px;
        transition:0.4s;
        pointer-events:auto;      /* bạn đã có dòng này – giữ lại */
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 18px;
        width: 18px;
        left: 3px;
        bottom: 3px;
        background-color: white;
        transition: 0.4s;
        border-radius: 50%;
    }
    input:checked + .slider {
        background-color: #28a745;
    }
    input:checked + .slider:before {
        transform: translateX(22px);
    }

</style>

<div class="container">
    <h3>Cập Nhật Sản Phẩm</h3>
    <a href="/admin/product" class="btn mb-4"><i class="fa-solid fa-arrow-left"></i></a>

    <!-- Form cập nhật sản phẩm -->
    <div class="card">
        <div class="card-body row">
            <div class="col-7">
                <div class="mb-3">
                    <label for="tenSanPham" class="form-label required">Tên Sản Phẩm</label>
                    <input type="text" class="form-control" id="tenSanPham" placeholder="Nhập tên sản phẩm">
                </div>
                <div class="mb-3">
                    <label class="form-label required" for="danhMucSelect">Danh Mục</label>
                    <select class="form-control" id="danhMucSelect" name="danhMuc">
                        <option value="">Chọn danh mục</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="thuongHieuSelect" class="form-label required">Thương Hiệu</label>
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
                    <label class="form-label required">Trạng Thái</label>
                    <div class="col d-flex">
                        <div class="form-check">
                            <input class="form-check-input" id="status_type_on" type="radio" name="status_product" value="HOAT_DONG" checked>
                            <label class="form-check-label" for="status_type_on">Hoạt động</label>
                        </div>
                        <div class="form-check ml-2">
                            <input class="form-check-input" id="status_type_off" type="radio" name="status_product" value="NGUNG_HOAT_DONG">
                            <label class="form-check-label" for="status_type_off">Ngừng hoạt động</label>
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

    <!-- Form chọn thuộc tính sản phẩm -->
    <div class="card mt-4">
        <div class="card-body">
            <div class="row">
                <div class="col-6">
                    <label class="form-label required" for="colorSelect">Màu Sắc</label>
                    <select class="form-control" id="colorSelect" name="colorSelect" multiple data-placeholder="Chọn màu sắc"></select>
                </div>
                <div class="col-6">
                    <label for="massSelect" class="form-label required">Size</label>
                    <select class="form-control" id="massSelect" name="massSelect" multiple data-placeholder="Chọn size">
                    </select>
                </div>
            </div>
        </div>
    </div>

    <!-- Danh sách sản phẩm -->
    <div class="card mt-4">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-2">Sản Phẩm Chi Tiết</h5>
                <button type="button" class="btn btn-teal ml-4 btn-update-product">
                    <i class="fa-solid fa-plus"></i> Cập nhật
                </button>
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
                    <th>Trạng Thái</th>
                    <th>Hành Động</th>
                </tr>
                </thead>
                <tbody></tbody>
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

        function getDataDanhMuc(currentDanhMucId, currentDanhMucName) {
            $('#danhMucSelect').empty();
            $('#danhMucSelect').append('<option value="" disabled>Chọn danh mục</option>');

            $.ajax({
                url: '/admin/category/list',
                method: 'GET',
                dataType: 'json',
                data: {search: '', status: 'HOAT_DONG'},
                success: function (response) {
                    let exists = false;

                    response.data.forEach(function (item) {
                        const option = $('<option></option>').val(item.id).text(item.tenDanhMuc);
                        $('#danhMucSelect').append(option);

                        if (item.id == currentDanhMucId) {
                            exists = true;
                        }
                    });

                    if (!exists) {
                        $('#danhMucSelect').append(
                            $('<option></option>').val(currentDanhMucId).text(currentDanhMucName)
                        );
                    }

                    $('#danhMucSelect').val(currentDanhMucId);
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON);
                }
            });
        }
        getDataDanhMuc()

        function getDataThuongHieu(currentThuongHieuId, currentThuongHieuName) {
            $('#thuongHieuSelect').empty();
            $('#thuongHieuSelect').append('<option value="" disabled>Chọn thương hiệu</option>');

            $.ajax({
                url: '/admin/brand/list',
                method: 'GET',
                dataType: 'json',
                data: {search: '', status: 'HOAT_DONG'},
                success: function (response) {
                    let exists = false;

                    response.data.forEach(function (item) {
                        const option = $('<option></option>').val(item.id).text(item.tenThuongHieu);
                        $('#thuongHieuSelect').append(option);

                        if (item.id == currentThuongHieuId) {
                            exists = true;
                        }
                    });

                    if (!exists && currentThuongHieuId) {
                        $('#thuongHieuSelect').append(
                            $('<option></option>').val(currentThuongHieuId).text(currentThuongHieuName)
                        );
                    }

                    $('#thuongHieuSelect').val(currentThuongHieuId);
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON);
                }
            });
        }
        getDataThuongHieu();

        function getDataXuatXu(currentXuatXuId, currentXuatXuName) {
            $('#xuatXuSelect').empty();
            $('#xuatXuSelect').append('<option value="" disabled>Chọn xuất xứ</option>');

            $.ajax({
                url: '/admin/origin/list',
                method: 'GET',
                dataType: 'json',
                data: {search: '', status: 'HOAT_DONG'},
                success: function (response) {
                    let exists = false;

                    response.data.forEach(function (item) {
                        const option = $('<option></option>').val(item.id).text(item.tenXuatXu);
                        $('#xuatXuSelect').append(option);

                        if (item.id == currentXuatXuId) {
                            exists = true;
                        }
                    });

                    if (!exists && currentXuatXuId) {
                        $('#xuatXuSelect').append(
                            $('<option></option>').val(currentXuatXuId).text(currentXuatXuName)
                        );
                    }

                    $('#xuatXuSelect').val(currentXuatXuId);
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON);
                }
            });
        }
        getDataXuatXu()

        function getDataMauSac(currentMauSacId, currentMauSacName) {
            $('#colorSelect').empty();

            $.ajax({
                url: '/admin/color/list',
                method: 'GET',
                dataType: 'json',
                data: {search: '', status: 'HOAT_DONG'},
                success: function (response) {
                    colorData = response.data;
                    let exists = false;

                    response.data.forEach(function (item) {
                        const option = $('<option></option>').val(item.id).text(item.tenMauSac);
                        $('#colorSelect').append(option);

                        if (item.id == currentMauSacId) {
                            exists = true;
                        }
                    });

                    if (!exists && currentMauSacId) {
                        $('#colorSelect').append(
                            $('<option></option>').val(currentMauSacId).text(currentMauSacName)
                        );
                    }

                    $('#colorSelect').val(currentMauSacId).trigger('change');
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON);
                }
            });
        }
        getDataMauSac()

        function getDataSize(currentSizeId, currentSizeName) {
            $('#massSelect').empty();

            $.ajax({
                url: '/admin/size/list',
                method: 'GET',
                dataType: 'json',
                data: {search: '', status: 'HOAT_DONG'},
                success: function (response) {
                    massData = response.data;
                    let exists = false;

                    response.data.forEach(function (item) {
                        const option = $('<option></option>').val(item.id).text(item.tenSize);
                        $('#massSelect').append(option);

                        if (item.id == currentSizeId) {
                            exists = true;
                        }
                    });

                    if (!exists && currentSizeId) {
                        $('#massSelect').append(
                            $('<option></option>').val(currentSizeId).text(currentSizeName)
                        );
                    }

                    $('#massSelect').val(currentSizeId).trigger('change');
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
                    getDataDanhMuc(data.danhMuc.id, data.danhMuc.tenDanhMuc);

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

        function updateProduct() {
            let xuatXu = $('#xuatXuSelect').val()
            let danhMuc = $('#danhMucSelect').val()
            let thuongHieu = $('#thuongHieuSelect').val()
            let tenSanPham = $('#tenSanPham').val()
            let trangThai = $("input[name='status_product']:checked").val();
            let urlAnh = $('#imagePreview').attr('src') || '';
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
                    id:        item.id,
                    sizeId: item.size.id,
                    mauSacId: item.mauSac.id,
                    soLuong: item.soLuong,
                    giaBan: item.giaBan,
                    trangThai: item.trangThai || 'HOAT_DONG'
                }
            })
            Swal.fire({
                title: 'Xác nhận hoàn tất cập nhật sản phẩm ?',
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
                        url: '/admin/product/update',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            id: sanPhamId,
                            tenSanPham: tenSanPham,
                            danhMuc: danhMuc,
                            thuongHieu: thuongHieu,
                            xuatXu: xuatXu,
                            trangThai: trangThai,
                            urlAnh: urlAnh,
                            lstChiTietSanPham: lstChiTiet
                        }),
                        success: function (response) {
                            toastr.success('Cập nhật sản phẩm thành công');
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
        $(document).on('click', '.btn-update-product', function () {
            updateProduct()
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

        function loadDataProdcutDetail(data){
            $('#xuatXuSelect').val(data.xuatXu.id); // Gán giá trị ID của xuất xứ
            $('#danhMucSelect').val(data.danhMuc.id); // Gán giá trị ID của danh mục
            $('#thuongHieuSelect').val(data.thuongHieu.id); // Gán giá trị ID của thương hiệu
            $('#tenSanPham').val(data.tenSanPham); // Gán tên sản phẩm
            $("input[name='status_product'][value='" + data.trangThai + "']").prop('checked', true); // Gán trạng thái
            $('#imagePreview').attr('src', data.urlAnh);

        }

        function loadTableProductDetail(data) {
            console.log(data);
            data.sort((a, b) => a.mauSac.id - b.mauSac.id);
            productTable.clear();

            $.each(data, function (index, item) {
                // 1) Log trạng thái gốc
                console.log('ITEM STATUS =', item.trangThai);

                // 2) Chuẩn hoá thành uppercase để so sánh bất chấp chữ hoa/chữ thường
                const isActive = String(item.trangThai).toUpperCase() === 'HOAT_DONG';

                // 3) Sinh HTML công tắc với khoảng trắng trước checked nếu active
                let toggleSwitch =
                    '<label class="switch">' +
                    '<input type="checkbox" ' +
                    'class="status-toggle" ' +
                    'data-index="' + index + '"' +
                    (isActive ? ' checked' : '') +
                    '>' +
                    '<span class="slider"></span>' +
                    '</label>';

                // 4) Log HTML công tắc để kiểm chứng
                console.log('toggleSwitch HTML =', toggleSwitch);

                productTable.row.add([
                    index + 1,
                    item.tenSanPham,
                    item.mauSac.tenMauSac,
                    item.size.tenSize,
                    '<input class="form-control soLuong-input" type="number" min="1" value="' + item.soLuong + '" data-index="' + index + '" />',
                    '<input class="form-control giaBan-input" type="number" min="5000" value="' + item.giaBan + '" data-index="' + index + '" />',
                    toggleSwitch,
                    '<button class="btn btn-danger deleteProduct" data-index="' + index + '"><i class="fa-solid fa-trash"></i></button>'
                ]);
            });

            productTable.draw();
        }

        $('#tenSanPham').change(function() {
            genDataProductDetail()
        })
        $('#colorSelect').change(function() {
            genDataProductDetail()
        })
        $('#massSelect').change(function() {
            genDataProductDetail()
        })

        // $('.btn-gen-product-detail').click(function() {
        //     genDataProductDetail()
        //     $('#colorSelect').val('').trigger('change'); // Reset select color
        //     $('#massSelect').val('').trigger('change'); // Reset select mass
        // })

        function genDataProductDetail() {
            let product = $('#tenSanPham').val();

            let colorSelectId = $('#colorSelect').val();
            let colorArr = colorData.filter(item => colorSelectId.includes(String(item.id)));

            let sizeSelectId = $('#massSelect').val(); //
            let sizeArr = massData.filter(item => sizeSelectId.includes(String(item.id))); // massData chính là size

            // Nếu thiếu màu hoặc size thì không làm gì
            if (!colorArr.length || !sizeArr.length) {
                return;
            }

            let productArr = [];
            colorArr.forEach(color => {
                sizeArr.forEach(size => {
                    let exists = productDetailArr.some(product =>
                        product.mauSac.id === color.id && product.size.id === size.id
                    );

                    if (!exists) {
                        let productDetail = {
                            tenSanPham: product,
                            mauSac: color,
                            size: size,
                            soLuong: 1,
                            giaBan: 100000
                        };
                        productArr.push(productDetail);
                    }
                });
            });

            productDetailArr = [...productDetailArr, ...productArr];
            loadTableProductDetail(productDetailArr);
        }


        $('#productTable').on('click', '.deleteProduct', function () {
            var indexToDelete = $(this).data('index'); // Lấy index của item cần xóa
            productDetailArr.splice(indexToDelete, 1); // Xóa phần tử tại index từ mảng data
            console.log(productDetailArr);
            loadTableProductDetail(productDetailArr); // Cập nhật lại bảng sau khi xóa
        });

        // Lắng nghe sự kiện thay đổi số lượng
        $('#productTable').on('change', '.soLuong-input', function () {
            var indexToUpdate = $(this).data('index'); // Lấy index của item cần cập nhật
            var newQuantity = $(this).val(); // Lấy giá trị mới của số lượng

            if (newQuantity === "" || isNaN(newQuantity) || parseInt(newQuantity) < 0) {
                newQuantity = 0;
                $(this).val(newQuantity);
            } else {
                newQuantity = parseInt(newQuantity, 10);
            }
            // Cập nhật số lượng trong mảng dữ liệu
            productDetailArr[indexToUpdate].soLuong = newQuantity;
            console.log(productDetailArr);

            // Cập nhật lại bảng nếu cần (nếu bạn muốn làm điều này)
            loadTableProductDetail(productDetailArr);
        });
       // Dùng ủy quyền (delegation) – phù hợp với DataTables
        $('#productTable').on('change', 'input.status-toggle', function () {
            const index = $(this).data('index');
            const isChecked = this.checked;

            productDetailArr[index].trangThai = isChecked ? 'HOAT_DONG' : 'NGUNG_HOAT_DONG';
            console.log(`Biến thể #${index + 1} -> ${productDetailArr[index].trangThai}`);
        });


        // Lắng nghe sự kiện thay đổi giá
        $('#productTable').on('change', '.giaBan-input', function () {
            var indexToUpdate = $(this).data('index'); // Lấy index của item cần cập nhật
            var newPrice = $(this).val(); // Lấy giá trị mới của giá

            // Kiểm tra xem giá trị nhập vào có phải là số và không phải số âm
            if (isNaN(newPrice) || newPrice < 5000) {
                $(this).val(5000); // Đặt lại giá trị trong input thành 100000
                newPrice = 5000; // Cập nhật số lượng trong mảng dữ liệu
            }

            // Cập nhật giá trong mảng dữ liệu
            productDetailArr[indexToUpdate].giaBan = newPrice;
            console.log(productDetailArr);

            // Cập nhật lại bảng nếu cần (nếu bạn muốn làm điều này)
            loadTableProductDetail(productDetailArr);
        });

        // Lắng nghe sự kiện thay đổi khi người dùng chọn file
        $('#imageInput').on('change', function() {
            var file = this.files[0]; // Lấy file đầu tiên

            if (file) {
                var formData = new FormData();
                formData.append('file', file);

                $.ajax({
                    // Thêm contextPath vào URL
                    url: contextPath + '/files/upload',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        console.log('Upload thành công:', response);
                        // Preview cũng nối contextPath
                        $('#imagePreview')
                            .attr('src', contextPath + response.data)
                            .show();
                    },
                    error: function(xhr, status, error) {
                        console.error('Có lỗi xảy ra:', error);
                    }
                });
            }
        });
    })


</script>