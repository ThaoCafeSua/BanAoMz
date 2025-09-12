package com.example.banaomz.repository.client;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GioHangClientRepository extends JpaRepository<GioHang, Integer> {
    List<GioHang> findAllByKhachHang(KhachHang khachHang);
    List<GioHang> findAllByKhachHangId(Integer khachHangId);

    Optional<GioHang> findByKhachHangAndSanPhamChiTiet(KhachHang khachHang, SanPhamChiTiet spct);

    void deleteByKhachHang(KhachHang khachHang);
    void deleteByKhachHangId(Integer khachHangId);
    void deleteByKhachHangAndSanPhamChiTiet_Id(KhachHang khachHang, Long spctId);

}
