package com.example.banaomz.dto.admin.HoaDon.Request;

import com.example.banaomz.dto.admin.HoaDonChiTiet.Request.HoaDonChiTietRequestDTO;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
public class HoaDonRequestDTO {
    private Long idKhachHang;
    private Long idNhanVien;
    private Long idPhieuGiamGia;
    private String hinhThucThanhToan;
    private String loaiHoaDon;
    private String hinhThucHoaDon;
    private String diaChiNguoiNhan;
    private String tenNguoiNhan;
    private String soDienThoaiNguoiNhan;
    private BigDecimal phiVanChuyen;
    private String moTa;
    private List<HoaDonChiTietRequestDTO> chiTietHoaDon;
}
