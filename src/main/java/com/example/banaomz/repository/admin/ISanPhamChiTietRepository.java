package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.MauSac;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.entity.admin.Size;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ISanPhamChiTietRepository extends IBaseRepository<SanPhamChiTiet, Long> {
    @Query("""
        select spct
        from SanPhamChiTiet spct
        where spct.soLuong > 0
          and spct.trangThai = :status
          and spct.sanPham.tenSanPham like concat('%', :search, '%')
        order by spct.sanPham.ngayTao desc
    """)
    List<SanPhamChiTiet> findLstSanPhamChiTiet(
            @Param("search") String search,
            @Param("status") String status
    );

    @Query("""
        select spct
        from SanPhamChiTiet spct
        where spct.sanPham.id = :sanPhamId
          and spct.size.id     = :sizeId
          and spct.mauSac.id   = :mauSacId
    """)
    Optional<SanPhamChiTiet> findSanPhamChiTietBySanPham(
            @Param("sanPhamId") Long sanPhamId,
            @Param("sizeId") Long sizeId,
            @Param("mauSacId") Long mauSacId
    );

    List<SanPhamChiTiet> findBySanPham_Id(Long idSanPham);

    Optional<SanPhamChiTiet> findBySanPham_IdAndMauSac_IdAndSize_IdAndTrangThai(
            Long idSanPham,
            Long idMauSac,
            Long idSize,
            String trangThai
    );

    @Query("SELECT DISTINCT s.mauSac FROM SanPhamChiTiet s WHERE s.sanPham.id = :idSanPham")
    List<MauSac> findDistinctMauSacBySanPhamId(@Param("idSanPham") Long idSanPham);

    @Query("SELECT DISTINCT s.size FROM SanPhamChiTiet s WHERE s.sanPham.id = :idSanPham")
    List<Size> findDistinctSizeBySanPhamId(@Param("idSanPham") Long idSanPham);

    @Query("""
        select spct
        from SanPhamChiTiet spct
        where spct.trangThai          = :trangThai
          and spct.sanPham.trangThai = 'HOAT_DONG'
    """)
    List<SanPhamChiTiet> findByTrangThaiAndSanPhamHoatDong(
            @Param("trangThai") String trangThai
    );

    @Query("SELECT COALESCE(SUM(spct.soLuong), 0) FROM SanPhamChiTiet spct")
    Long sumAllStock();
    @Query("select coalesce(sum(coalesce(s.soLuong,0)), 0) from SanPhamChiTiet s")
    Integer sumSoLuongTon();
}
