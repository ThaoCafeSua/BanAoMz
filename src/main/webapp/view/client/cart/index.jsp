<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .cart-container {
        background-color: #f9f9f9;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 31, 61, 0.1);
    }

    .cart-header h5 {
        color: #001f3d;
        font-weight: 700;
        border-bottom: 2px solid #001f3d;
        padding-bottom: 10px;
    }

    #cart-items-container {
        min-height: 150px;
        padding: 20px;
        border: 1px dashed #ccc;
        border-radius: 6px;
        background-color: #fff;
    }

    .cart-summary {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 20px;
        border-top: 1px solid #001f3d;
        padding-top: 20px;
    }

    .cart-summary h5 {
        margin: 0;
        color: #001f3d;
        font-weight: 600;
    }

    .cart-summary .text-danger {
        font-size: 20px;
        font-weight: 700;
    }

    #check-out {
        background-color: #001f3d;
        border-color: #001f3d;
        font-weight: 600;
        padding: 10px 25px;
        border-radius: 30px;
        transition: all 0.3s ease;
    }

    #check-out:hover {
        background-color: #003366;
        border-color: #003366;
    }
</style>

<div class="container cart-container">
    <div class="cart-header mt-4 mb-2">
        <h5>Giỏ hàng của bạn</h5>
    </div>

    <!-- Cart -->
    <div class="my-4" id="cart-items-container">
        <!-- Các mặt hàng sẽ được hiển thị ở đây -->
    </div>

    <!-- Cart Summary -->
    <div class="cart-summary my-4">
        <h5>Tổng tiền: <span class="text-danger" id="total-amount">0₫</span></h5>
        <button class="btn btn-primary" id="check-out">Thanh toán</button>
    </div>
</div>
