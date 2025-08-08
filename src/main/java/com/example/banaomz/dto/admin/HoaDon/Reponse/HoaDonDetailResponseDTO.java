package com.example.banaomz.dto.admin.HoaDon.Reponse;

import com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse.HoaDonChiTietResponseDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HoaDonDetailResponseDTO {
    private Long id;
    private String maHoaDon;
    private String loaiHoaDon;
    private String hinhThucHoaDon;
    private String phuongThucThanhToan;
    private String trangThai;
    private String moTa;
    private String tenKhachHang;
    private String tenNhanVien;

    private String tenNguoiNhan;
    private String soDienThoaiNguoiNhan;
    private String diaChiNguoiNhan;

    private BigDecimal tongTien;
    private BigDecimal tienGiam;
    private BigDecimal phiVanChuyen;
    private BigDecimal thanhTien;

    private String ngayDat;
    private String ngayGiao;
    private String ngayHoanThanh;

    private List<HoaDonChiTietResponseDTO> chiTietSanPhamList;
}
