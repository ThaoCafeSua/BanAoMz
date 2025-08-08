package com.example.banaomz.controller.client.lienhe;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/lienhe")
public class LienheController {
    @GetMapping
    public String sanPhamPage(Model model) {
        model.addAttribute("page", "lienhe/index");
        return "client/main";
    }
}
