package com.example.banaomz.controller.admin.order;

import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/hoaDon")
public class HoaDonController {

    @Autowired
    private IHoaDonRepository hoaDonRepository;

    @GetMapping
    public String hienThiDanhSachHoaDon(Model model) {
        List<HoaDon> danhSach = hoaDonRepository.findAll();
        model.addAttribute("hoaDonList", danhSach);
        model.addAttribute("page", "order/hoaDon"); // trỏ tới: /WEB-INF/views/admin/hoaDon/danhSach.jsp
        return "/admin/header";
    }

}
