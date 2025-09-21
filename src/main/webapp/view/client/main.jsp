<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="header.jsp" %>

<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/includes/images/MzShop.png">

<main>
    <jsp:include page="${page}.jsp" />
    <div id="loading" class="loading-overlay" style="display: none">
        <div></div>
        <div class="loader"></div>
    </div>
</main>

<%@ include file="footer.jsp" %>
