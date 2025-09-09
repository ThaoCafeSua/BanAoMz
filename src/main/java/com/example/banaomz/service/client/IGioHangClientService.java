package com.example.banaomz.service.client;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;

import java.util.List;

public interface IGioHangClientService {
    List<GioHang> layGioHang(KhachHang khachHang);

    GioHang themSanPham(KhachHang khachHang, SanPhamChiTiet spct, int soLuong);

    GioHang capNhatSoLuong(KhachHang khachHang, SanPhamChiTiet spct, int soLuong);

    void xoaSanPham(KhachHang khachHang, SanPhamChiTiet spct);

    void xoaToanBo(KhachHang khachHang);

    List<GioHang> getCartByKhachHang(Long idKhachHang);

    void clearCartByKhachHang(Long idKhachHang);
}
