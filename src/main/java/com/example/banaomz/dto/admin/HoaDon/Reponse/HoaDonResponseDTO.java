package com.example.banaomz.dto.admin.HoaDon.Reponse;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
public class HoaDonResponseDTO {
    private Long id;
    private String maHoaDon;
    private LocalDateTime ngayDat;
    private String khachHangTen;
    private String soDienThoai;
    private String diaChi;
    private BigDecimal thanhTien;
    private String trangThai;
    private String loaiHoaDon;
    private String phuongThucThanhToan;

    // ✅ Constructor Hibernate (JPQL) sẽ gọi – chấp nhận Integer/Long/Number
    public HoaDonResponseDTO(Number id,
                             String maHoaDon,
                             LocalDateTime ngayDat,
                             String khachHangTen,
                             String soDienThoai,
                             String diaChi,
                             BigDecimal thanhTien,
                             String trangThai,
                             String loaiHoaDon,
                             String phuongThucThanhToan) {
        this.id = (id == null) ? null : id.longValue();
        this.maHoaDon = maHoaDon;
        this.ngayDat = ngayDat;
        this.khachHangTen = khachHangTen;
        this.soDienThoai = soDienThoai;
        this.diaChi = diaChi;
        this.thanhTien = thanhTien;
        this.trangThai = trangThai;
        this.loaiHoaDon = loaiHoaDon;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }
}
