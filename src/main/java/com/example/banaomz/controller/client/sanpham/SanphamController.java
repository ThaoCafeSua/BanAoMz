package com.example.banaomz.controller.client.sanpham;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/sanpham")
public class SanphamController {
    @GetMapping
    public String sanPhamPage(Model model) {
        model.addAttribute("page", "sanpham/index");
        return "client/main";
    }

}
