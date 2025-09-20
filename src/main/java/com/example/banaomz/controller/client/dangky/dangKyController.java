package com.example.banaomz.controller.client.dangky;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.dto.admin.khachHang.KhachHangDTO;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.service.admin.IDiaChiService;
import com.example.banaomz.service.admin.IHoaDonService;
import com.example.banaomz.service.admin.IKhachHangService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/khachhang")
public class dangKyController {

    private final IKhachHangService khachHangService;
    private final IDiaChiService diaChiService;
    private  IHoaDonService hoaDonService;

    @Autowired
    public dangKyController(IKhachHangService khachHangService, IDiaChiService diaChiService) {
        this.khachHangService = khachHangService;
        this.diaChiService = diaChiService;
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

    // API lấy detail khách hàng + danh sách địa chỉ
    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<?> getDetailCustomer(@RequestBody Long id) {
        KhachHangDTO dto = khachHangService.detailCustomer(id);
        return ResponseEntity.ok(ResponseObject.builder().data(dto).build());
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


    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/khachhang/dangnhap";
    }

    @PostMapping("/orders")
    @ResponseBody
    public ResponseEntity<?> getOrders(@RequestBody Long customerId) {
        List<HoaDonDetailResponseDTO> orders = (List<HoaDonDetailResponseDTO>) hoaDonService.getDetailById(customerId);
        return ResponseEntity.ok(Map.of("data", orders));
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
