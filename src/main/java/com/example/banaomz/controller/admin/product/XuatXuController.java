package com.example.banaomz.controller.admin.product;

import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.sanPham.XuatXuDTO;
import com.example.banaomz.service.admin.IXuatXuService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/origin")
public class XuatXuController {
    @Autowired
    private IXuatXuService xuatXuService;
    @GetMapping()
    public String hienThi(Model model) {

        model.addAttribute("page", "sanPham/xuat_xu/index");
        return "admin/main";
    }
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getXuatXu(@RequestParam String search) {
        List<XuatXuDTO> lst = xuatXuService.findAllXuatXu(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }
    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("xuatXu", new XuatXuDTO());
        model.addAttribute("btnText", "Thêm Xuất Xứ");
        model.addAttribute("action", "/admin/origin/create");
        model.addAttribute("page", "sanPham/xuat_xu/form");
        return "admin/main";
    }
    @PostMapping("/create")
    public String create(@Valid @ModelAttribute XuatXuDTO req) {
        xuatXuService.createXuatXu(req);
        return "redirect:/admin/origin";
    }
    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        XuatXuDTO xuatXu = xuatXuService.detailXuatXu(id);
        if (xuatXu == null) {
            return "redirect:/admin/origin";
        }
        model.addAttribute("xuatXu", xuatXu);
        model.addAttribute("btnText","Cập Nhật");
        model.addAttribute("action", "/admin/origin/update");
        model.addAttribute("page", "sanPham/xuat_xu/form");
        return "admin/main";
    }
    @PostMapping("/update")
    public String update(@ModelAttribute XuatXuDTO req) {
        xuatXuService.updateXuatXu(req);
        return "redirect:/admin/origin";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        XuatXuDTO xuatXu = xuatXuService.detailXuatXu(id);
        if (xuatXu == null) {
            return "redirect:/admin/origin";
        }
        model.addAttribute("xuatXu", xuatXu);
        model.addAttribute("page", "sanPham/xuat_xu/detail");
        return "admin/main";
    }

}
