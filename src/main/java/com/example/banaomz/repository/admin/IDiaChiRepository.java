package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.DiaChi;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IDiaChiRepository extends IBaseRepository<DiaChi,Long> {
    @Query("""
        SELECT dc FROM DiaChi dc 
        WHERE dc.khachHang.id = :idCustomer 
        ORDER BY dc.ngayTao DESC
    """)
    List<DiaChi> findDiaChiByCustomer(@Param("idCustomer") Long idCustomer);

    @Query(value = """
            SELECT TOP 1 * 
            FROM dia_chi 
            WHERE id_khach_hang = :khId AND dia_chi_mac_dinh = 1
            ORDER BY ngay_sua DESC, ngay_tao DESC
            """, nativeQuery = true)
    Optional<DiaChi> findDefaultByKhachHangId(@Param("khId") Long khId);

    // Phòng khi KH chưa tick mặc định: lấy địa chỉ "tốt nhất" (mặc định nếu có,
    // nếu không thì địa chỉ cập nhật gần nhất)
    @Query(value = """
            SELECT TOP 1 * 
            FROM dia_chi 
            WHERE id_khach_hang = :khId
            ORDER BY CASE WHEN dia_chi_mac_dinh = 1 THEN 0 ELSE 1 END,
                     ngay_sua DESC, ngay_tao DESC
            """, nativeQuery = true)
    Optional<DiaChi> findPreferredByKhachHangId(@Param("khId") Long khId);

}
