package com.example.banaomz.repository.admin;

import com.example.banaomz.dto.admin.sanPham.request.SanPhamChiTietDTO;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ISanPhamChiTietRepository extends IBaseRepository<SanPhamChiTiet, Long> {
    @Query("""
            select spct from SanPhamChiTiet spct
            where spct.soLuong > 0 
            and spct.sanPham.trangThai LIKE :sts%
            and (spct.sanPham.tenSanPham LIKE %:search% OR spct.maVach LIKE %:search%)
            order by spct.sanPham.ngayTao desc 
            """)
    List<SanPhamChiTiet> findLstSanPhamChiTiet(@Param("search") String value, @Param("sts") String sts);

    @Query("""
            select spct from SanPhamChiTiet spct 
            where spct.sanPham.id = :#{#dto.sanPhamId}
            and spct.size.id = :#{#dto.sizeId}
            and spct.mauSac.id = :#{#dto.mauSacId}
            """)
    Optional<SanPhamChiTiet> findSanPhamChiTietBySanPham(@Param("dto") SanPhamChiTietDTO dto);


}
