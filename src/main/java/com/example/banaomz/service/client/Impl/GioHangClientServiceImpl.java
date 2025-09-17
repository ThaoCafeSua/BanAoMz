package com.example.banaomz.service.client.Impl;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.repository.client.GioHangClientRepository;
import com.example.banaomz.repository.client.SanPhamChiTietClientRepository;
import com.example.banaomz.service.client.IGioHangClientService;
import jakarta.persistence.LockModeType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class GioHangClientServiceImpl implements IGioHangClientService {

    private final GioHangClientRepository gioHangRepository;
    private final SanPhamChiTietClientRepository spctRepository;

    public GioHangClientServiceImpl(GioHangClientRepository gioHangRepository,
                                    SanPhamChiTietClientRepository spctRepository) {
        this.gioHangRepository = gioHangRepository;
        this.spctRepository = spctRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GioHang> layGioHang(KhachHang khachHang) {
        return gioHangRepository.findAllByKhachHang(khachHang);
    }

    @Override
    public GioHang themSanPham(KhachHang khachHang, SanPhamChiTiet spctInput, Integer soLuong) {
        if (khachHang == null) throw new IllegalArgumentException("Khách hàng null");
        if (spctInput == null || spctInput.getId() == null) throw new IllegalArgumentException("SPCT null");
        if (soLuong == null || soLuong <= 0) throw new IllegalArgumentException("Số lượng phải > 0");

        SanPhamChiTiet spct = loadSpctForUpdate(spctInput.getId()); // load từ DB, khoá để tránh race nếu có
        int ton = safeInt(spct.getSoLuong());
        if (soLuong > ton) {
            throw new IllegalStateException("Không đủ hàng trong kho");
        }

        GioHang item = gioHangRepository.findByKhachHangAndSanPhamChiTiet(khachHang, spct)
                .map(existing -> {
                    int newQty = safeInt(existing.getSoLuong()) + soLuong;
                    if (newQty > ton) {
                        throw new IllegalStateException("Không đủ hàng trong kho");
                    }
                    existing.setSoLuong(newQty);
                    existing.setNguoiSua("system");
                    existing.setNgaySua(LocalDateTime.now());
                    return gioHangRepository.save(existing);
                })
                .orElseGet(() -> {
                    GioHang g = new GioHang();
                    g.setKhachHang(khachHang);
                    g.setSanPhamChiTiet(spct);
                    g.setSoLuong(soLuong);
                    g.setNguoiTao("system");
                    g.setNgayTao(LocalDateTime.now());
                    return gioHangRepository.save(g);
                });

        return item;
    }

    @Override
    public GioHang capNhatSoLuong(KhachHang khachHang, SanPhamChiTiet spctInput, Integer soLuong) {
        if (khachHang == null) throw new IllegalArgumentException("Khách hàng null");
        if (spctInput == null || spctInput.getId() == null) throw new IllegalArgumentException("SPCT null");
        if (soLuong == null || soLuong <= 0) throw new IllegalArgumentException("Số lượng phải > 0");

        SanPhamChiTiet spct = loadSpctForUpdate(spctInput.getId());
        int ton = safeInt(spct.getSoLuong());
        if (soLuong > ton) {
            throw new IllegalStateException("Không đủ hàng trong kho");
        }

        GioHang item = gioHangRepository.findByKhachHangAndSanPhamChiTiet(khachHang, spct)
                .orElseThrow(() -> new IllegalStateException("Sản phẩm chưa có trong giỏ"));
        item.setSoLuong(soLuong);
        item.setNguoiSua("system");
        item.setNgaySua(LocalDateTime.now());
        return gioHangRepository.save(item);
    }

    @Override
    public void xoaSanPham(KhachHang khachHang, SanPhamChiTiet spctInput) {
        if (khachHang == null || spctInput == null || spctInput.getId() == null) return;
        gioHangRepository.deleteByKhachHangAndSanPhamChiTiet_Id(khachHang, spctInput.getId());
    }


    @Override
    public void xoaToanBo(KhachHang khachHang) {
        if (khachHang == null) return;
        gioHangRepository.deleteByKhachHang(khachHang);
    }

    @Override
    @Transactional(readOnly = true)
    public List<GioHang> getCartByKhachHang(Integer khachHangId) {
        return gioHangRepository.findAllByKhachHangId(khachHangId);
    }

    @Override
    public void clearCartByKhachHang(Integer khachHangId) {
        gioHangRepository.deleteByKhachHangId(khachHangId);
    }

    /* ================= Helpers ================= */

    private SanPhamChiTiet loadSpctForUpdate(Number id) {
        Long spctId = toLong(id);
        return spctRepository.findById(spctId)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy SPCT id=" + spctId));
    }

    private Long toLong(Number n) { return n == null ? null : n.longValue(); }


    private Integer toInt(Number n) {
        if (n == null) return null;
        return n.intValue();
    }

    private int safeInt(Integer n) {
        return n == null ? 0 : n;
    }
}
