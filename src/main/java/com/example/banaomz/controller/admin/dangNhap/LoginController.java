package com.example.banaomz.controller.admin.dangNhap;

import com.example.banaomz.dto.admin.nhanVien.NhanVienDTO;
import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.repository.admin.INhanVienRepository;
import com.example.banaomz.service.admin.INhanVienService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
public class LoginController {

    @Autowired
    private INhanVienRepository nhanVienRepository;

    @Autowired
    private INhanVienService nhanVienService;

    @GetMapping("/login")
    public String showLoginForm(Model model) {
        if (!model.containsAttribute("user")) {
            model.addAttribute("user", new NhanVienDTO());
        }
        return "auth/login";
    }

    @PostMapping("/login")
    public String doLogin(@ModelAttribute("user") NhanVienDTO user,
                          HttpSession session,
                          RedirectAttributes ra) {

        NhanVien nv = nhanVienRepository.findByEmail(user.getEmail());

        if (nv != null && nv.getMatKhau().equals(user.getMatKhau())) {
            session.setAttribute("currentUser", nv);
            session.setAttribute("userRole", nv.getChucVu().getTenChucVu());

            ra.addFlashAttribute("showRoleAlert", true);
            ra.addFlashAttribute("userRole", nv.getChucVu().getTenChucVu());
            return "redirect:/admin";
        }

        ra.addFlashAttribute("error", "Email hoặc mật khẩu không đúng");
        ra.addFlashAttribute("user", user);
        return "redirect:/auth/login";
    }

    @GetMapping("/forgot")
    public String showForgotPage() {
        return "auth/forgot";
    }

    @PostMapping("/forgot-password")
    public String forgotPassword(@RequestParam String email, RedirectAttributes ra) {
        try {
            nhanVienService.resetPassword(email);
            ra.addFlashAttribute("success","Mật khẩu mới đã được gửi vào email!");
            return "redirect:/auth/login";
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
            return "redirect:/auth/forgot";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
