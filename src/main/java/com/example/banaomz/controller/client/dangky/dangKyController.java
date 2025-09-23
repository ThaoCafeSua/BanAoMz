package com.example.banaomz.controller.client.dangky;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse.HoaDonChiTietResponseDTO;
import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.dto.admin.khachHang.KhachHangDTO;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.service.admin.IDiaChiService;
import com.example.banaomz.service.admin.IHoaDonService;
import com.example.banaomz.service.admin.IKhachHangService;
import com.example.banaomz.service.client.IHoaDonClientService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.net.URI;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/khachhang")
public class dangKyController {

    private final IKhachHangService khachHangService;
    private final IDiaChiService diaChiService;
    private final IHoaDonService hoaDonService;
    private final IHoaDonRepository hoaDonRepository;
    private final IHoaDonClientService hoaDonClientService;

    @Autowired
    public dangKyController(IKhachHangService khachHangService,
                            IDiaChiService diaChiService,
                            IHoaDonService hoaDonService,
                            IHoaDonRepository hoaDonRepository,
                            IHoaDonClientService hoaDonClientService) {
        this.khachHangService = khachHangService;
        this.diaChiService = diaChiService;
        this.hoaDonService = hoaDonService;
        this.hoaDonRepository = hoaDonRepository;
        this.hoaDonClientService = hoaDonClientService;
    }

    /* =======================
       ĐĂNG KÝ
    ======================= */
    @GetMapping("/dangky")
    public String showRegisterForm(@RequestParam(value = "next", required = false) String next,
                                   Model model) {
        model.addAttribute("khachHangDTO", new KhachHangDTO());
        model.addAttribute("next", next);
        return "client/khachhang/dangky";
    }

    @PostMapping("/dangky")
    public String dangKy(@ModelAttribute("khachHangDTO") KhachHangDTO khachHangDTO,
                         @RequestParam(value = "next", required = false) String next,
                         HttpSession session,
                         Model model) {
        try {
            KhachHangDTO savedCustomer = khachHangService.createCustomer(khachHangDTO);
            session.setAttribute("KH_ID", savedCustomer.getId());
            session.setAttribute("khachHang", savedCustomer);
            return safeRedirect(next, "/home");
        } catch (Exception e) {
            model.addAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            model.addAttribute("next", next);
            return "client/khachhang/dangky";
        }
    }

    /* =======================
       ĐĂNG NHẬP
    ======================= */
    @GetMapping("/dangnhap")
    public String showLoginForm(@RequestParam(value = "next", required = false) String next,
                                Model model) {
        model.addAttribute("next", next);
        return "client/khachhang/dangnhap";
    }

    @PostMapping("/dangnhap")
    public String dangNhap(@RequestParam("email") String email,
                           @RequestParam("matKhau") String matKhau,
                           @RequestParam(value = "next", required = false) String next,
                           HttpSession session,
                           Model model) {
        KhachHang khachHang = khachHangService.login(email, matKhau);
        if (khachHang != null) {
            session.setAttribute("KH_ID", khachHang.getId());
            session.setAttribute("khachHang", khachHang);
            return safeRedirect(next, "/home");
        } else {
            model.addAttribute("error", "Sai email hoặc mật khẩu!");
            model.addAttribute("next", next);
            return "client/khachhang/dangnhap";
        }
    }

    /* =======================
       ĐĂNG XUẤT
    ======================= */
    @GetMapping("/logout")
    public String logout(@RequestParam(value = "next", required = false) String next,
                         HttpSession session) {
        session.invalidate();
        // trở lại trang login, có thể đính kèm next nếu muốn quay lại
        if (next != null && !next.isBlank()) {
            return "redirect:/khachhang/dangnhap?next=" + next;
        }
        return "redirect:/khachhang/dangnhap";
    }

    /* =======================
       INFO / ĐỊA CHỈ / ĐƠN HÀNG
    ======================= */
    @GetMapping("/detail/{id}")
    public String detailKhachHang(@PathVariable("id") Long id, Model model) {
        KhachHang khachHang = khachHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách hàng"));
        model.addAttribute("customerId", id);
        return "client/khachhang/detail";
    }

