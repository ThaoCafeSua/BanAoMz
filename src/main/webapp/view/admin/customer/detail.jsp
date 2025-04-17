<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div>
    <h3>Khách hàng</h3>
    <a href="/admin/customer" class="btn mb-2"><i class="fa-solid fa-arrow-left"></i></a>
    <div class="card">
        <div class="card-body">
            <div class="row  mt-4">
                <div class="col-4 d-flex">
                    <div class="">
                        Tên khách hàng:
                    </div>
                    <div class="ml-2" id="hoVaTenKh">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Ngày sinh:
                    </div>
                    <div class="ml-2" id="ngaySinhKh">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Giới Tính:
                    </div>
                    <div class="ml-2" id="gioiTinhKh">
                    </div>
                </div>
            </div>
            <div class="row mt-4 mb-4">
                <div class="col-4 d-flex">
                    <div class="">
                        Số điện thoại:
                    </div>
                    <div class="ml-2" id="soDienThoaiKh">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Email:
                    </div>
                    <div class="ml-2" id="emailKh">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card mt-4">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="card-title">Địa Chỉ Nhận Hàng</h5>
                <button class="btn btn-primary" data-toggle="modal" data-target="#addressModal"><i
                        class="fa-solid fa-plus"></i> Thêm Địa Chỉ
                </button>
                <div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" style="max-width: 48%">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addressModalLabel">Địa Chỉ</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" class="form-control" id="idAddress">
                                <div class="mb-3">
                                    <label for="nameAddress" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="nameAddress"
                                           placeholder="Nhập tên người nhận">
                                </div>
                                <div class="mb-3">
                                    <label for="phoneAddress" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phoneAddress"
                                           placeholder="Nhập Số điện thoại">
                                </div>
                                <div class="mb-3 row">
                                    <div class="col-4">
                                        <label for="provinceAddress" class="form-label">Tỉnh/Thành</label>
                                        <select class="form-select" id="provinceAddress">
                                            <option value="" selected disabled>Chọn tỉnh</option>
                                        </select>
                                    </div>
                                    <div class="col-4">
                                        <label class="form-label" for="districtAddress">Quận/Huyện</label>
                                        <select class="form-select" id="districtAddress">
                                            <option value="" selected disabled>Chọn huyện</option>
                                        </select>
                                    </div>
                                    <div class="col-4">
                                        <label for="wardAddress" class="form-label">Xã/Phường</label>
                                        <select class="form-select" id="wardAddress">
                                            <option value="" selected disabled>Chọn xã</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="detailAddress" class="form-label">Địa chỉ chi tiết</label>
                                    <input type="text" class="form-control" id="detailAddress"
                                           placeholder="Nhập địa chỉ chi tiết">
                                </div>
                                <div class="mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="defaultAddress">
                                        <label class="form-check-label" for="defaultAddress">
                                            Đặt làm địa chỉ mặc định
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" id="addAddress">Hoàn Tất</button>
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <table class="table" id="addressTable">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Địa chỉ mặc đinh</th>
                    <th>Họ và tên</th>
                    <th>Số điện thoại</th>
                    <th>Tỉnh/Thành phố</th>
                    <th>Quận/Huyện</th>
                    <th>Xã/Phường</th>
                    <th>Chi tiết</th>
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
                    '<button class="btn btn-success btn-sm btn-update-address" data-address-id="' + address.id + '"><i class="fa-solid fa-pen"></i></button>' +
                    '<button class="btn btn-danger btn-sm btn-delete-address ml-2" data-address-id="' + address.id + '"><i class="fa-solid fa-trash"></i></button>'
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


        $(document).on('click', '.btn-delete-address', function () {
            Swal.fire({
                title: 'Bạn có chắc muốn xóa địa chỉ này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Xác nhận',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    let idAddress = $(this).data('address-id');
                    $('#loading').show();
                    $.ajax({
                        url: '/admin/customer/delete-address',
                        method: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(idAddress),
                        success: function (response) {
                            getDetailCustomer()
                            $('#addressModal').modal('hide');
                            $('#loading').hide();
                            toastr.success('Xóa địa chỉ thành công');
                        },
                        error: function (err) {
                            $('#loading').hide();
                            toastr.error('Xóa địa chỉ thất bại');
                        }
                    });
                }
            });
        })

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