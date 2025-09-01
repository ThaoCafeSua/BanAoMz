<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .contact-container {
        padding: 40px 20px;
        background-color: #ffffff;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .contact-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .contact-header h2 {
        color: #001f3d;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .contact-header p {
        color: #555;
    }

    .contact-content {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .map-box iframe {
        width: 100%;
        height: 300px;
        border: 1px solid #ddd;
    }

    .info-box h4 {
        color: #001f3d;
        margin-bottom: 15px;
    }

    .info-box p {
        margin: 8px 0;
        color: #333;
    }

    .info-box i {
        color: #001f3d;
        margin-right: 10px;
    }

    /* Chia cột khi trên màn hình lớn */
    @media (min-width: 768px) {
        .contact-content {
            flex-direction: row;
        }

        .map-box, .info-box {
            flex: 1;
        }

        .map-box {
            padding-right: 20px;
        }

        .info-box {
            padding-left: 20px;
        }
    }
</style>

<div class="container contact-container">
    <div class="contact-header">
        <h2>Liên hệ với chúng tôi</h2>
        <p>Chúng tôi sẵn sàng hỗ trợ bạn mọi lúc!</p>
    </div>

    <div class="contact-content">
        <!-- Bản đồ bên trái -->
        <div class="map-box">
            <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3723.8448580229494!2d105.74267691540172!3d21.03929119287862!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31345389db72fd61%3A0x7482732efae84345!2zMiBLaeG7gW8gTWFpLCBOYW0gVMawIFLhuq1tLCBUaOG7pyDEkOG6qWkgSG_DoG5nLCBIw6AgTuG7mWkgMTAwMDAw!5e0!3m2!1svi!2s!4v1691112303999"
                    allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>

        <!-- Thông tin liên hệ bên phải -->
        <div class="info-box">
            <h4>Thông tin công ty</h4>
            <p><i class="fas fa-map-marker-alt"></i> Địa chỉ: Số 2 Kiều Mai, Nam Từ Liêm, Hà Nội</p>
            <p><i class="fas fa-phone-alt"></i> Điện thoại: 0867954111</p>
            <p><i class="fas fa-envelope"></i> Email: lienhe@MzShop.com</p>
            <p><i class="fas fa-globe"></i> Website: www.MzShop.com</p>
        </div>
    </div>
</div>

<!-- Font Awesome -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
