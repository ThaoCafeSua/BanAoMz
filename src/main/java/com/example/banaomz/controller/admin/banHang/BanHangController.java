package com.example.banaomz.controller.admin.banHang;

import com.example.banaomz.dto.admin.GioHang.GioHangDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamTaiQuayViewModel;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;
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
    public HoaDon taoHoaDonMoi(@RequestParam Long idNhanVien, @RequestParam Long idKhachHang) {
        return banHangService.taoHoaDonMoi(idNhanVien, idKhachHang);
    }

    @PostMapping("/them-san-pham")
    @ResponseBody
    public HoaDonChiTiet themSanPham(@RequestParam(required = false) Long idHoaDon,
                                     @RequestParam Long idSanPhamChiTiet,
                                     @RequestParam int soLuong) {

        if (idHoaDon == null || !banHangService.tonTaiHoaDon(idHoaDon)) {
            HoaDon hoaDon = banHangService.taoHoaDonMoi(1L, 1L); // mặc định id nhân viên + khách hàng
            idHoaDon = hoaDon.getId().longValue();
        }

        return banHangService.themSanPhamVaoHoaDon(idHoaDon, idSanPhamChiTiet, soLuong);
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

        banHangService.getMauSacBySanPham(idSanPham).forEach(mau -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", mau.getId());
            item.put("ten", mau.getTenMauSac());
            mauSacList.add(item);
        });

        banHangService.getSizeBySanPham(idSanPham).forEach(size -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", size.getId());
            item.put("ten", size.getTenSize());
            sizeList.add(item);
        });

        result.put("mauSacList", mauSacList);
        result.put("sizeList", sizeList);

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



}
