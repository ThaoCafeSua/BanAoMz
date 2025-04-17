package com.example.banaomz.dto.admin.order;

import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.entity.admin.PhieuGiamGia;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderBillDTO {
    private Long id;

    private String maHoaDon;

    private KhachHang khachHang;

    private NhanVien nhanVien;

    private PhieuGiamGia phieuGiamGia;

    private String phuongThucThanhToan;

    private String loaiHoaDon;

    private String hinhThucHoaDon;

    private BigDecimal tongTien;

    private BigDecimal tienGiam;

    private BigDecimal phiVanChuyen;

    private BigDecimal thanhTien;

    private Date ngayDat;

    private Date ngayGiao;

    private Date ngayHoanThanh;

    private String tenNguoiNhan;

    private String soDienThoaiNguoiNhan;

    private String diaChiNguoiNhan;

    private String trangThai;

    private String moTa;

    private Set<OrderBillDetailDTO> lstHoaDonChiTiet;

    private Set<OrderHistoryBillDetailDTO> lstLichSuHoaDon;

    private Set<OrderHistoryPaymentBillDetailDTO> lstLichSuThanhToan;
}
