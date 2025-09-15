package com.example.banaomz.controller.client.home;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.banaomz.entity.admin.IProductItem;
import com.example.banaomz.service.client.ISanPhamClientService;

@Controller
@RequestMapping("/")
public class HomeController {

    @Autowired
    private ISanPhamClientService sanPhamClientService;

    @GetMapping(value = { "/home", "", "/" })
    public String home(Model model) {
        var list = sanPhamClientService.getSanPhamMoiNhat(null, "HOAT_DONG");
        var top10List = sanPhamClientService.getTop10SanPhamBanChay();

        model.addAttribute("listSp", list);
        model.addAttribute("top10List", top10List);
        model.addAttribute("page", "home/index");
        return "client/main";
    }
}
