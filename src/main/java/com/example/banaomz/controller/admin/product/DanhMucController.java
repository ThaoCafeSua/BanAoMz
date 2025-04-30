package com.example.banaomz.controller.admin.product;

import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.sanPham.DanhMucDTO;
import com.example.banaomz.service.admin.IDanhMucService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import java.util.List;
@Controller
@RequestMapping("/admin/category")
public class DanhMucController {

    @Autowired
    private IDanhMucService danhMucService;

    @GetMapping()
    public String hienThi(Model model) {
        model.addAttribute("page", "sanPham/danh_muc/index");
        return "admin/main";
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getDanhMuc(@RequestParam String search) {
        List<DanhMucDTO> lst = danhMucService.findAllDanhMuc(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }

    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("danhMuc", new DanhMucDTO());
        model.addAttribute("btnText", "Thêm danh mục");
        model.addAttribute("action", "/admin/category/create");
        model.addAttribute("page", "sanPham/danh_muc/form");
        return "admin/main";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute DanhMucDTO req, RedirectAttributes redirectAttributes) {
        danhMucService.createDanhMuc(req);

        // Thêm thông báo vào flash attribute
        redirectAttributes.addFlashAttribute("message", "Thêm danh mục thành công!");
        return "redirect:/admin/category";
    }

    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        DanhMucDTO danhMuc = danhMucService.detailDanhMuc(id);
        if (danhMuc == null) {
            return "redirect:/admin/category";
        }
        model.addAttribute("danhMuc", danhMuc);
        model.addAttribute("action", "/admin/category/update");
        model.addAttribute("btnText","Cập Nhật");
        model.addAttribute("page", "sanPham/danh_muc/form");
        return "admin/main";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute DanhMucDTO req, RedirectAttributes redirectAttributes) {
        danhMucService.updateDanhMuc(req);

        // Thêm thông báo vào flash attribute
        redirectAttributes.addFlashAttribute("message", "Cập nhật danh mục thành công!");
        return "redirect:/admin/category";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        DanhMucDTO danhMuc = danhMucService.detailDanhMuc(id);
        if (danhMuc == null) {
            return "redirect:/admin/category";
        }
        model.addAttribute("danhMuc", danhMuc);
        model.addAttribute("page", "sanPham/danh_muc/detail");
        return "admin/main";
    }
}
