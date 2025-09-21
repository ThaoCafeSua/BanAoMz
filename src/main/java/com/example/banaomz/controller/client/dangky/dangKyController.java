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
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/khachhang")
public class dangKyController {

    private final IKhachHangService khachHangService;
    private final IDiaChiService diaChiService;
    private final IHoaDonService hoaDonService;      // vẫn dùng cho các chỗ khác
    private final IHoaDonRepository hoaDonRepository;
    private final IHoaDonClientService hoaDonClientService; // 👉 NEW

    @Autowired
    public dangKyController(IKhachHangService khachHangService,
                            IDiaChiService diaChiService,
                            IHoaDonService hoaDonService,
                            IHoaDonRepository hoaDonRepository,
                            IHoaDonClientService hoaDonClientService) { // 👉 NEW
        this.khachHangService = khachHangService;
        this.diaChiService = diaChiService;
        this.hoaDonService = hoaDonService;
        this.hoaDonRepository = hoaDonRepository;
        this.hoaDonClientService = hoaDonClientService; // 👉 NEW
    }

    // Trang đăng ký
    @GetMapping("/dangky")
    public String showRegisterForm(Model model) {
        model.addAttribute("khachHangDTO", new KhachHangDTO());
        return "client/khachhang/dangky";
    }

    @PostMapping("/dangky")
    public String dangKy(@ModelAttribute("khachHang") KhachHangDTO khachHangDTO,
                         HttpSession session,
                         Model model) {
        try {
            KhachHangDTO savedCustomer = khachHangService.createCustomer(khachHangDTO);
            session.setAttribute("khachHang", savedCustomer);
            return "redirect:/home";
        } catch (Exception e) {
            model.addAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            return "client/khachhang/dangky";
        }
    }

    // Trang chi tiết khách hàng
    @GetMapping("/detail/{id}")
    public String detailKhachHang(@PathVariable("id") Long id, Model model) {
        KhachHang khachHang = khachHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách hàng"));
        model.addAttribute("customerId", id);
        return "client/khachhang/detail"; // JSP detail
    }

    // API lấy danh sách địa chỉ
    @GetMapping("/{id}/addresses")
    @ResponseBody
    public ResponseEntity<?> getAddresses(@PathVariable("id") Long id) {
        List<DiaChiDTO> diaChiList = diaChiService.getLstAddressByCustomer(id);
        return ResponseEntity.ok(ResponseObject.builder().data(diaChiList).build());
    }

    // API thêm/sửa địa chỉ
    @PostMapping("/address")
    @ResponseBody
    public ResponseEntity<?> addressCustomer(@RequestBody DiaChiDTO req) {
        DiaChiDTO saved = khachHangService.addressCustomer(req);
        return ResponseEntity.ok(ResponseObject.builder().data(saved).build());
    }

    // Trang đăng nhập
    @GetMapping("/dangnhap")
    public String showLoginForm() {
        return "client/khachhang/dangnhap";
    }

    @PostMapping("/dangnhap")
    public String dangNhap(@RequestParam("email") String email,
                           @RequestParam("matKhau") String matKhau,
                           HttpSession session,
                           Model model) {
        KhachHang khachHang = khachHangService.login(email, matKhau);
        if (khachHang != null) {
            session.setAttribute("KH_ID", khachHang.getId());
            session.setAttribute("khachHang", khachHang);
            return "redirect:/home";
        } else {
            model.addAttribute("error", "Sai email hoặc mật khẩu!");
            return "client/khachhang/dangnhap";
        }
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


    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/khachhang/dangnhap";
    }

    @GetMapping("/{id}/donhang")
    public String getDonHangByCustomer(@PathVariable("id") Long id,@RequestParam(value = "status", required = false) String status, Model model) {
        Optional<KhachHang> khachHang = khachHangService.findById(id);
        if (khachHang.isEmpty()) {
            return "redirect:/error"; // hoặc thông báo "Khách hàng không tồn tại"
        }
        List<HoaDonDetailResponseDTO> list = hoaDonService.getOrdersByCustomerId(id);
        model.addAttribute("customerId", id);
        model.addAttribute("donHangList", list);
        List<HoaDon> donHangList;

        if (status == null || status.isEmpty() || status.equals("ALL")) {
            donHangList = hoaDonRepository.findByKhachHangId(id);
        } else {
            donHangList = hoaDonRepository.findByKhachHangIdAndTrangThai(id, status);
        }

        model.addAttribute("donHangList", donHangList);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("customerId", id);
        return "client/khachhang/donhang";
    }



    @PostMapping("/don-hang/huy")
    public String huyDon(@RequestParam("id") Long id,
                         @RequestParam("customerId") Long customerId,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        try {
            // Lấy KH_ID từ session để đảm bảo đúng chủ đơn
            Object v = session.getAttribute("KH_ID");
            Long khId = (v instanceof Long) ? (Long) v :
                    (v instanceof Integer) ? ((Integer) v).longValue() : null;

            if (khId == null || !khId.equals(customerId)) {
                redirectAttributes.addFlashAttribute("error", "Phiên đăng nhập không hợp lệ.");
                return "redirect:/khachhang/" + customerId + "/donhang";
            }

            // 👉 Dùng service CLIENT riêng: hoàn kho & giảm soLuongDaBan ngay khi KH huỷ
            hoaDonClientService.huyDonHangByCustomer(id, khId);

            redirectAttributes.addFlashAttribute("message", "Đã hủy đơn hàng thành công!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/khachhang/" + customerId + "/donhang";
    }


    @GetMapping("/chitiet/{id}")
    public String xemChiTiet(@PathVariable Long id, Model model) {

        // Lấy thông tin header (dùng service như cũ)
        HoaDonDetailResponseDTO hoaDon = hoaDonService.getDetailById(id);

        // Lấy entity để map list chi tiết trực tiếp trong controller
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

        // Format ngày để JSP hiển thị
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




    @PostMapping("/forgot-password")
    public String forgotPassword(@RequestParam("email") String email,
                                 RedirectAttributes redirectAttributes) {
        try {
            khachHangService.resetPassword(email);
            redirectAttributes.addFlashAttribute("success", "Mật khẩu mới đã được gửi vào email!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/khachhang/dangnhap";
    }
}