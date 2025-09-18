<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<<<<<<< HEAD
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/includes/images/MzShop.png">
=======
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">

>>>>>>> origin/dev_hoang

<!-- main.jsp -->
<div class="main-content">
    <%@ include file="header.jsp" %> <!-- Đưa phần header động ở đây -->
    <div id="loading" class="loading-overlay" style="display: none">
        <div class="loader"></div>
    </div>
</div>

<script>
    $(document).ready(function () {
        function checkAuth(){
            let account = localStorage.getItem("account");
            if (account) {
                account = JSON.parse(account);  // Chuyển chuỗi JSON thành đối tượng
            }
            console.log(account); // Debug nếu cần thiết
            if (!account) {
                localStorage.removeItem("account");
                window.location.href = "/admin/login";
            }
        }
        // checkAuth();
    });
</script>
<script>
    $(function () {
        var token  = $('meta[name="_csrf"]').attr('content');
        var header = $('meta[name="_csrf_header"]').attr('content');

        // Áp cho mọi $.ajax
        $(document).ajaxSend(function (e, xhr) {
            xhr.setRequestHeader(header, token);
        });
    });
</script>


<%@ include file="footer.jsp" %> <!-- Footer -->