    @GetMapping("/{id}/addresses")
    @ResponseBody
    public ResponseEntity<?> getAddresses(@PathVariable("id") Long id) {
        List<DiaChiDTO> diaChiList = diaChiService.getLstAddressByCustomer(id);
        return ResponseEntity.ok(ResponseObject.builder().data(diaChiList).build());
    }

    @PostMapping("/address")
    @ResponseBody
    public ResponseEntity<?> addressCustomer(@RequestBody DiaChiDTO req) {
        DiaChiDTO saved = khachHangService.addressCustomer(req);
        return ResponseEntity.ok(ResponseObject.builder().data(saved).build());
    }

    @PostMapping("/update")
    public String updateCustomer(@ModelAttribute("khachHang") KhachHangDTO dto,
                                 HttpSession session) {
        try {
            KhachHangDTO updated = khachHangService.updateCustomer(dto);
            session.setAttribute("khachHang", updated);
            session.setAttribute("success", "Cập nhật khách hàng thành công!");
            return "redirect:/khachhang/detail/" + dto.getId();
        } catch (RuntimeException e) {
            session.setAttribute("error", e.getMessage());
            return "redirect:/khachhang/detail/" + dto.getId();
        }
    }

    @GetMapping("/{id}/donhang")
    public String getDonHangByCustomer(@PathVariable("id") Long id,
                                       @RequestParam(value = "status", required = false) String status,
                                       Model model) {
        Optional<KhachHang> khachHang = khachHangService.findById(id);
        if (khachHang.isEmpty()) return "redirect:/error";

        List<HoaDonDetailResponseDTO> list = hoaDonService.getOrdersByCustomerId(id);
        model.addAttribute("customerId", id);
        model.addAttribute("donHangList", list);

        List<HoaDon> donHangList = (status == null || status.isBlank() || status.equals("ALL"))
                ? hoaDonRepository.findByKhachHangId(id)
                : hoaDonRepository.findByKhachHangIdAndTrangThai(id, status);

        model.addAttribute("donHangList", donHangList);
        model.addAttribute("selectedStatus", status);
        return "client/khachhang/donhang";
    }

    @PostMapping("/don-hang/huy")
    public String huyDon(@RequestParam("id") Long id,
                         @RequestParam("customerId") Long customerId,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        try {
            Object v = session.getAttribute("KH_ID");
            Long khId = (v instanceof Long) ? (Long) v :
                    (v instanceof Integer) ? ((Integer) v).longValue() : null;

            if (khId == null || !khId.equals(customerId)) {
                redirectAttributes.addFlashAttribute("error", "Phiên đăng nhập không hợp lệ.");
                return "redirect:/khachhang/" + customerId + "/donhang";
            }

            hoaDonClientService.huyDonHangByCustomer(id, khId);
            redirectAttributes.addFlashAttribute("message", "Đã hủy đơn hàng thành công!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/khachhang/" + customerId + "/donhang";
    }

    @GetMapping("/chitiet/{id}")
    public String xemChiTiet(@PathVariable Long id, Model model) {
        HoaDonDetailResponseDTO hoaDon = hoaDonService.getDetailById(id);
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn ID: " + id));

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
                .toList();

        String ngayDat = hoaDon.getNgayDat()
                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

        model.addAttribute("hoaDonDetail", hoaDon);
        model.addAttribute("chiTietList", chiTietList);
        model.addAttribute("page", "khachhang/chiiet");

        return "client/khachhang/chitiet";
    }

    private static String safe(java.util.concurrent.Callable<String> c) {
        try { return c.call(); } catch (Exception e) { return ""; }
    }

    /* =======================
       Helpers
    ======================= */
    private String safeRedirect(String next, String fallback) {
        // chỉ cho phép đường dẫn nội bộ dạng relative (bắt đầu bằng "/")
        if (next == null || next.isBlank()) return "redirect:" + fallback;
        try {
            URI uri = new URI(next);
            if (uri.isAbsolute()) return "redirect:" + fallback; // chặn http://domain lạ
        } catch (Exception ignored) {
            return "redirect:" + fallback;
        }
        if (!next.startsWith("/")) next = "/" + next;
        // tránh CRLF
        if (next.contains("\r") || next.contains("\n")) return "redirect:" + fallback;
        return "redirect:" + next;
    }
}
