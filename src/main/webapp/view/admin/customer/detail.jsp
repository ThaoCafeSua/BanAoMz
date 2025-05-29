<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- CSS & JS -->
<link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<div class="container mt-4">

    <h3 style="color: #001f3d;" class="mt-4">Chi tiết khách hàng</h3>
    <a href="/admin/customer" class="btn btn-outline-secondary btn-sm mb-3">
        <i class="fa-solid fa-arrow-left"></i>
    </a>

    <!-- Thông tin khách hàng -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Tên khách hàng:</label>
                    <div id="hoVaTenKh" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Ngày sinh:</label>
                    <div id="ngaySinhKh" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Giới tính:</label>
                    <div id="gioiTinhKh" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Số điện thoại:</label>
                    <div id="soDienThoaiKh" class="text-dark"></div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold text-primary">Email:</label>
                    <div id="emailKh" class="text-dark"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Địa chỉ giao hàng -->
    <div class="card">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="card-title">Địa chỉ nhận hàng</h5>
                <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addressModal">
                    <i class="fa-solid fa-plus"></i> Thêm địa chỉ
                </button>
            </div>

            <!-- Bảng danh sách địa chỉ -->
            <table class="table table-hover" id="addressTable">
                <thead style="background-color: #001f3d; color: white;">
                <tr class="text-center">
                    <th>STT</th>
                    <th>Mặc định</th>
                    <th>Người nhận</th>
                    <th>Điện thoại</th>
                    <th>Tỉnh/Thành</th>
                    <th>Quận/Huyện</th>
                    <th>Phường/Xã</th>
                    <th>Chi tiết</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Thêm/Sửa Địa Chỉ -->
<div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addressModalLabel">Thông tin địa chỉ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="idAddress">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="nameAddress" class="form-label">Họ và tên người nhận</label>
                        <input type="text" class="form-control" id="nameAddress" placeholder="VD: Nguyễn Văn A">
                    </div>
                    <div class="col-md-6">
                        <label for="phoneAddress" class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control" id="phoneAddress" placeholder="VD: 0987654321">
                    </div>
                    <div class="col-md-4">
                        <label for="provinceAddress" class="form-label">Tỉnh/Thành</label>
                        <select class="form-select" id="provinceAddress">
                            <option value="" selected disabled>Chọn tỉnh</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="districtAddress" class="form-label">Quận/Huyện</label>
                        <select class="form-select" id="districtAddress">
                            <option value="" selected disabled>Chọn huyện</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="wardAddress" class="form-label">Phường/Xã</label>
                        <select class="form-select" id="wardAddress">
                            <option value="" selected disabled>Chọn xã</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label for="detailAddress" class="form-label">Địa chỉ chi tiết</label>
                        <input type="text" class="form-control" id="detailAddress" placeholder="VD: Số 10, đường Lê Lợi">
                    </div>
                    <div class="col-12">
                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" id="defaultAddress">
                            <label class="form-check-label" for="defaultAddress">
                                Đặt làm địa chỉ mặc định
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="addAddress" class="btn btn-primary">Hoàn tất</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </div>
    </div>
</div>

<style>
    /* Nút quay lại */
    .btn-outline-secondary {
        border-color: #cccccc;
        color: #001f3d;
        border-radius: 20px;
        padding: 6px 14px;
    }

    .btn-outline-secondary:hover {
        background-color: #004080;
        color: white;
    }

    /* Nút chính */
    .btn-teal {
        background-color: #001f3d;
        color: white;
        border-radius: 20px;
        padding: 6px 20px;
        border: 1px solid #cccccc;
    }

    .btn-teal:hover {
        background-color: #004080;
        color: white;
    }

    /* Áp dụng cho toàn bộ button */
    .btn {
        border: 1px solid #cccccc !important;
        border-radius: 4px !important;
    }

    .btn:hover {
        background-color: #004080 !important;
        color: white !important;
    }

    /* Label và tiêu đề */
    .form-label, .modal-title, .card-title, h3, h5 {
        color: #001f3d;
        font-weight: 600;
    }

    .text-primary {
        color: #001f3d !important;
    }

    /* Input, select */
    .form-control, .form-select {
        border-radius: 8px;
        border: 1px solid #dcdcdc;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    .form-control:focus, .form-select:focus {
        border-color: #004080;
        box-shadow: 0 0 0 0.15rem rgba(0, 31, 61, 0.2);
    }

    /* Card */
    .card {
        background-color: white;
        border: 1px solid #dcdcdc;
        border-radius: 10px;
    }

    /* Table */
    table thead {
        background-color: #001f3d;
        color: white;
    }

    table th, table td {
        border: 1px solid #dcdcdc !important;
        vertical-align: middle;
    }

    .table-striped tbody tr:nth-of-type(odd) {
        background-color: #f9f9f9;
    }

    .badge.text-bg-primary {
        background-color: #001f3d !important;
        color: white;
        font-size: 13px;
        padding: 5px 10px;
        border-radius: 12px;
    }

    /* Modal */
    .modal-content {
        border: 1px solid #dcdcdc;
        border-radius: 12px;
    }

    .modal-header {
        border-bottom: 1px solid #dcdcdc;
        background-color: #f8f9fa;
    }

    .modal-footer {
        border-top: 1px solid #dcdcdc;
    }

    /* Nút đóng modal */
    .btn-close {
        background-color: #dcdcdc;
        border-radius: 50%;
        padding: 5px;
    }

