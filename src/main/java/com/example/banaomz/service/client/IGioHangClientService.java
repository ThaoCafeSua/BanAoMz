package com.example.banaomz.service.client;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;

import java.util.List;

public interface IGioHangClientService {
    List<GioHang> layGioHang(KhachHang khachHang);

    GioHang themSanPham(KhachHang khachHang, SanPhamChiTiet spctInput, Integer soLuong);

    GioHang capNhatSoLuong(KhachHang khachHang, SanPhamChiTiet spctInput, Integer soLuong);

    void xoaSanPham(KhachHang khachHang, SanPhamChiTiet spctInput);

    void xoaToanBo(KhachHang khachHang);

    List<GioHang> getCartByKhachHang(Integer khachHangId);

    void clearCartByKhachHang(Integer khachHangId);
}
