package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamTaiQuayViewModel;
import com.example.banaomz.entity.admin.*;
import com.example.banaomz.repository.admin.*;
import com.example.banaomz.service.admin.IBanHangService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BanHangServiceImpl implements IBanHangService {

    @Autowired
    private IHoaDonRepository hoaDonRepo;

    @Autowired
    private IHoaDonChiTietRepository hoaDonChiTietRepo;

    @Autowired
    private ISanPhamChiTietRepository sanPhamChiTietRepo;

    @Autowired
    private INhanVienRepository nhanVienRepo;

    @Autowired
    private IPhieuGiamGiaRepository phieuGiamGiaRepo;

    @Autowired
    private IKhachHangRepository khachHangRepo;

    @Override
    public List<SanPhamTaiQuayViewModel> layDanhSachSanPhamGoc() {
        List<SanPhamChiTiet> danhSachSP = sanPhamChiTietRepo.findByTrangThai("Còn hàng");

        Map<Long, SanPhamTaiQuayViewModel> map = new HashMap<>();

        for (SanPhamChiTiet spct : danhSachSP) {
            Long idSP = spct.getSanPham().getId();
            SanPhamTaiQuayViewModel vm = map.get(idSP);

            if (vm == null) {
                vm = new SanPhamTaiQuayViewModel();
                vm.setIdSanPham(idSP);
                vm.setTenSanPham(spct.getSanPham().getTenSanPham());
                vm.setGiaBan(spct.getGiaBan());

                String raw = spct.getSanPham().getUrlAnh();
                String urlAnh = (raw == null || raw.isBlank())
                        ? "/includes/images/default.png"
                        : "/includes/images/" + raw.substring(raw.lastIndexOf("/") + 1).replaceFirst("^[0-9]+_", "");
                vm.setUrlAnh(urlAnh);

                vm.setListMauSac(new ArrayList<>());
                vm.setListKichThuoc(new ArrayList<>());

                vm.setSoLuongTon(0);

                map.put(idSP, vm);
            }

            int soLuong = spct.getSoLuong() != null ? spct.getSoLuong() : 0;
            vm.setSoLuongTon(vm.getSoLuongTon() + soLuong);

            if (spct.getMauSac() != null) {
                MauSacDTO mau = new MauSacDTO(spct.getMauSac().getId(), spct.getMauSac().getTenMauSac());
                boolean chuaCoMau = vm.getListMauSac().stream().noneMatch(m -> m.getId().equals(mau.getId()));
                if (chuaCoMau) vm.getListMauSac().add(mau);
            }

            if (spct.getSize() != null) {
                SizeDTO size = new SizeDTO(spct.getSize().getId(), spct.getSize().getTenSize());
                boolean chuaCoSize = vm.getListKichThuoc().stream().noneMatch(s -> s.getId().equals(size.getId()));
                if (chuaCoSize) vm.getListKichThuoc().add(size);
            }
        }

        return new ArrayList<>(map.values());
    }


    @Override
    public HoaDon taoHoaDonMoi(Long idNhanVien, Long idKhachHang) {
        HoaDon hoaDon = new HoaDon();
        hoaDon.setNgayTao(LocalDateTime.now());
        hoaDon.setTrangThai("CHO_THANH_TOAN");
        hoaDon.setNhanVien(nhanVienRepo.findById(idNhanVien).orElse(null));
        hoaDon.setKhachHang(khachHangRepo.findById(idKhachHang).orElse(null));
        hoaDon.setMaHoaDon("HD" + System.currentTimeMillis());
        return hoaDonRepo.save(hoaDon);
    }
    @Override
    public boolean tonTaiHoaDon(Long id) {
        return hoaDonRepo.existsById(id);
    }

    @Override
    public HoaDonChiTiet themSanPhamVaoHoaDon(Long idHoaDon, Long idSPCT, int soLuong) {
        HoaDon hoaDon;

        if (idHoaDon == null || !hoaDonRepo.existsById(idHoaDon)) {
            Long idNhanVienMacDinh = 1L; // mặc định nhân viên
            Long idKhachHangMacDinh = 1L;//mặc định khách hàng

            hoaDon = taoHoaDonMoi(idNhanVienMacDinh, idKhachHangMacDinh);
            idHoaDon = hoaDon.getId().longValue();
        } else {
            hoaDon = hoaDonRepo.findById(idHoaDon).orElseThrow();
        }

        SanPhamChiTiet spct = sanPhamChiTietRepo.findById(idSPCT).orElseThrow();

        HoaDonChiTiet existing = hoaDonChiTietRepo
                .findByHoaDon_IdAndSanPhamChiTiet_Id(idHoaDon, idSPCT)
                .orElse(null);

        if (existing != null) {
            existing.setSoLuong(existing.getSoLuong() + soLuong);
            return hoaDonChiTietRepo.save(existing);
        }

        HoaDonChiTiet ct = new HoaDonChiTiet();
        ct.setHoaDon(hoaDon);
        ct.setSanPhamChiTiet(spct);
        ct.setSoLuong(soLuong);
        ct.setGiaBan(spct.getGiaBan());
        ct.setGiaGoc(spct.getGiaBan());
        ct.setGiaGiam(BigDecimal.ZERO);
        ct.setNgayTao(LocalDateTime.now());

        return hoaDonChiTietRepo.save(ct);
    }

    @Override
    public boolean capNhatSoLuong(Long idHDCT, int soLuongMoi) {
        HoaDonChiTiet ct = hoaDonChiTietRepo.findById(idHDCT).orElse(null);
        if (ct == null) return false;

        int tonKho = ct.getSanPhamChiTiet().getSoLuong();
        if (soLuongMoi > tonKho) return false;

        ct.setSoLuong(soLuongMoi);
        ct.setNgaySua(LocalDateTime.now());
        hoaDonChiTietRepo.save(ct);
        return true;
    }


    @Override
    public void xoaSanPhamKhoiHoaDon(Long idHDCT) {
        hoaDonChiTietRepo.deleteById(idHDCT);
    }

    @Override
    @Transactional
    public HoaDon hoanTatHoaDon(Long idHoaDon, Long idPhieuGiamGia, String phuongThucTT) {
        HoaDon hoaDon = hoaDonRepo.findById(idHoaDon).orElseThrow();
        List<HoaDonChiTiet> dsCT = hoaDonChiTietRepo.findByHoaDonId(idHoaDon);

        BigDecimal tongTien = dsCT.stream()
                .map(ct -> ct.getGiaBan().multiply(BigDecimal.valueOf(ct.getSoLuong())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal tienGiam = BigDecimal.ZERO;
        if (idPhieuGiamGia != null) {
            PhieuGiamGia phieu = phieuGiamGiaRepo.findById(idPhieuGiamGia).orElseThrow();
            hoaDon.setPhieuGiamGia(phieu);

            if (tongTien.compareTo(phieu.getDieuKienApDung()) >= 0) {
                tienGiam = (phieu.getGiaTriGiam().compareTo(BigDecimal.valueOf(100)) <= 0)
                        ? tongTien.multiply(phieu.getGiaTriGiam()).divide(BigDecimal.valueOf(100))
                        : phieu.getGiaTriGiam();
            }
        }

        hoaDon.setTongTien(tongTien);
        hoaDon.setTienGiam(tienGiam);
        hoaDon.setThanhTien(tongTien.subtract(tienGiam));
        hoaDon.setPhuongThucThanhToan(phuongThucTT);
        hoaDon.setNgayHoanThanh(LocalDateTime.now());
        hoaDon.setTrangThai("DA_THANH_TOAN");

        for (HoaDonChiTiet ct : dsCT) {
            SanPhamChiTiet spct = ct.getSanPhamChiTiet();
            int slHienTai = spct.getSoLuong() != null ? spct.getSoLuong() : 0;
            int slTru = ct.getSoLuong();
            spct.setSoLuong(Math.max(0, slHienTai - slTru));
            sanPhamChiTietRepo.save(spct);
        }

        return hoaDonRepo.save(hoaDon);
    }

    @Override
    public List<HoaDonChiTiet> layDanhSachSanPhamTrongHoaDon(Long idHoaDon) {
        return hoaDonChiTietRepo.findByHoaDonId(idHoaDon);
    }
    @Override
    public List<MauSacDTO> getMauSacBySanPham(Long idSanPham) {
        List<MauSac> ds = sanPhamChiTietRepo.findDistinctMauSacBySanPhamId(idSanPham);
        List<MauSacDTO> dtos = new ArrayList<>();
        for (MauSac m : ds) {
            dtos.add(new MauSacDTO(m.getId(), m.getTenMauSac()));
        }
        return dtos;
    }

    @Override
    public List<SizeDTO> getSizeBySanPham(Long idSanPham) {
        List<Size> ds = sanPhamChiTietRepo.findDistinctSizeBySanPhamId(idSanPham);
        List<SizeDTO> dtos = new ArrayList<>();
        for (Size s : ds) {
            dtos.add(new SizeDTO(s.getId(), s.getTenSize()));
        }
        return dtos;
    }


}
