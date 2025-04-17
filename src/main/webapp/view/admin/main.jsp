<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        checkAuth();
    });
</script>

<%@ include file="footer.jsp" %> <!-- Footer -->
