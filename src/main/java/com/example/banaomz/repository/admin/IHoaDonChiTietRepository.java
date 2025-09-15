package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.HoaDonChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IHoaDonChiTietRepository extends JpaRepository<HoaDonChiTiet, Long> {
    // ✅ Dùng để kiểm tra sản phẩm đã có trong hóa đơn hay chưa
    Optional<HoaDonChiTiet> findByHoaDon_IdAndSanPhamChiTiet_Id(Long idHoaDon, Long idSanPhamChiTiet);

    // ✅ Lấy danh sách chi tiết theo hóa đơn
    List<HoaDonChiTiet> findByHoaDonId(Long idHoaDon);


    @Query(value = """
           SELECT MONTH(hd.ngay_hoan_thanh) AS m,
                  COALESCE(SUM(hd.thanh_tien), 0) AS revenue,
                  COALESCE(SUM(ct.so_luong), 0)   AS qty
           FROM hoa_don_chi_tiet ct
           JOIN hoa_don hd ON ct.id_hoa_don = hd.id
           WHERE hd.trang_thai = 'HOAN_THANH' AND YEAR(hd.ngay_hoan_thanh) = :year
           GROUP BY MONTH(hd.ngay_hoan_thanh)
           ORDER BY m
           """, nativeQuery = true)
    List<Object[]> aggregateMonthly(@Param("year") int year);
}
