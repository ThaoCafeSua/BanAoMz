package com.example.banaomz.controller.admin.product;

import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import com.example.banaomz.service.admin.ISizeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/size")
public class SizeController {
    @Autowired
    private ISizeService sizeService;
    @GetMapping()
    public String hienThi(Model model) {
        model.addAttribute("page", "sanPham/size/index");
        return "admin/main";
    }
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getSize(@RequestParam String search) {
        List<SizeDTO> lst = sizeService.findAllSize(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }
    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("size", new SizeDTO());
        model.addAttribute("btnText", "Thêm size");
        model.addAttribute("action", "/admin/size/create");
        model.addAttribute("page", "sanPham/size/form");
        return "admin/main";
    }
    @PostMapping("/create")
    public String create(@ModelAttribute SizeDTO req) {
        sizeService.createSize(req);
        return "redirect:/admin/size";
    }
    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        SizeDTO size = sizeService.detailSize(id);
        if (size == null) {
            return "redirect:/admin/size";
        }
        model.addAttribute("size", size);
        model.addAttribute("btnText","Cập Nhật");
        model.addAttribute("action", "/admin/size/update");
        model.addAttribute("page", "sanPham/size/form");
        return "admin/main";
    }
    @PostMapping("/update")
    public String update(@ModelAttribute SizeDTO req) {
        sizeService.updateSize(req);
        return "redirect:/admin/size";
    }
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        SizeDTO size = sizeService.detailSize(id);
        if (size == null) {
            return "redirect:/admin/size";
        }
        model.addAttribute("size", size);
        model.addAttribute("page", "sanPham/size/detail");
        return "admin/main";
    }
}
