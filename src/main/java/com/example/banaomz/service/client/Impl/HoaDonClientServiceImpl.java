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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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

    /* ================== HELPERS ================== */

    /** Ghép địa chỉ đầy đủ theo format: "chi tiết, Xã/Phường, Quận/Huyện, Tỉnh/Thành phố" (bỏ qua phần null/blank). */
    private static String buildFullAddress(String detail, String xa, String huyen, String tinh) {
        StringBuilder sb = new StringBuilder();
        if (detail != null && !detail.isBlank()) sb.append(detail.trim());
        if (xa != null && !xa.isBlank()) { if (sb.length() > 0) sb.append(", "); sb.append(xa.trim()); }
        if (huyen != null && !huyen.isBlank()) { if (sb.length() > 0) sb.append(", "); sb.append(huyen.trim()); }
        if (tinh != null && !tinh.isBlank()) { if (sb.length() > 0) sb.append(", "); sb.append(tinh.trim()); }
        return sb.toString();
    }

    /* ================== BẢN CŨ (giữ tương thích) ================== */
    @Override
    public void taoHoaDonMember(List<GioHang> cart, KhachHang kh, String hoTen, String sdt, String diaChi) {
        // gọi sang bản mới với shipFee = 0 và không có xa/huyện/tỉnh
        taoHoaDonMember(cart, kh, hoTen, sdt, diaChi, null, null, null,
                BigDecimal.ZERO, null, null, null, null, null, null, null);
    }

    @Override
    public void taoHoaDonGuest(List<GioHang> cart, String hoTen, String sdt, String diaChi) {
        // gọi sang bản mới với shipFee = 0 và không có xa/huyện/tỉnh
        taoHoaDonGuest(cart, hoTen, sdt, diaChi, null, null, null,
                BigDecimal.ZERO, null, null, null, null, null, null, null);
    }

    /* ================== BẢN MỚI (có ship) ==================
       Giữ method hiện có (không có xa/huyện/tỉnh) để tương thích, sẽ gọi overload có đủ địa chỉ.
    */
    @Override
    public void taoHoaDonMember(List<GioHang> cart, KhachHang kh,
                                String hoTen, String sdt, String diaChi,
                                BigDecimal shipFee, Long shipServiceId, Integer toDistrictId, String toWardCode,
                                Integer weight, Integer length, Integer width, Integer height) {
        // chuyển tiếp sang overload có đủ phần địa chỉ; tạm không có xa/huyện/tỉnh
        taoHoaDonMember(cart, kh, hoTen, sdt, diaChi, null, null, null,
                shipFee, shipServiceId, toDistrictId, toWardCode, weight, length, width, height);
    }

    @Override
    public void taoHoaDonGuest(List<GioHang> cart,
                               String hoTen, String sdt, String diaChi,
                               BigDecimal shipFee, Long shipServiceId, Integer toDistrictId, String toWardCode,
                               Integer weight, Integer length, Integer width, Integer height) {
        // chuyển tiếp sang overload có đủ phần địa chỉ; tạm không có xa/huyện/tỉnh
        taoHoaDonGuest(cart, hoTen, sdt, diaChi, null, null, null,
                shipFee, shipServiceId, toDistrictId, toWardCode, weight, length, width, height);
    }

    /* ================== OVERLOAD MỚI (NHẬN THÊM XA/HUYỆN/TỈNH) ==================
       => DÙNG HÀM NÀY KHI BẠN ĐÃ LẤY ĐƯỢC TÊN "xa/huyen/tinh" TỪ GHN HOẶC FORM.
    */
    public void taoHoaDonMember(List<GioHang> cart, KhachHang kh,
                                String hoTen, String sdt, String diaChiChiTiet, String xa, String huyen, String tinh,
                                BigDecimal shipFee, Long shipServiceId, Integer toDistrictId, String toWardCode,
                                Integer weight, Integer length, Integer width, Integer height) {

        if (cart == null || cart.isEmpty()) throw new IllegalStateException("Giỏ hàng trống");
        if (kh == null) throw new IllegalArgumentException("Khách hàng null");

        String fullAddr = buildFullAddress(diaChiChiTiet, xa, huyen, tinh);

        HoaDon hoaDon = baseHoaDon(hoTen, sdt, fullAddr);
        hoaDon.setKhachHang(kh);
        hoaDon = hoaDonRepository.save(hoaDon);

        BigDecimal tongTien = processChiTietAndUpdateStock(cart, hoaDon);
        finalizeHoaDonTotals(hoaDon, tongTien, nvl(shipFee));

        // (tuỳ) lưu metadata GHN nếu bạn có cột trong bảng HoaDon
        // hoaDon.setGhnServiceId(shipServiceId); ...
        // hoaDonRepository.save(hoaDon);
    }

    public void taoHoaDonGuest(List<GioHang> cart,
                               String hoTen, String sdt, String diaChiChiTiet, String xa, String huyen, String tinh,
                               BigDecimal shipFee, Long shipServiceId, Integer toDistrictId, String toWardCode,
                               Integer weight, Integer length, Integer width, Integer height) {

        if (cart == null || cart.isEmpty()) throw new IllegalStateException("Giỏ hàng trống");

        String fullAddr = buildFullAddress(diaChiChiTiet, xa, huyen, tinh);

        HoaDon hoaDon = baseHoaDon(hoTen, sdt, fullAddr);
        hoaDon = hoaDonRepository.save(hoaDon);

        BigDecimal tongTien = processChiTietAndUpdateStock(cart, hoaDon);
        finalizeHoaDonTotals(hoaDon, tongTien, nvl(shipFee));

        // (tuỳ) lưu metadata GHN nếu có
        // hoaDon.setGhnServiceId(shipServiceId); ...
        // hoaDonRepository.save(hoaDon);
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

            // Cộng đã bán cho SP cha
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
            c.setGiaGoc(donGia);         // nếu có giá gốc riêng thì map lại
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

    // CHANGED: nhận thêm phiShip
    private void finalizeHoaDonTotals(HoaDon hoaDon, BigDecimal tongTien, BigDecimal phiShip) {
        BigDecimal tienGiam = BigDecimal.ZERO;  // TODO: áp mã giảm nếu có
        BigDecimal thanhTien = tongTien.subtract(tienGiam).add(nvl(phiShip));

        hoaDon.setTongTien(tongTien);
        hoaDon.setTienGiam(tienGiam);
        hoaDon.setPhiVanChuyen(nvl(phiShip));
        hoaDon.setThanhTien(thanhTien);

        // Trạng thái online mới tạo -> CHO_XAC_NHAN
        hoaDon.setTrangThai("CHO_XAC_NHAN");
        hoaDon.setNgaySua(LocalDateTime.now());
        hoaDonRepository.save(hoaDon);
    }

    private HoaDon baseHoaDon(String hoTen, String sdt, String fullAddress) {
        HoaDon h = new HoaDon();
        h.setMaHoaDon(genCode());
        h.setPhuongThucThanhToan("COD"); // hoặc map theo lựa chọn của khách
        h.setLoaiHoaDon("ONLINE");
        h.setHinhThucHoaDon("BAN_LE");
        h.setDiaChiNguoiNhan(fullAddress); // <-- ĐÃ GHÉP ĐỊA CHỈ ĐẦY ĐỦ
        h.setTenNguoiNhan(hoTen);
        h.setSoDienThoaiNguoiNhan(sdt);
        h.setNgayDat(LocalDateTime.now());
        h.setTrangThai("KHOI_TAO"); // sẽ chuyển sang CHO_XAC_NHAN ở finalize
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
        Long id = g.getSanPhamChiTiet().getId();
        return spctRepository.findById(id)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy SPCT id=" + id));
    }

    private void checkStock(SanPhamChiTiet spct, int req) {
        int ton = spct.getSoLuong() == null ? 0 : spct.getSoLuong();
        if (req <= 0) throw new IllegalArgumentException("Số lượng không hợp lệ");
        if (req > ton) throw new IllegalStateException("Không đủ hàng trong kho");
    }

    private int nonNull(Integer n) { return n == null ? 0 : n; }

    private BigDecimal nvl(BigDecimal v){ return v == null ? BigDecimal.ZERO : v; }

    private BigDecimal big(Number n) {
        if (n == null) return BigDecimal.ZERO;
        if (n instanceof BigDecimal) return (BigDecimal) n;
        if (n instanceof Byte || n instanceof Short || n instanceof Integer || n instanceof Long)
            return BigDecimal.valueOf(((Number) n).longValue());
        return BigDecimal.valueOf(n.doubleValue());
    }

    @Transactional
    @Override
    public void huyDonHangByCustomer(Long orderId, Long khachHangId) {
        HoaDon hd = hoaDonRepository.findByIdAndKhachHangId(orderId, khachHangId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hoặc không thuộc quyền của bạn"));

        String st = Optional.ofNullable(hd.getTrangThai()).orElse("").toUpperCase();
        // Chặn các trạng thái không cho huỷ
        if ("DANG_GIAO".equals(st))      throw new RuntimeException("Đơn đang giao, không thể huỷ.");
        if ("HOAN_THANH".equals(st))     throw new RuntimeException("Đơn đã hoàn thành.");
        if ("HUY".equals(st))            throw new RuntimeException("Đơn đã được huỷ trước đó.");

        // Hoàn kho & giảm đã bán (vì bạn đã TRỪ kho + CỘNG đã bán ngay khi tạo đơn online)
        var ctList = hoaDonChiTietRepository.findByHoaDonId(hd.getId().longValue());
        if (ctList != null) {
            // gộp theo sản phẩm cha để trừ soLuongDaBan
            Map<Long, Integer> sumBySanPham = new HashMap<>();
            for (HoaDonChiTiet ct : ctList) {
                SanPhamChiTiet spct = ct.getSanPhamChiTiet();
                if (spct == null) continue;

                int qty = Optional.ofNullable(ct.getSoLuong()).orElse(0);

                // cộng lại kho biến thể
                int ton = Optional.ofNullable(spct.getSoLuong()).orElse(0);
                spct.setSoLuong(ton + qty);
                spctRepository.save(spct);

                // trừ lại đã bán ở sản phẩm cha
                SanPham sp = spct.getSanPham();
                if (sp != null) {
                    sumBySanPham.merge(sp.getId(), qty, Integer::sum);
                }
            }
            for (var e : sumBySanPham.entrySet()) {
                SanPham sp = sanPhamRepository.findById(e.getKey()).orElse(null);
                if (sp == null) continue;
                int sold = Optional.ofNullable(sp.getSoLuongDaBan()).orElse(0);
                sold = Math.max(0, sold - e.getValue());
                sp.setSoLuongDaBan(sold);
                sanPhamRepository.save(sp);
            }
        }

        // Cập nhật trạng thái
        hd.setTrangThai("HUY");
        hd.setNgaySua(LocalDateTime.now());
        hoaDonRepository.save(hd);
    }
}
