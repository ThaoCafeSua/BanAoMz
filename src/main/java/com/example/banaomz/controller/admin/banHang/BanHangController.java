package com.example.banaomz.controller.admin.banHang;

import com.example.banaomz.dto.admin.GioHang.GioHangDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamTaiQuayViewModel;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.repository.admin.ISanPhamChiTietRepository;
import com.example.banaomz.service.admin.IBanHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/banHang")
public class BanHangController {

    @Autowired
    private IBanHangService banHangService;

    @Autowired
    private ISanPhamChiTietRepository sanPhamChiTietRepository;

    @Autowired
    private IHoaDonRepository hoaDonRepo;

    @GetMapping
    public String hienThiTrangBanHang(Model model) {
        // Dùng ViewModel để hiển thị ảnh, màu, size theo từng sản phẩm
        List<SanPhamTaiQuayViewModel> danhSach = banHangService.layDanhSachSanPhamGoc();
        model.addAttribute("sanPhamList", danhSach);
        model.addAttribute("page", "banHang/banHang");
        return "/admin/header";
    }

    @PostMapping("/tao-hoa-don")
    @ResponseBody
    public HoaDon taoHoaDonMoi() {
        Long idNhanVienMacDinh = 1L;   // hoặc lấy từ session nếu bạn có login
        Long idKhachHangMacDinh = 1L;  // khách lẻ
        return banHangService.taoHoaDonMoi(idNhanVienMacDinh, idKhachHangMacDinh);
    }

    @PostMapping("/them-san-pham")
    @ResponseBody
    public ResponseEntity<?> themSanPham(@RequestParam(required = false) Long idHoaDon,
                                         @RequestParam Long idSanPhamChiTiet,
                                         @RequestParam int soLuong) {
        try {
            HoaDon hoaDon;

            if (idHoaDon == null || !banHangService.tonTaiHoaDon(idHoaDon)) {
                hoaDon = banHangService.taoHoaDonMoi(1L, 1L);
                idHoaDon = hoaDon.getId().longValue();
            } else {
                hoaDon = hoaDonRepo.findById(idHoaDon).orElseThrow();
            }

            HoaDonChiTiet hdct = banHangService.themSanPhamVaoHoaDon(idHoaDon, idSanPhamChiTiet, soLuong);

            Map<String, Object> res = new HashMap<>();
            res.put("hdct", hdct);
            res.put("hoaDon", hoaDon); // ✅ thêm vào đây

            return ResponseEntity.ok(res);

        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Lỗi hệ thống");
        }
    }



    @PostMapping("/xoa-san-pham")
    @ResponseBody
    public void xoaSanPhamKhoiHoaDon(@RequestParam Long idHoaDonChiTiet) {
        banHangService.xoaSanPhamKhoiHoaDon(idHoaDonChiTiet);
    }

    @PostMapping("/thanh-toan")
    @ResponseBody
    public HoaDon hoanTatThanhToan(@RequestParam Long idHoaDon,
                                   @RequestParam(required = false) Long idPhieuGiamGia,
                                   @RequestParam String phuongThucThanhToan) {
        return banHangService.hoanTatHoaDon(idHoaDon, idPhieuGiamGia, phuongThucThanhToan);
    }

    // ✅ Lấy danh sách sản phẩm trong hóa đơn (giỏ hàng)
    @GetMapping("/danh-sach-san-pham")
    @ResponseBody
    public List<GioHangDTO> layDanhSachSanPham(@RequestParam Long idHoaDon) {
        List<HoaDonChiTiet> chiTietList = banHangService.layDanhSachSanPhamTrongHoaDon(idHoaDon);
        List<GioHangDTO> result = new ArrayList<>();

        for (HoaDonChiTiet hdct : chiTietList) {
            var spct = hdct.getSanPhamChiTiet();

            GioHangDTO dto = new GioHangDTO();
            dto.setId(hdct.getId());
            dto.setIdSanPhamChiTiet(spct.getId());
            dto.setTenSanPham(spct.getSanPham().getTenSanPham());
            dto.setTenMauSac(spct.getMauSac().getTenMauSac());
            dto.setTenSize(spct.getSize().getTenSize());
            dto.setGiaBan(hdct.getGiaBan());
            dto.setSoLuong(hdct.getSoLuong());

            BigDecimal thanhTien = hdct.getGiaBan().multiply(BigDecimal.valueOf(hdct.getSoLuong()));
            dto.setTongTien(thanhTien);

            result.add(dto);
        }

        return result;
    }

    @GetMapping("/tim-san-pham-chi-tiet")
    @ResponseBody
    public Map<String, Object> timSanPhamChiTiet(
            @RequestParam Long idSanPham,
            @RequestParam Long idMauSac,
            @RequestParam Long idSize) {

        var spct = sanPhamChiTietRepository
                .findBySanPham_IdAndMauSac_IdAndSize_IdAndTrangThai(idSanPham, idMauSac, idSize, "Còn Hàng")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy"));

        Map<String, Object> res = new HashMap<>();
        res.put("id", spct.getId());
        res.put("soLuongTon", spct.getSoLuong());
        return res;
    }

    @GetMapping("/lay-thuoc-tinh")
    @ResponseBody
    public Map<String, Object> layThuocTinh(@RequestParam Long idSanPham) {
        Map<String, Object> result = new HashMap<>();

        List<Map<String, Object>> mauSacList = new ArrayList<>();
        List<Map<String, Object>> sizeList = new ArrayList<>();
        List<Map<String, Object>> spctList = new ArrayList<>();

        // Lấy màu
        banHangService.getMauSacBySanPham(idSanPham).forEach(mau -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", mau.getId());
            item.put("ten", mau.getTenMauSac());
            mauSacList.add(item);
        });

        // Lấy size
        banHangService.getSizeBySanPham(idSanPham).forEach(size -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", size.getId());
            item.put("ten", size.getTenSize());
            sizeList.add(item);
        });

        // ✅ Lấy tất cả các SPCT có idSanPham này (để xử lý combo màu-size)
        sanPhamChiTietRepository.findBySanPham_Id(idSanPham).forEach(spct -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", spct.getId());
            item.put("idMauSac", spct.getMauSac().getId());
            item.put("idSize", spct.getSize().getId());
            spctList.add(item);
        });

        result.put("mauSacList", mauSacList);
        result.put("sizeList", sizeList);
        result.put("sanPhamChiTietList", spctList); // ✅ Bổ sung dòng này

        return result;
    }
    @PostMapping("/cap-nhat-so-luong")
    public ResponseEntity<?> capNhatSoLuong(
            @RequestParam Long idHoaDonChiTiet,
            @RequestParam int soLuongMoi) {
        boolean ok = banHangService.capNhatSoLuong(idHoaDonChiTiet, soLuongMoi);
        if (!ok) {
            return ResponseEntity.badRequest().body("Số lượng vượt quá tồn kho");
        }
        return ResponseEntity.ok().build();
    }
    @GetMapping("/danh-sach-hoa-don-cho")
    @ResponseBody
    public ResponseEntity<List<HoaDon>> getHoaDonCho() {
        return ResponseEntity.ok(banHangService.layDanhSachHoaDonCho());
    }



}
