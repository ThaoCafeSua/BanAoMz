<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div>
    <h3>Khách hàng</h3>
    <a href="/admin/customer" class="btn mb-2"><i class="fa-solid fa-arrow-left"></i></a>
    <div class="card">
        <div class="card-body">
            <form id="customerForm" action="${action}" method="post">
                <input type="hidden" class="form-control" name="id" id="id" value="${customer.id}">
                <div class="mb-3">
                    <label for="nameKh" class="form-label">Tên khách hàng</label>
                    <input type="text" class="form-control" name="hoVaTen" id="nameKh" placeholder="Nhập tên khách hàng" value="${customer.hoVaTen}">
                </div>
                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <div class="d-flex">
                        <c:forEach var="entry" items="${gender}">
                            <div class="mr-4">
                                <input type="radio" id="gender${entry.key}" name="gioiTinh" value="${entry.key}"
                                       <c:if test="${customer.gioiTinh == entry.key}">checked</c:if>>
                                <label for="gender${entry.key}" class="form-check-label">${entry.value}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="dateKh" class="form-label">Ngày sinh</label>
                    <input type="date" style="width: 200px" class="form-control" id="dateKh" name="ngaySinh"
                           value="${customer.ngaySinh != null ? customer.ngaySinh : '1990-01-01'}" placeholder="Nhập Ngày sinh">
                </div>
                <div class="mb-3">
                    <label for="phoneKh" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phoneKh" name="soDienThoai" value="${customer.soDienThoai}" placeholder="Nhập Số điện thoại">
                </div>
                <div class="mb-3">
                    <label for="emailKh" class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="emailKh" value="${customer.email}" placeholder="Nhập email khách hàng">
                </div>
                <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-primary">${btnText}</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function validateForm(event) {
        event.preventDefault(); // Ngăn hành động gửi form mặc định

        // Kiểm tra tên khách hàng
        var name = $("#nameKh").val();
        if (name.trim() === "") {
            toastr.error("Tên khách hàng không được để trống");
            return false;
        }

        // Kiểm tra số điện thoại
        var phone = $("#phoneKh").val();
        var phoneRegex = /^[0-9]{10,11}$/;
        if (!phone.match(phoneRegex)) {
            toastr.error("Số điện thoại không hợp lệ. Vui lòng nhập 10-11 chữ số.");
            return false;
        }

        // Kiểm tra email
        var email = $("#emailKh").val();
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email.match(emailRegex)) {
            toastr.error("Email không hợp lệ.");
            return false;
        }

        // Kiểm tra giới tính
        var gender = $('input[name="gioiTinh"]:checked').val();
        if (!gender) {
            toastr.error("Vui lòng chọn giới tính.");
            return false;
        }

        // Kiểm tra ngày sinh
        var dob = $("#dateKh").val();
        if (dob.trim() === "") {
            toastr.error("Vui lòng nhập ngày sinh.");
            return false;
        }

        // Hiển thị xác nhận trước khi gửi form
        Swal.fire({
            title: `Xác Nhận ${btnText}?`,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $("#customerForm")[0].submit(); // Gửi form trực tiếp sau khi xác nhận
            }
        });
    }

    // Gắn sự kiện validateForm vào form
    $(document).ready(function () {
        $("#customerForm").on("submit", validateForm);
    });
</script>
