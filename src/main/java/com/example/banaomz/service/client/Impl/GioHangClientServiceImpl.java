package com.example.banaomz.service.client.Impl;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.repository.client.GioHangClientRepository;
import com.example.banaomz.service.client.IGioHangClientService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service

public class GioHangClientServiceImpl implements IGioHangClientService {
    private final GioHangClientRepository gioHangRepository;

    public GioHangClientServiceImpl(GioHangClientRepository gioHangRepository) {
        this.gioHangRepository = gioHangRepository;
    }

    @Override
    public List<GioHang> layGioHang(KhachHang khachHang) {
        return gioHangRepository.findByKhachHang(khachHang);
    }

    @Override
    public GioHang themSanPham(KhachHang khachHang, SanPhamChiTiet spct, int soLuong) {
        if (soLuong <= 0) {
            throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
        }
        if (spct.getSoLuong() < soLuong) {
            throw new RuntimeException("Không đủ hàng trong kho");
        }

        return gioHangRepository.findByKhachHangAndSanPhamChiTiet(khachHang, spct)
                .map(item -> {
                    int newQuantity = item.getSoLuong() + soLuong;
                    if (newQuantity > spct.getSoLuong()) {
                        throw new RuntimeException("Không đủ hàng trong kho");
                    }
                    item.setSoLuong(newQuantity);
                    item.setNguoiSua("system");
                    item.setNgaySua(LocalDateTime.now());
                    return gioHangRepository.save(item);
                })
                .orElseGet(() -> {
                    GioHang item = new GioHang();
                    item.setKhachHang(khachHang);
                    item.setSanPhamChiTiet(spct);
                    item.setSoLuong(soLuong);
                    item.setNguoiTao("system");
                    item.setNgayTao(LocalDateTime.now());
                    return gioHangRepository.save(item);
                });
    }

    @Override
    public GioHang capNhatSoLuong(KhachHang khachHang, SanPhamChiTiet spct, int soLuong) {
        if (soLuong <= 0) {
            throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
        }
        if (spct.getSoLuong() < soLuong) {
            throw new RuntimeException("Không đủ hàng trong kho");
        }

        GioHang item = gioHangRepository.findByKhachHangAndSanPhamChiTiet(khachHang, spct)
                .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại trong giỏ"));
        item.setSoLuong(soLuong);
        item.setNguoiSua("system");
        item.setNgaySua(LocalDateTime.now());
        return gioHangRepository.save(item);
    }


    @Override
    public void xoaSanPham(KhachHang khachHang, SanPhamChiTiet spct) {
        gioHangRepository.deleteByKhachHangAndSanPhamChiTiet(khachHang, spct);
    }

    @Override
    public void xoaToanBo(KhachHang khachHang) {
        List<GioHang> items = gioHangRepository.findByKhachHang(khachHang);
        gioHangRepository.deleteAll(items);
    }

    @Override
    public List<GioHang> getCartByKhachHang(Long idKhachHang) {
        return gioHangRepository.findByKhachHangId(idKhachHang);
    }

    @Override
    public void clearCartByKhachHang(Long idKhachHang) {
        gioHangRepository.deleteByKhachHangId(idKhachHang);
    }
}
