package com.example.banaomz.repository.client;

import com.example.banaomz.entity.admin.HoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HoaDonClientRepository extends JpaRepository<HoaDon, Integer> {

    // Lấy danh sách hóa đơn theo khách hàng (dùng cho user login)
    List<HoaDon> findByKhachHang_Id(Long id);

    // Lấy hóa đơn theo trạng thái (ví dụ: CHO_XAC_NHAN, DA_THANH_TOAN...)
    List<HoaDon> findByTrangThai(String trangThai);

    Optional<HoaDon> findByIdAndKhachHangId(Long id, Long khachHangId);
}
