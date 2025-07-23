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
        List<SanPhamChiTiet> danhSachSP = sanPhamChiTietRepo.findByTrangThaiAndSanPhamHoatDong("HOAT_DONG");

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
                MauSacDTO mau = new MauSacDTO(spct.getMauSac().getId(), spct.getMauSac().getTenMauSac(), null);
                boolean chuaCoMau = vm.getListMauSac().stream().noneMatch(m -> m.getId().equals(mau.getId()));
                if (chuaCoMau) vm.getListMauSac().add(mau);
            }

            if (spct.getSize() != null) {
                SizeDTO size = new SizeDTO(spct.getSize().getId(), spct.getSize().getTenSize(), null);
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
        hoaDon.setLoaiHoaDon("CHO");
        hoaDon.setNhanVien(nhanVienRepo.findById(idNhanVien).orElse(null));
        hoaDon.setKhachHang(khachHangRepo.findById(idKhachHang).orElse(null));
        hoaDon.setMaHoaDon("HD" + System.currentTimeMillis());
        return hoaDonRepo.save(hoaDon);
    }
    @Override
    public List<HoaDon> layDanhSachHoaDonCho() {
        return hoaDonRepo.findByTrangThaiAndLoaiHoaDon("CHO_THANH_TOAN", "CHO");
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
        int soLuongTonKho = spct.getSoLuong() != null ? spct.getSoLuong() : 0;

        HoaDonChiTiet existing = hoaDonChiTietRepo
                .findByHoaDon_IdAndSanPhamChiTiet_Id(idHoaDon, idSPCT)
                .orElse(null);

        if (existing != null) {
            int tongSoLuong = existing.getSoLuong() + soLuong;
            if (tongSoLuong > soLuongTonKho) {
                throw new IllegalArgumentException("Không thể thêm vì vượt quá số lượng tồn kho!");
            }
            existing.setSoLuong(tongSoLuong);
            return hoaDonChiTietRepo.save(existing);
        }

        if (soLuong > soLuongTonKho) {
            throw new IllegalArgumentException("Không thể thêm vì vượt quá số lượng tồn kho!");
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
    public HoaDon hoanTatHoaDon(List<Map<String, Object>> danhSachSanPham, Long idPhieuGiamGia, String phuongThucTT) {
        HoaDon hoaDon = new HoaDon();
        hoaDon.setMaHoaDon("HD" + System.currentTimeMillis());
        hoaDon.setNgayTao(LocalDateTime.now());
        hoaDon.setTrangThai("DA_THANH_TOAN");
        hoaDon.setLoaiHoaDon("TAI_QUAY");
        hoaDon.setNhanVien(nhanVienRepo.findById(1L).orElse(null));
        hoaDon.setKhachHang(khachHangRepo.findById(1L).orElse(null));

        hoaDon = hoaDonRepo.save(hoaDon);

        BigDecimal tongTien = BigDecimal.ZERO;

        for (Map<String, Object> item : danhSachSanPham) {
            Long idSPCT = Long.valueOf(item.get("idSanPhamChiTiet").toString());
            Integer soLuong = Integer.valueOf(item.get("soLuong").toString());

            SanPhamChiTiet spct = sanPhamChiTietRepo.findById(idSPCT).orElseThrow();

            HoaDonChiTiet ct = new HoaDonChiTiet();
            ct.setHoaDon(hoaDon);
            ct.setSanPhamChiTiet(spct);
            ct.setSoLuong(soLuong);
            ct.setGiaBan(spct.getGiaBan());
            ct.setGiaGoc(spct.getGiaBan());
            ct.setGiaGiam(BigDecimal.ZERO);
            ct.setNgayTao(LocalDateTime.now());

            hoaDonChiTietRepo.save(ct);

            tongTien = tongTien.add(spct.getGiaBan().multiply(BigDecimal.valueOf(soLuong)));

            int tonKho = spct.getSoLuong() != null ? spct.getSoLuong() : 0;
            spct.setSoLuong(Math.max(0, tonKho - soLuong));
            sanPhamChiTietRepo.save(spct);
        }

        BigDecimal tienGiam = BigDecimal.ZERO;
        if (idPhieuGiamGia != null) {
            PhieuGiamGia phieu = phieuGiamGiaRepo.findById(idPhieuGiamGia).orElseThrow();
            hoaDon.setPhieuGiamGia(phieu);

//            if (tongTien.compareTo(BigDecimal.valueOf(phieu.getDieuKienApDung())) >= 0) {
//                BigDecimal giam = BigDecimal.valueOf(phieu.getGiaTriGiam());
//                if (giam.compareTo(BigDecimal.valueOf(100)) <= 0) {
//                    tienGiam = tongTien.multiply(giam).divide(BigDecimal.valueOf(100));
//                } else {
//                    tienGiam = giam;
//                }
//                if (tienGiam.compareTo(tongTien) > 0) {
//                    tienGiam = tongTien;
//                }
//            }

        }

        hoaDon.setTongTien(tongTien);
        hoaDon.setTienGiam(tienGiam);
        hoaDon.setThanhTien(tongTien.subtract(tienGiam));
        hoaDon.setPhuongThucThanhToan(phuongThucTT);
        hoaDon.setNgayHoanThanh(LocalDateTime.now());

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
            dtos.add(new MauSacDTO(m.getId(), m.getTenMauSac(),m.getTrangThai()));
        }
        return dtos;
    }

    @Override
    public List<SizeDTO> getSizeBySanPham(Long idSanPham) {
        List<Size> ds = sanPhamChiTietRepo.findDistinctSizeBySanPhamId(idSanPham);
        List<SizeDTO> dtos = new ArrayList<>();
        for (Size s : ds) {
            dtos.add(new SizeDTO(s.getId(), s.getTenSize(),s.getTrangThai()));
        }
        return dtos;
    }


}
