package com.example.banaomz.controller.admin.dangNhap;

import com.example.banaomz.dto.admin.nhanVien.NhanVienDTO;
import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.repository.admin.INhanVienRepository;
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

    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("user", new NhanVienDTO());
        return "auth/login";
    }

    @PostMapping("/login")
    public String doLogin(@ModelAttribute("user") NhanVienDTO user, HttpSession session, Model model,
                          RedirectAttributes redirectAttributes) {
        NhanVien nv = nhanVienRepository.findByEmail(user.getEmail());

        // Kiểm tra thông tin đăng nhập (không mã hóa mật khẩu)
        if (nv != null && nv.getMatKhau().equals(user.getMatKhau())) {
            session.setAttribute("currentUser", nv); // lưu user vào session
            session.setAttribute("userRole", nv.getChucVu().getTenChucVu());
            redirectAttributes.addFlashAttribute("message",
                    "Đang truy cập với chức vụ " + nv.getChucVu().getTenChucVu());

            return "redirect:/admin"; // Trang quản trị
        } else {
            model.addAttribute("error", "Email hoặc mật khẩu không đúng");
            return "auth/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}
