package com.example.banaomz.controller.client.gioithieu;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/gioithieu")
public class GioithieuController {
    @GetMapping
    public String sanPhamPage(Model model) {
        model.addAttribute("page", "gioithieu/index");
        return "client/main";
    }
}
