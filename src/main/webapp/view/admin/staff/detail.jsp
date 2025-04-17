<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div>
    <h3>Nhân viên</h3>
    <a href="/admin/staff" class="btn mb-2"><i class="fa-solid fa-arrow-left"></i></a>
    <div class="card">
        <div class="card-body">
            <div class="row  mt-4">
                <div class="col-4 d-flex">
                    <div class="">
                        Tên nhân viên:
                    </div>
                    <div class="ml-2" id="tenNhanVien">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Ngày sinh:
                    </div>
                    <div class="ml-2" id="ngaySinh">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Giới Tính:
                    </div>
                    <div class="ml-2" id="gioiTinh">
                    </div>
                </div>
            </div>
            <div class="row mt-4 mb-4">
                <div class="col-4 d-flex">
                    <div class="">
                        Số điện thoại:
                    </div>
                    <div class="ml-2" id="sdt">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Email:
                    </div>
                    <div class="ml-2" id="email">
                    </div>
                </div>
                <div class="col-4 d-flex">
                    <div class="">
                        Địa chỉ:
                    </div>
                    <div class="ml-2" id="diaChi">
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</div>

<script>

    let staffId = ${staffId};
    let lstAddress = [];


    $(document).ready(function () {

        function getDetailStaff() {
            $('#loading').show();
            $.ajax({
                url: '/admin/staff/detail',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(staffId),
                success: function (data) {
                    fillDataStaff(data.data)
                    $('#loading').hide();
                },
                error: function (err) {
                    $('#loading').hide();
                    toastr.error('Lỗi khi lấy dữ liệu nhân viên', err);
                }
            });
        }


        function fillDataStaff(data) {
            $('#tenNhanVien').text(data.tenNhanVien);
            $('#ngaySinh').text(data.ngaySinh);
            $('#gioiTinh').text(data.gioiTinh == 'Male' ? 'Nam' : 'Nữ');
            $('#sdt').text(data.sdt);
            $('#email').text(data.email);
            $('#diaChi').text(data.diaChi);
        }
        
        getDetailStaff()
        

      
    })

</script>