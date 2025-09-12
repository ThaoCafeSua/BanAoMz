package com.example.banaomz.dto.admin.HoaDon.Reponse;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
public class HoaDonDetailResponseDTO {
    private Long id;
    private String maHoaDon;
    private LocalDateTime ngayDat;
    private String trangThai;

    private String khachHangTen;
    private String tenNguoiNhan;
    private String soDienThoaiNguoiNhan;
    private String diaChiNguoiNhan;

    private BigDecimal tongTien;
    private BigDecimal tienGiam;
    private BigDecimal phiVanChuyen;
    private BigDecimal thanhTien;

    private String loaiHoaDon;
    private String phuongThucThanhToan;

    // Constructor JPQL sẽ gọi
    public HoaDonDetailResponseDTO(Number id,
                                   String maHoaDon,
                                   LocalDateTime ngayDat,
                                   String trangThai,
                                   String khachHangTen,
                                   String tenNguoiNhan,
                                   String soDienThoaiNguoiNhan,
                                   String diaChiNguoiNhan,
                                   BigDecimal tongTien,
                                   BigDecimal tienGiam,
                                   BigDecimal phiVanChuyen,
                                   BigDecimal thanhTien,
                                   String loaiHoaDon,
                                   String phuongThucThanhToan) {
        this.id = (id == null) ? null : id.longValue();
        this.maHoaDon = maHoaDon;
        this.ngayDat = ngayDat;
        this.trangThai = trangThai;
        this.khachHangTen = khachHangTen;
        this.tenNguoiNhan = tenNguoiNhan;
        this.soDienThoaiNguoiNhan = soDienThoaiNguoiNhan;
        this.diaChiNguoiNhan = diaChiNguoiNhan;
        this.tongTien = tongTien;
        this.tienGiam = tienGiam;
        this.phiVanChuyen = phiVanChuyen;
        this.thanhTien = thanhTien;
        this.loaiHoaDon = loaiHoaDon;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }
}