</style>

<script>

    let customerId = ${customerId};
    let lstAddress = [];

    let provinceId = null;
    let districtId = null;
    let wardId = null;

    let lstProvince = [];
    let lstDistrict = [];
    let lstWard = [];

    const GHN_API = "https://online-gateway.ghn.vn/shiip/public-api/master-data"
    const GHN_TOKEN = "dfe1e7cf-e582-11ee-b290-0e922fc774da"

    $(document).ready(function () {
        let addressTable = $('#addressTable').DataTable({
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

        function getDetailCustomer() {
            $('#loading').show();
            $.ajax({
                url: '/admin/customer/detail',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(customerId),
                success: function (data) {
                    fillDataCustomer(data.data)
                    lstAddress = data.data.lstDiaChi.sort((a, b) => b.id - a.id);
                    fillTableAddress(lstAddress)
                    $('#loading').hide();
                },
                error: function (err) {
                    $('#loading').hide();
                    toastr.error('Lỗi khi lấy dữ liệu khách hàng', err);
                }
            });
        }


        function fillDataCustomer(data) {
            $('#hoVaTenKh').text(data.hoVaTen);
            $('#ngaySinhKh').text(data.ngaySinh);
            $('#gioiTinhKh').text(data.gioiTinh == 'Male' ? 'Nam' : 'Nữ');
            $('#soDienThoaiKh').text(data.soDienThoai);
            $('#emailKh').text(data.email);
        }

        function fillTableAddress(data) {
            addressTable.clear();
            $.each(data, function (index, address) {
                addressTable.row.add([
                    index + 1,
                    address.diaChiMacDinh ? '<span class="badge text-bg-primary">Mặc Đinh</span>' : '',
                    address.tenNguoiNhan,
                    address.dienThoaiNguoiNhan,
                    address.tinh,
                    address.huyen,
                    address.xa,
                    address.diaChiChiTiet,
                    '<button class="btn btn-success btn-sm btn-update-address" data-address-id="' + address.id + '"><i class="fa-solid fa-pen"></i></button>'
                ]);
            });
            addressTable.draw();
        }

        getDetailCustomer()


        function fillDataAddress(data) {
            $('#idAddress').val(data.id);
            $('#nameAddress').val(data.tenNguoiNhan);
            $('#phoneAddress').val(data.dienThoaiNguoiNhan);
            // $('#provinceAddress').val(data.tinh);
            // $('#districtAddress').val(data.huyen);
            // $('#wardAddress').val(data.xa);
            $('#detailAddress').val(data.diaChiChiTiet);
            $('#defaultAddress').prop('checked', data.diaChiMacDinh);
        }

        function resetFormAddress() {
            $('#idAddress').val('');
            $('#nameAddress').val('');
            $('#phoneAddress').val('');
            $('#provinceAddress').val('');
            $('#districtAddress').val('');
            $('#wardAddress').val('');
            $('#detailAddress').val('');
            $('#defaultAddress').prop('checked', false);
        }

        $('#addressModal').on('hidden.bs.modal', function (e) {
            resetFormAddress();
        });

        $(document).on('click', '#addAddress', function () {
            addAddress()
        });

        function addAddress() {
            let idAddress = $('#idAddress').val();
            let nameAddress = $('#nameAddress').val();
            let phoneAddress = $('#phoneAddress').val();
            let provinceAddress = $('#provinceAddress option:selected').text();
            let districtAddress = $('#districtAddress option:selected').text();
            let wardAddress = $('#wardAddress option:selected').text();
            let detailAddress = $('#detailAddress').val();
            let defaultAddress = $('#defaultAddress').prop('checked')
            $('#loading').show();
            $.ajax({
                url: '/admin/customer/address',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    customerId: customerId,
                    id: idAddress,
                    tenNguoiNhan: nameAddress,
                    dienThoaiNguoiNhan: phoneAddress,
                    diaChiChiTiet: detailAddress,
                    xa: wardAddress,
                    huyen: districtAddress,
                    tinh: provinceAddress,
                    diaChiMacDinh: defaultAddress,
                }),
                success: function (response) {
                    getDetailCustomer()
                    $('#addressModal').modal('hide');
                    $('#loading').hide();
                    toastr.success('Thêm địa chỉ thành công');
                },
                error: function (err) {
                    $('#loading').hide();
                    toastr.error('Thêm địa chỉ thất bại');
                }
            });
        }

        $(document).on('click', '.btn-update-address', async function () {
            let addressId = $(this).data('address-id');
            let address = lstAddress.find(address => address.id == addressId);
            $('#addressModal').modal('show');
            await getDataProvince()
            provinceId = lstProvince.find(item => item.label == address.tinh)?.value;
            console.log(address)
            console.log(lstProvince)
            console.log(provinceId)
            await getDataDistrict()
            districtId = lstDistrict.find(item => item.label == address.huyen)?.value;
            await getDataWard()
            wardId = lstWard.find(item => item.label == address.xa)?.value;

            $('#provinceAddress').val(provinceId);
            $('#districtAddress').val(districtId);
            $('#wardAddress').val(wardId);
            $('#idAddress').val(address.id);
            $('#nameAddress').val(address.tenNguoiNhan);
            $('#phoneAddress').val(address.dienThoaiNguoiNhan);
            $('#detailAddress').val(address.diaChiChiTiet);
            $('#defaultAddress').prop('checked', address.diaChiMacDinh);
        })

        $('#addressModal').on('show.bs.modal', function (e) {
            getDataProvince()
        });
        //get data province
        async function getDataProvince() {
            $('#provinceAddress').empty();
            $('#provinceAddress').append('<option value="" selected>Chọn tỉnh</option>');
            await $.ajax({
                url: GHN_API+'/province',
                type: 'GET',
                headers: {
                    token: GHN_TOKEN
                },
                success: function (response) {
                    lstProvince = response.data.map((result) => {
                        return {
                            value: result.ProvinceID,
                            label: result.ProvinceName
                        };
                    });
                    lstProvince.forEach(function (province) {
                        $('#provinceAddress').append(
                            $('<option></option>').val(province.value).text(province.label)
                        );
                    });
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseJSON);
                }
            });
        }
        $('#provinceAddress').change(function() {
            provinceId = $(this).val();
            getDataDistrict()
        })

        async function getDataDistrict() {
            $('#districtAddress').empty();
            $('#districtAddress').append('<option value="" selected>Chọn huyện</option>');
            $('#wardAddress').empty();
            $('#wardAddress').append('<option value="" selected>Chọn xã</option>');
            if (provinceId != null && provinceId !="") {
                await $.ajax({
                    url: GHN_API+'/district',
                    type: 'GET',
                    headers: {
                        token: GHN_TOKEN
                    },
                    data: {
                        province_id: provinceId
                    },
                    success: function(response) {
                        lstDistrict = response.data.map((result) => {
                            return {
                                value: result.DistrictID,
                                label: result.DistrictName
                            };
                        });
                        lstDistrict.forEach(function (district) {
                            $('#districtAddress').append(
                                $('<option></option>').val(district.value).text(district.label)
                            );
                        });
                    },
                    error: function(xhr, status, error) {
                        console.log(xhr.responseJSON); // In ra thông báo lỗi
                    }
                });
            }
        }
        $('#districtAddress').change(function() {
            districtId = $(this).val();
            getDataWard()
        })
        async function getDataWard() {
            $('#wardAddress').empty();
            $('#wardAddress').append('<option value="" selected>Chọn xã</option>');
            if (districtId != null && districtId !="") {
                await $.ajax({
                    url: GHN_API+'/ward',
                    type: 'GET',
                    headers: {
                        token: GHN_TOKEN
                    },
                    data: {
                        district_id: districtId
                    },
                    success: function(response) {
                        lstWard = response.data.map((result) => {
                            return {
                                value: result.WardCode,
                                label: result.WardName
                            };
                        });
                        lstWard.forEach(function (ward) {
                            $('#wardAddress').append(
                                $('<option></option>').val(ward.value).text(ward.label)
                            );
                        });
                    },
                    error: function(xhr, status, error) {
                        console.log(xhr.responseJSON); // In ra thông báo lỗi
                    }
                });
            }
        }

        $('#wardAddress').change(function() {
            wardId = $(this).val();
        })
    })

</script>