package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.HoaDonChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IHoaDonChiTietRepository extends JpaRepository<HoaDonChiTiet, Long> {
    // ✅ Dùng để kiểm tra sản phẩm đã có trong hóa đơn hay chưa
    Optional<HoaDonChiTiet> findByHoaDon_IdAndSanPhamChiTiet_Id(Long idHoaDon, Long idSanPhamChiTiet);

    // ✅ Lấy danh sách chi tiết theo hóa đơn
    List<HoaDonChiTiet> findByHoaDonId(Long idHoaDon);
}
