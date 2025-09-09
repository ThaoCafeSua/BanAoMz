package com.example.banaomz.repository.client;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GioHangClientRepository extends JpaRepository<GioHang, Integer> {
    List<GioHang> findByKhachHang(KhachHang khachHang);

    Optional<GioHang> findByKhachHangAndSanPhamChiTiet(KhachHang khachHang, SanPhamChiTiet spct);

    void deleteByKhachHangAndSanPhamChiTiet(KhachHang khachHang, SanPhamChiTiet spct);

    List<GioHang> findByKhachHangId(Long idKhachHang);

    void deleteByKhachHangId(Long idKhachHang);
}
