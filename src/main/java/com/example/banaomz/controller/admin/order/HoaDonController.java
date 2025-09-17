package com.example.banaomz.controller.admin.order;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse.HoaDonChiTietResponseDTO;
import com.example.banaomz.dto.common.ApiResponse;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.service.admin.IHoaDonService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/hoaDon")
public class HoaDonController {

    private final IHoaDonService hoaDonService;
    private final IHoaDonRepository hoaDonRepository;

    public HoaDonController(IHoaDonService hoaDonService,
                            IHoaDonRepository hoaDonRepository) {
        this.hoaDonService = hoaDonService;
        this.hoaDonRepository = hoaDonRepository;
    }

    /* ====================== VIEWS ====================== */

    // Danh sách (render JSP)
    @GetMapping
    public String hienThiDanhSachHoaDon(Model model) {
        List<HoaDonResponseDTO> danhSach = hoaDonService.getAll();
        model.addAttribute("hoaDonList", danhSach);
        model.addAttribute("page", "order/hoaDon");
        return "admin/header";
    }

    // Chi tiết (render JSP)
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
                        Optional.ofNullable(ct.getSoLuong()).orElse(0),
                        Optional.ofNullable(ct.getGiaBan()).orElse(BigDecimal.ZERO),
                        Optional.ofNullable(ct.getGiaBan()).orElse(BigDecimal.ZERO)
                                .multiply(BigDecimal.valueOf(Optional.ofNullable(ct.getSoLuong()).orElse(0)))
                ))
                .collect(Collectors.toList());

        model.addAttribute("hoaDonDetail", header);
        model.addAttribute("chiTietList", chiTietList);
        model.addAttribute("page", "order/hoaDonChiTiet");
        return "admin/header";
    }

    private static String safe(java.util.concurrent.Callable<String> c) {
        try { return c.call(); } catch (Exception e) { return ""; }
    }

    /* ====================== FILE EXPORT ====================== */

    @GetMapping("/xuat-pdf/{id}")
    public void exportHoaDonPdf(@PathVariable("id") Long id, HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=hoa_don_" + id + ".pdf");
        hoaDonService.exportHoaDonPdf(id, response.getOutputStream());
        response.getOutputStream().flush();
    }

    /* ====================== JSON APIs ====================== */

    // (Tuỳ chọn) Lấy danh sách JSON
    @GetMapping(value = "/api/list", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<ApiResponse<List<HoaDonResponseDTO>>> apiList() {
        return ResponseEntity.ok(ApiResponse.ok(hoaDonService.getAll()));
    }

    // (Tuỳ chọn) Lấy detail JSON để reload UI sau khi đổi trạng thái
    @GetMapping(value = "/{id}/api/detail", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<ApiResponse<HoaDonDetailResponseDTO>> apiDetail(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(hoaDonService.getDetailById(id)));
    }

    /**
     * Đổi trạng thái (một endpoint duy nhất):
     * - Hỗ trợ form-param: trangThai=HUY
     * - Hoặc JSON body: { "trangThai": "HUY" }
     * Service đã lo cộng/trừ kho & soLuongDaBan theo flow vào/ra nhóm đếm bán.
     */
    @RequestMapping(
            value = "/{id}/trang-thai",
            method = { RequestMethod.POST, RequestMethod.PUT, RequestMethod.PATCH },
            consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    @ResponseBody
    public ResponseEntity<?> changeStatus(
            @PathVariable Long id,
            @RequestParam("trangThai") String trangThaiMoi) {
        if (trangThaiMoi == null || trangThaiMoi.isBlank()) {
            return ResponseEntity.badRequest().body("Thiếu trạng thái mới");
        }
        try {
            var dto = hoaDonService.updateTrangThai(id, trangThaiMoi);
            return ResponseEntity.ok(dto); // hoặc ApiResponse.ok(dto) nếu bạn dùng wrapper
        } catch (IllegalArgumentException | IllegalStateException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi: " + e.getMessage());
        }
    }
}
