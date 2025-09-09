package com.example.banaomz.service.client;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.KhachHang;

import java.util.List;

public interface IHoaDonClientService {
    void taoHoaDonMember(List<GioHang> cart, KhachHang kh, String hoTen, String sdt, String diaChi);
    HoaDon taoHoaDonGuest(List<GioHang> cart, String hoTen, String sdt, String diaChi);
}

