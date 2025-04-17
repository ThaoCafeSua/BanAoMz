<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="text-center mt-4" style="color: #001f3d;">
    <p>BanAoMzShop</p>
</footer>


<script type="text/javascript" src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<%--<script>--%>
<%--    function formatCurrency(value) {--%>
<%--        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);--%>
<%--    }--%>
<%--    function formatDate(isoString) {--%>
<%--        const date = new Date(isoString);--%>
<%--        const day = String(date.getUTCDate()).padStart(2, '0'); // Lấy ngày (2 chữ số)--%>
<%--        const month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Lấy tháng (2 chữ số, cộng thêm 1 vì tháng bắt đầu từ 0)--%>
<%--        const year = date.getUTCFullYear(); // Lấy năm--%>
<%--        return day + "-" + month + "-" + year;--%>
<%--    }--%>
<%--    const convertTypeInvoiceStatus = (type) =>--%>
<%--    {--%>
<%--        switch (type) {--%>
<%--            case "CHO_XAC_NHAN":--%>
<%--                return "Chờ Xác Nhận";--%>
<%--            case "DA_XAC_NHAN":--%>
<%--                return "Đã Xác Nhận";--%>
<%--            case "CHO_GIA0":--%>
<%--                return "Chờ Giao";--%>
<%--            case "DANG_GIAO":--%>
<%--                return "Đang Giao";--%>
<%--            case "HOAN_THANH":--%>
<%--                return "Hoàn Thành";--%>
<%--            case "CHO_THANH_TOAN":--%>
<%--                return "Chờ Thanh Toán";--%>
<%--            case "HUY":--%>
<%--                return "Hủy";--%>
<%--            case "TAO_DON_HANG":--%>
<%--                return "Tạo Đơn Hàng";--%>
<%--            case "DA_THANH_TOAN":--%>
<%--                return "Đã Thanh Toán";--%>
<%--            default:--%>
<%--                return "Không Xác Định";--%>
<%--        }--%>
<%--    }--%>
<%--    const convertPaymentMethod = (type) =>--%>
<%--    {--%>
<%--        switch (type) {--%>
<%--            case "TIEN_MAT":--%>
<%--                return "Tiền Mặt";--%>
<%--            case "CHUYEN_KHOAN":--%>
<%--                return "Chuyển Khoản";--%>
<%--            default:--%>
<%--                return "Không Xác Định";--%>
<%--        }--%>
<%--    }--%>

<%--    const convertStatusProduct = (type) =>--%>
<%--    {--%>
<%--        switch (type) {--%>
<%--            case "HOAT_DONG":--%>
<%--                return "Đang bán";--%>
<%--            case "NGUNG_HOAT_DONG":--%>
<%--                return "Ngừng bán";--%>
<%--            default:--%>
<%--                return "Không Xác Định";--%>
<%--        }--%>
<%--    }--%>

<%--    const convertTypeBill = (type) =>--%>
<%--    {--%>
<%--        switch (type) {--%>
<%--            case "OFFLINE":--%>
<%--                return "Tại Quầy";--%>
<%--            case "ONLINE":--%>
<%--                return "Trực Tuyến";--%>
<%--            case "DELIVERY":--%>
<%--                return "Giao Hàng";--%>
<%--            default:--%>
<%--                return "Không Xác Định";--%>
<%--        }--%>
<%--    }--%>

<%--    const convertStatusVoucher = (type) =>--%>
<%--    {--%>
<%--        switch (type) {--%>
<%--            case "SAP_DIEN_RA":--%>
<%--                return "Sắp Diễn Ra";--%>
<%--            case "DANG_DIEN_RA":--%>
<%--                return "Đang Diễn Ra";--%>
<%--            case "DA_KET_THUC":--%>
<%--                return "Đã Kết Thúc";--%>
<%--            case "DA_HUY":--%>
<%--                return "Đã Hủy";--%>
<%--            default:--%>
<%--                return "Không Xác Định";--%>
<%--        }--%>
<%--    }--%>
<%--</script>--%>
</body>
</html>