package com.example.banaomz.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class ThongKeController {

    @GetMapping({"/home", "", "/"})
    public String home(Model model) {
        model.addAttribute("page", "dashboard/index");
        return "admin/main";
    }
}
