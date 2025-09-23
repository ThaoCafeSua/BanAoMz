package com.example.banaomz.repository.admin;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.entity.admin.HoaDon;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface IHoaDonRepository extends JpaRepository<HoaDon, Long> {
    List<HoaDon> findAllByOrderByNgayTaoDesc();

    List<HoaDon> findByTrangThaiAndLoaiHoaDon(String trangThai, String loaiHoaDon);

    @Query("""
        select new com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO(
            h.id, h.maHoaDon, h.ngayDat,
            coalesce(kh.hoVaTen, h.tenNguoiNhan), 
            h.soDienThoaiNguoiNhan,
            h.diaChiNguoiNhan,
            h.thanhTien,
            h.trangThai,
            h.loaiHoaDon,
            h.phuongThucThanhToan
        )
        from HoaDon h
        left join h.khachHang kh
        where (:kw is null or :kw = '' or
              lower(h.maHoaDon) like lower(concat('%', :kw, '%')) or
              lower(coalesce(kh.hoVaTen, '')) like lower(concat('%', :kw, '%')) or
              lower(h.soDienThoaiNguoiNhan) like lower(concat('%', :kw, '%')))
          and (:status is null or :status = '' or h.trangThai = :status)
          and (:fromDate is null or h.ngayDat >= :fromDate)
          and (:toDate is null or h.ngayDat < :toDate)
        order by h.ngayDat desc
    """)
    Page<HoaDonResponseDTO> search(
            @Param("kw") String keyword,
            @Param("status") String status,
            @Param("fromDate") LocalDateTime fromDate,
            @Param("toDate") LocalDateTime toDate,
            Pageable pageable
    );

    @Query("""
    select new com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO(
        h.id, h.maHoaDon, h.ngayDat, h.trangThai,
        kh.hoVaTen,                 
        h.tenNguoiNhan,            
        h.soDienThoaiNguoiNhan,
        h.diaChiNguoiNhan,
        h.tongTien, h.tienGiam, h.phiVanChuyen, h.thanhTien,
        h.loaiHoaDon, h.phuongThucThanhToan
    )
    from HoaDon h
    left join h.khachHang kh
    where h.id = :id
""")
    Optional<HoaDonDetailResponseDTO> findDetail(@Param("id") Long id);

    @Query("""
        select coalesce(sum(h.thanhTien - coalesce(h.phiVanChuyen, 0)), 0)
        from HoaDon h
        where h.trangThai = :trangThai
          and h.ngayHoanThanh >= :start and h.ngayHoanThanh < :end
    """)
    BigDecimal sumThanhTienByTrangThaiAndNgayHoanThanhBetween(
            @Param("trangThai") String trangThai,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end
    );

    @Query("""
        select
          function('month', h.ngayHoanThanh) as m,
          coalesce(sum(h.thanhTien - coalesce(h.phiVanChuyen, 0)), 0) as doanhThu,
          coalesce(sum(ct.soLuong), 0) as soLuongBan
        from HoaDon h
          join h.hoaDonChiTietList ct
        where h.trangThai = :trangThai
          and function('year', h.ngayHoanThanh) = :year
        group by function('month', h.ngayHoanThanh)
        order by m
    """)
    List<Object[]> findMonthlyRevenueAndQty(
            @Param("year") int year,
            @Param("trangThai") String trangThai
    );


    List<HoaDon> findByKhachHangIdAndTrangThai(Long khachHangId, String trangThai);

    Page<HoaDon> findByKhachHangId(Long khachHangId, Pageable pageable);

    Page<HoaDon> findByKhachHangIdAndTrangThai(Long khachHangId, String trangThai, Pageable pageable);


    @Query("SELECT h FROM HoaDon h WHERE h.khachHang.id = :customerId AND h.loaiHoaDon = 'ONLINE'")
    List<HoaDon> findByKhachHangId(@Param("customerId") Long customerId);


}

