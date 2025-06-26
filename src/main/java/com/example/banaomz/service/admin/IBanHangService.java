package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamTaiQuayViewModel;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;

import java.util.List;

public interface  IBanHangService {
    HoaDon taoHoaDonMoi(Long idNhanVien, Long idKhachHang);

    HoaDonChiTiet themSanPhamVaoHoaDon(Long idHoaDon, Long idSPCT, int soLuong);

    boolean  capNhatSoLuong(Long idHDCT, int soLuongMoi);

    void xoaSanPhamKhoiHoaDon(Long idHDCT);

    HoaDon hoanTatHoaDon(Long idHoaDon, Long idPhieuGiamGia, String phuongThucTT);

    List<HoaDonChiTiet> layDanhSachSanPhamTrongHoaDon(Long idHoaDon);

    List<SanPhamTaiQuayViewModel> layDanhSachSanPhamGoc();
    List<MauSacDTO> getMauSacBySanPham(Long idSanPham);
    List<SizeDTO> getSizeBySanPham(Long idSanPham);
    boolean tonTaiHoaDon(Long idHoaDon);
}
