package com.example.banaomz.controller.client.tintuc;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/tintuc")
public class TintucController {
    @GetMapping
    public String sanPhamPage(Model model) {
        model.addAttribute("page", "tintuc/index");
        return "client/main";
    }
}
