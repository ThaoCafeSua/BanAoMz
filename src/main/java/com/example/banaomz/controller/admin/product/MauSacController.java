package com.example.banaomz.controller.admin.product;

import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.service.admin.IMauSacService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/color")
public class MauSacController {
    @Autowired
    private IMauSacService mauSacService;
    @GetMapping()
    public String hienThi(Model model) {
        model.addAttribute("page", "sanPham/mau_sac/index");
        return "admin/main";
    }
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getMauSac(@RequestParam String search) {
        List<MauSacDTO> lst = mauSacService.findAllMauSac(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }
    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("mauSac", new MauSacDTO());
        model.addAttribute("btnText", "Thêm Màu Sắc");
        model.addAttribute("action", "/admin/color/create");
        model.addAttribute("page", "sanPham/mau_sac/form");
        return "admin/main";
    }
    @PostMapping("/create")
    public String create(@ModelAttribute MauSacDTO req) {
        mauSacService.createMauSac(req);
        return "redirect:/admin/color";
    }
    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        MauSacDTO mauSac = mauSacService.detailMauSac(id);
        if (mauSac == null) {
            return "redirect:/admin/color";
        }
        model.addAttribute("mauSac", mauSac);
        model.addAttribute("btnText","Cập Nhật");
        model.addAttribute("action", "/admin/color/update");
        model.addAttribute("page", "sanPham/mau_sac/form");
        return "admin/main";
    }
    @PostMapping("/update")
    public String update(@ModelAttribute MauSacDTO req) {
        mauSacService.updateMauSac(req);
        return "redirect:/admin/color";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        MauSacDTO mauSac = mauSacService.detailMauSac(id);
        if (mauSac == null) {
            return "redirect:/admin/color";
        }
        model.addAttribute("mauSac", mauSac);
        model.addAttribute("page", "sanPham/mau_sac/detail");
        return "admin/main";
    }
}
