package com.example.banaomz.dto.admin.order;

import com.example.banaomz.entity.admin.KhachHang;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
public class OrderBillListDTO {
    private Long id;

    private String maHoaDon;

    private KhachHang khachHang;

    private String phuongThucThanhToan;

    private String loaiHoaDon;

    private String hinhThucHoaDon;

    private BigDecimal tongTien;

    private BigDecimal tienGiam;

    private BigDecimal phiVanChuyen;

    private BigDecimal thanhTien;

    private LocalDateTime ngayDat;

    private LocalDateTime ngayGiao;

    private LocalDateTime ngayHoanThanh;

    private String tenNguoiNhan;

    private String soDienThoaiNguoiNhan;

    private String diaChiNguoiNhan;

    private String trangThai;

    private String moTa;

}
