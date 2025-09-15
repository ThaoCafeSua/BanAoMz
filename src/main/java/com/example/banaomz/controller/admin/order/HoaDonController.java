package com.example.banaomz.controller.admin.order;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse.HoaDonChiTietResponseDTO;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.service.admin.IHoaDonService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/admin/hoaDon")
public class HoaDonController {

    private final IHoaDonService hoaDonService;
    private final IHoaDonRepository hoaDonRepository;

    public HoaDonController(IHoaDonService hoaDonService ,
                            IHoaDonRepository hoaDonRepository) {
        this.hoaDonService = hoaDonService;
        this.hoaDonRepository = hoaDonRepository;
    }

    // Danh sách
    @GetMapping
    public String hienThiDanhSachHoaDon(Model model) {
        List<HoaDonResponseDTO> danhSach = hoaDonService.getAll();
        model.addAttribute("hoaDonList", danhSach);
        model.addAttribute("page", "order/hoaDon");
        return "/admin/header";
    }

    // Chi tiết
    @GetMapping("/chiTiet/{id}")
    public String hienThiChiTiet(@PathVariable("id") Long id, Model model) {
        // Header (projection)
        HoaDonDetailResponseDTO header = hoaDonService.getDetailById(id);

        // Lấy entity để map ra list chi tiết
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn ID: " + id));

        // Map an toàn tránh NPE
        List<HoaDonChiTietResponseDTO> chiTietList = hd.getHoaDonChiTietList().stream()
                .map(ct -> new HoaDonChiTietResponseDTO(
                        safe(() -> ct.getSanPhamChiTiet().getSanPham().getTenSanPham()),
                        safe(() -> ct.getSanPhamChiTiet().getMauSac().getTenMauSac()),
                        safe(() -> ct.getSanPhamChiTiet().getSize().getTenSize()),
                        ct.getSoLuong() == null ? 0 : ct.getSoLuong(),
                        ct.getGiaBan() == null ? java.math.BigDecimal.ZERO : ct.getGiaBan(),
                        (ct.getGiaBan() == null ? java.math.BigDecimal.ZERO : ct.getGiaBan())
                                .multiply(java.math.BigDecimal.valueOf(ct.getSoLuong() == null ? 0 : ct.getSoLuong()))
                ))
                .toList();

        // Log để nhìn thấy dữ liệu
        System.out.println("[ADMIN][HD-DETAIL] id=" + id + " | items=" + chiTietList.size());

        model.addAttribute("hoaDonDetail", header);
        model.addAttribute("chiTietList", chiTietList);
        model.addAttribute("page", "order/hoaDonChiTiet");
        return "/admin/header";
    }

    // helper tránh NPE
    private static String safe(java.util.concurrent.Callable<String> c) {
        try { return c.call(); } catch (Exception e) { return ""; }
    }


    // Export PDF
    @GetMapping("/xuat-pdf/{id}")
    public void exportHoaDonPdf(@PathVariable("id") Long id, HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=hoa_don_" + id + ".pdf");
        hoaDonService.exportHoaDonPdf(id, response.getOutputStream());
        response.getOutputStream().flush();
    }

    // Đổi trạng thái (AJAX)
    @PostMapping("/{id}/trang-thai")
    @ResponseBody
    public ResponseEntity<?> changeStatus(@PathVariable Long id,
                                          @RequestParam("trangThai") String trangThaiMoi) {
        if (trangThaiMoi == null || trangThaiMoi.isBlank()) {
            return ResponseEntity.badRequest().body("Thiếu trạng thái mới");
        }
        try {
            HoaDonDetailResponseDTO dto = hoaDonService.updateTrangThai(id, trangThaiMoi);
            return ResponseEntity.ok(dto); // trả về header detail để UI cập nhật nhanh
        } catch (IllegalArgumentException | IllegalStateException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi: " + e.getMessage());
        }
    }

    // (Tuỳ chọn) API lấy detail JSON để reload phần chi tiết sau khi đổi trạng thái
    @GetMapping("/{id}/api/detail")
    @ResponseBody
    public ResponseEntity<HoaDonDetailResponseDTO> apiDetail(@PathVariable Long id) {
        return ResponseEntity.ok(hoaDonService.getDetailById(id));
    }
}
