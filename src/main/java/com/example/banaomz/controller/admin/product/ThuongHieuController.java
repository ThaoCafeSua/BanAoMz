package com.example.banaomz.controller.admin.product;

import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.sanPham.ThuongHieuDTO;
import com.example.banaomz.service.admin.IThuongHieuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Controller
@RequestMapping("/admin/brand")
public class ThuongHieuController {

    @Autowired
    private IThuongHieuService thuongHieuService;

    // Hiển thị trang chính
    @GetMapping()
    public String hienThi(Model model) {
        model.addAttribute("page", "sanPham/thuong_hieu/index");
        return "admin/main";
    }
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getThuongHieu(@RequestParam String search) {
        List<ThuongHieuDTO> lst = thuongHieuService.findAllThuongHieu(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }

    // Hiển thị form thêm thương hiệu
    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("thuongHieu", new ThuongHieuDTO());
        model.addAttribute("btnText", "Thêm Thương Hiệu");
        model.addAttribute("action", "/admin/brand/create");
        model.addAttribute("page", "sanPham/thuong_hieu/form");
        return "admin/main";
    }

    // Xử lý thêm thương hiệu
    @PostMapping("/create")
    public String create(@ModelAttribute ThuongHieuDTO req) {
        thuongHieuService.createThuongHieu(req);
        return "redirect:/admin/brand";
    }

    // Hiển thị form cập nhật thương hiệu
    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        ThuongHieuDTO thuongHieu = thuongHieuService.detailThuongHieu(id);
        if (thuongHieu == null) {
            return "redirect:/admin/brand";
        }
        model.addAttribute("thuongHieu", thuongHieu);
        model.addAttribute("action", "/admin/brand/update");
        model.addAttribute("btnText","Cập Nhật");
        model.addAttribute("page", "sanPham/thuong_hieu/form");
        return "admin/main";
    }

    // Xử lý cập nhật thương hiệu
    @PostMapping("/update")
    public String update(@ModelAttribute ThuongHieuDTO req) {
        thuongHieuService.updateThuongHieu(req);
        return "redirect:/admin/brand"; // Điều hướng lại trang danh sách
    }

    // Chi tiết thương hiệu
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        ThuongHieuDTO thuongHieu = thuongHieuService.detailThuongHieu(id);
        if (thuongHieu == null) {
            return "redirect:/admin/brand";
        }
        model.addAttribute("thuongHieu", thuongHieu);
        model.addAttribute("page", "sanPham/thuong_hieu/detail");
        return "admin/main";
    }

}
