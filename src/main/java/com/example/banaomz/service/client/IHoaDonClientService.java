package com.example.banaomz.service.client;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;

import java.math.BigDecimal;
import java.util.List;

public interface IHoaDonClientService {

    // Giữ tương thích cũ: gọi sang bản mới với ship = 0
    default void taoHoaDonMember(List<GioHang> cart, KhachHang kh, String hoTen, String sdt, String diaChi) {
        taoHoaDonMember(cart, kh, hoTen, sdt, diaChi,
                BigDecimal.ZERO, null, null, null, null, null, null, null);
    }

    default void taoHoaDonGuest(List<GioHang> cart, String hoTen, String sdt, String diaChi) {
        taoHoaDonGuest(cart, hoTen, sdt, diaChi,
                BigDecimal.ZERO, null, null, null, null, null, null, null);
    }

    // Bản mới có tham số vận chuyển (GHN)
    void taoHoaDonMember(List<GioHang> cart, KhachHang kh,
                         String hoTen, String sdt, String diaChi,
                         BigDecimal shipFee, Long shipServiceId, Integer toDistrictId, String toWardCode,
                         Integer weight, Integer length, Integer width, Integer height);

    void taoHoaDonGuest(List<GioHang> cart,
                        String hoTen, String sdt, String diaChi,
                        BigDecimal shipFee, Long shipServiceId, Integer toDistrictId, String toWardCode,
                        Integer weight, Integer length, Integer width, Integer height);


    void huyDonHangByCustomer(Long orderId, Long khachHangId);
}
