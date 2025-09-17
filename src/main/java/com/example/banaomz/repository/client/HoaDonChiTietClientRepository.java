package com.example.banaomz.repository.client;

import com.example.banaomz.entity.admin.HoaDonChiTiet;
import com.example.banaomz.entity.admin.HoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface HoaDonChiTietClientRepository extends JpaRepository<HoaDonChiTiet, Integer> {

    // Lấy chi tiết hóa đơn theo hóa đơn
    List<HoaDonChiTiet> findByHoaDon(HoaDon hoaDon);
}
