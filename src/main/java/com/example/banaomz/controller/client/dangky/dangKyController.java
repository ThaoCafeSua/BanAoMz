package com.example.banaomz.controller.client.dangky;


import com.example.banaomz.dto.admin.khachHang.KhachHangDTO;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.service.admin.IKhachHangService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


@Controller
@RequestMapping("/khachhang")
public class dangKyController {

    private final IKhachHangService khachHangService;

    @Autowired
    public dangKyController(IKhachHangService khachHangService) {
        this.khachHangService = khachHangService;
    }

    @GetMapping("/dangky")
    public String showRegisterForm(Model model) {
        model.addAttribute("khachHangDTO", new KhachHangDTO());
        return "client/khachhang/dangky";
    }

    @PostMapping("/dangky")
    public String dangKy(@ModelAttribute("khachHang") KhachHangDTO khachHangDTO,
                         HttpSession session, Model model) {
        try {
            KhachHangDTO saved = khachHangService.createCustomer(khachHangDTO);
            session.setAttribute("KH_ID", saved.getId()); // ✅ chỉ lưu ID
            return "redirect:/home";
        } catch (Exception e) {
            model.addAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            return "client/khachhang/dangky";
        }
    }

    @GetMapping("/detail/{id}")
    public String detailKhachHang(@PathVariable("id") Long id, Model model) {
        KhachHang khachHang = khachHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách hàng"));
        model.addAttribute("khachHang", khachHang);
        return "client/khachhang/detail"; // trả về file detail.jsp
    }

    @GetMapping("/dangnhap")
    public String showLoginForm() {
        return "client/khachhang/dangnhap"; // tên file JSP/HTML login
    }

    @PostMapping("/dangnhap")
    public String dangNhap(@RequestParam("email") String email,
                           @RequestParam("matKhau") String matKhau,
                           HttpSession session, Model model) {
        KhachHang kh = khachHangService.login(email, matKhau);
        if (kh != null) {
            session.setAttribute("KH_ID", kh.getId());   // ✅ chỉ lưu ID
            return "redirect:/home";
        } else {
            model.addAttribute("error", "Sai email hoặc mật khẩu!");
            return "client/khachhang/dangnhap";
        }
    }
}


