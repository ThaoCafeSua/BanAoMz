package com.example.banaomz.service.client.Impl;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.repository.client.HoaDonClientRepository;
import com.example.banaomz.repository.client.HoaDonChiTietClientRepository;
import com.example.banaomz.service.client.IHoaDonClientService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class HoaDonClientServiceImpl implements IHoaDonClientService {

    private final HoaDonClientRepository hoaDonRepo;
    private final HoaDonChiTietClientRepository hdctRepo;

    public HoaDonClientServiceImpl(HoaDonClientRepository hoaDonRepo,
                                   HoaDonChiTietClientRepository hdctRepo) {
        this.hoaDonRepo = hoaDonRepo;
        this.hdctRepo = hdctRepo;
    }

    @Override
    public void taoHoaDonMember(List<GioHang> cart, KhachHang kh, String hoTen, String sdt, String diaChi) {
        // 1. Tạo hóa đơn
        HoaDon hd = new HoaDon();
        hd.setKhachHang(kh);
        hd.setTenNguoiNhan(hoTen);
        hd.setSoDienThoaiNguoiNhan(sdt);
        hd.setDiaChiNguoiNhan(diaChi);
        hd.setNgayTao(LocalDateTime.now());
        hd.setTrangThai("CHO_XAC_NHAN");
        hd = hoaDonRepo.save(hd);

        // 2. Thêm chi tiết
        for (GioHang g : cart) {
            HoaDonChiTiet ct = new HoaDonChiTiet();
            ct.setHoaDon(hd);
            ct.setSanPhamChiTiet(g.getSanPhamChiTiet());
            ct.setSoLuong(g.getSoLuong());
            ct.setGiaGoc(g.getSanPhamChiTiet().getGiaBan()); // hoặc ct.setDonGia(...) nếu entity của bạn có field này
            hdctRepo.save(ct);
        }
    }

    @Override
    public HoaDon taoHoaDonGuest(List<GioHang> cart, String hoTen, String sdt, String diaChi) {
        HoaDon hd = new HoaDon();
        hd.setTenNguoiNhan(hoTen);
        hd.setSoDienThoaiNguoiNhan(sdt);
        hd.setDiaChiNguoiNhan(diaChi);
        hd.setNgayTao(LocalDateTime.now());
        hd.setTrangThai("CHO_XAC_NHAN");

        HoaDon saved = hoaDonRepo.save(hd);

        // 2. Thêm chi tiết
        for (GioHang g : cart) {
            HoaDonChiTiet ct = new HoaDonChiTiet();
            ct.setHoaDon(saved);
            ct.setSanPhamChiTiet(g.getSanPhamChiTiet());
            ct.setSoLuong(g.getSoLuong());
            ct.setGiaGoc(g.getSanPhamChiTiet().getGiaBan());
            hdctRepo.save(ct);
        }

        return saved;
    }
}
