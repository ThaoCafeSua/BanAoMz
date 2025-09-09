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
<script>
    let cart = JSON.parse(localStorage.getItem("cart")) || [];

    // Render giỏ hàng
    function renderCart() {
        let container = document.getElementById("cart-items-container");
        if (cart.length === 0) {
            container.innerHTML = "<p class='text-center text-muted'>Giỏ hàng trống</p>";
            document.getElementById("total-amount").innerText = "0₫";
            return;
        }

        let html = `
            <table class="table table-bordered align-middle text-center">
                <thead class="table-light">
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Xóa</th>
                    </tr>
                </thead>
                <tbody>
        `;

        let total = 0;
        cart.forEach((item, idx) => {
            let thanhTien = item.gia * item.soLuong;
            total += thanhTien;
            html += `
                <tr>
                    <td><img src="${item.anh}" width="60"></td>
                    <td>${item.ten}</td>
                    <td>${item.gia.toLocaleString()}₫</td>
                    <td>
                        <input type="number" min="1" value="${item.soLuong}"
                            onchange="updateQuantity(${idx}, this.value)"
                            class="form-control w-50 mx-auto">
                    </td>
                    <td>${thanhTien.toLocaleString()}₫</td>
                    <td><button class="btn btn-sm btn-danger" onclick="removeItem(${idx})">Xóa</button></td>
                </tr>
            `;
        });

        html += `</tbody></table>`;
        container.innerHTML = html;
        document.getElementById("total-amount").innerText = total.toLocaleString() + "₫";
    }

    // Cập nhật số lượng
    function updateQuantity(index, soLuong) {
        cart[index].soLuong = parseInt(soLuong);
        localStorage.setItem("cart", JSON.stringify(cart));
        renderCart();
    }

    // Xóa sản phẩm
    function removeItem(index) {
        cart.splice(index, 1);
        localStorage.setItem("cart", JSON.stringify(cart));
        renderCart();
    }

    // Chuyển sang trang thanh toán
    document.getElementById("check-out").addEventListener("click", function() {
        if (cart.length === 0) {
            alert("Giỏ hàng trống, không thể thanh toán!");
            return;
        }
        window.location.href = "/checkout"; // sang trang checkout.jsp
    });

    renderCart();
</script>

