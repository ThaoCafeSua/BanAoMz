package com.example.banaomz.service.client.Impl;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.admin.SanPhamChiTiet;

import com.example.banaomz.repository.client.HoaDonChiTietClientRepository;
import com.example.banaomz.repository.client.HoaDonClientRepository;
import com.example.banaomz.repository.client.ISanPhamClientRepository;
import com.example.banaomz.repository.client.SanPhamChiTietClientRepository;
import com.example.banaomz.service.client.IHoaDonClientService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class HoaDonClientServiceImpl implements IHoaDonClientService {

    private final HoaDonClientRepository hoaDonRepository;
    private final HoaDonChiTietClientRepository hoaDonChiTietRepository;
    private final SanPhamChiTietClientRepository spctRepository;
    private final ISanPhamClientRepository sanPhamRepository;

    public HoaDonClientServiceImpl(HoaDonClientRepository hoaDonRepository,
                                   HoaDonChiTietClientRepository hoaDonChiTietRepository,
                                   SanPhamChiTietClientRepository spctRepository,
                                   ISanPhamClientRepository sanPhamRepository) {
        this.hoaDonRepository = hoaDonRepository;
        this.hoaDonChiTietRepository = hoaDonChiTietRepository;
        this.spctRepository = spctRepository;
        this.sanPhamRepository = sanPhamRepository;
    }

    @Override
    public void taoHoaDonMember(List<GioHang> cart, KhachHang kh, String hoTen, String sdt, String diaChi) {
        if (cart == null || cart.isEmpty()) throw new IllegalStateException("Giỏ hàng trống");
        if (kh == null) throw new IllegalArgumentException("Khách hàng null");

        HoaDon hoaDon = baseHoaDon(hoTen, sdt, diaChi);
        hoaDon.setKhachHang(kh);
        hoaDon = hoaDonRepository.save(hoaDon);

        BigDecimal tongTien = processChiTietAndUpdateStock(cart, hoaDon);
        finalizeHoaDonTotals(hoaDon, tongTien);
    }

    @Override
    public void taoHoaDonGuest(List<GioHang> cart, String hoTen, String sdt, String diaChi) {
        if (cart == null || cart.isEmpty()) throw new IllegalStateException("Giỏ hàng trống");

        HoaDon hoaDon = baseHoaDon(hoTen, sdt, diaChi);
        hoaDon = hoaDonRepository.save(hoaDon);

        BigDecimal tongTien = processChiTietAndUpdateStock(cart, hoaDon);
        finalizeHoaDonTotals(hoaDon, tongTien);
    }

    /* ================== Helpers ================== */

    private BigDecimal processChiTietAndUpdateStock(List<GioHang> cart, HoaDon hoaDon) {
        List<HoaDonChiTiet> ctList = new ArrayList<>();
        BigDecimal tongTien = BigDecimal.ZERO;

        for (GioHang g : cart) {
            SanPhamChiTiet spct = loadForCheckout(g);
            int req = nonNull(g.getSoLuong());
            checkStock(spct, req);

            // Trừ kho
            spct.setSoLuong(spct.getSoLuong() - req);
            spctRepository.save(spct);

            // Cập nhật so_luong_da_ban cho sản phẩm cha
            SanPham sp = spct.getSanPham();
            if (sp != null) {
                Integer sold = sp.getSoLuongDaBan() == null ? 0 : sp.getSoLuongDaBan();
                sp.setSoLuongDaBan(sold + req);
                sanPhamRepository.save(sp);
            }

            BigDecimal donGia = big(spct.getGiaBan());
            BigDecimal thanhTien = donGia.multiply(BigDecimal.valueOf(req));

            HoaDonChiTiet c = new HoaDonChiTiet();
            c.setHoaDon(hoaDon);
            c.setSanPhamChiTiet(spct);
            c.setGiaBan(donGia);
            c.setGiaGoc(donGia);         // TODO: nếu có giá gốc riêng, map lại
            c.setGiaGiam(BigDecimal.ZERO);
            c.setSoLuong(req);
            c.setMoTa("Bán online");
            c.setNgayTao(LocalDateTime.now());
            ctList.add(c);

            tongTien = tongTien.add(thanhTien);
        }

        hoaDonChiTietRepository.saveAll(ctList);
        return tongTien;
    }

    private void finalizeHoaDonTotals(HoaDon hoaDon, BigDecimal tongTien) {
        BigDecimal tienGiam = BigDecimal.ZERO;  // TODO: áp mã giảm nếu có
        BigDecimal phiShip = BigDecimal.ZERO;   // TODO: tính phí ship nếu có
        BigDecimal thanhTien = tongTien.subtract(tienGiam).add(phiShip);

        hoaDon.setTongTien(tongTien);
        hoaDon.setTienGiam(tienGiam);
        hoaDon.setPhiVanChuyen(phiShip);
        hoaDon.setThanhTien(thanhTien);
        hoaDon.setTrangThai("CHO_XAC_NHAN");
        hoaDon.setNgaySua(LocalDateTime.now());
        hoaDonRepository.save(hoaDon);
    }

    private HoaDon baseHoaDon(String hoTen, String sdt, String diaChi) {
        HoaDon h = new HoaDon();
        h.setMaHoaDon(genCode());
        h.setPhuongThucThanhToan("COD"); // TODO: map theo input thực tế
        h.setLoaiHoaDon("ONLINE");
        h.setHinhThucHoaDon("BAN_LE");
        h.setDiaChiNguoiNhan(diaChi);
        h.setTenNguoiNhan(hoTen);
        h.setSoDienThoaiNguoiNhan(sdt);
        h.setNgayDat(LocalDateTime.now());
        h.setTrangThai("KHOI_TAO");
        h.setNgayTao(LocalDateTime.now());
        return h;
    }

    private String genCode() {
        return "HD" + System.currentTimeMillis();
    }

    private SanPhamChiTiet loadForCheckout(GioHang g) {
        if (g == null || g.getSanPhamChiTiet() == null || g.getSanPhamChiTiet().getId() == null) {
            throw new IllegalArgumentException("Giỏ hàng lỗi: thiếu SPCT");
        }
        Long id = g.getSanPhamChiTiet().getId(); // giữ nguyên Long
        return spctRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy SPCT id=" + id));
    }


    private void checkStock(SanPhamChiTiet spct, int req) {
        int ton = spct.getSoLuong() == null ? 0 : spct.getSoLuong();
        if (req <= 0) throw new IllegalArgumentException("Số lượng không hợp lệ");
        if (req > ton) throw new IllegalStateException("Không đủ hàng trong kho");
    }

    private int nonNull(Integer n) { return n == null ? 0 : n; }

    private BigDecimal big(Number n) {
        if (n == null) return BigDecimal.ZERO;
        if (n instanceof BigDecimal) {
            return (BigDecimal) n;
        }
        if (n instanceof Byte || n instanceof Short || n instanceof Integer || n instanceof Long) {
            return BigDecimal.valueOf(n.longValue());
        }
        return BigDecimal.valueOf(n.doubleValue());
    }
}