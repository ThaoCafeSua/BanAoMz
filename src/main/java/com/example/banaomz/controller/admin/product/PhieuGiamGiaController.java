package com.example.banaomz.controller.admin.product;

import com.example.banaomz.dto.admin.PhieuGiamGia.PhieuGiamGiaDTO;
import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.service.admin.IPhieuGiamGiaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/phieu-giam-gia")
public class PhieuGiamGiaController {

    @Autowired
    private IPhieuGiamGiaService phieuGiamGiaService;

    @GetMapping()
    public String hienThi(Model model) {
        model.addAttribute("page", "phieuGiamGia/index");
        return "admin/main";
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getPhieuGiamGia(@RequestParam String search) {
        List<PhieuGiamGiaDTO> lst = phieuGiamGiaService.findAllPhieuGiamGia(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build() , HttpStatus.OK);
    }

    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("phieuGiamGia", new PhieuGiamGiaDTO());
        model.addAttribute("btnText", "Thêm Phiếu Giảm Giá");
        model.addAttribute("action", "/admin/phieu-giam-gia/create");
        model.addAttribute("page", "phieuGiamGia/form");
        return "admin/main";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute PhieuGiamGiaDTO req) {
        phieuGiamGiaService.createPhieuGiamGia(req);
        return "redirect:/admin/phieu-giam-gia";
    }

    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        PhieuGiamGiaDTO phieuGiamGia = phieuGiamGiaService.detailPhieuGiamGia(id);
        if (phieuGiamGia == null) {
            return "redirect:/admin/phieu-giam-gia";
        }
        model.addAttribute("phieuGiamGia", phieuGiamGia);
        model.addAttribute("btnText", "Cập Nhật");
        model.addAttribute("action", "/admin/phieu-giam-gia/update");
        model.addAttribute("page", "phieuGiamGia/form");
        return "admin/main";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute PhieuGiamGiaDTO req) {
        phieuGiamGiaService.updatePhieuGiamGia(req);
        return "redirect:/admin/phieu-giam-gia";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        PhieuGiamGiaDTO phieuGiamGia = phieuGiamGiaService.detailPhieuGiamGia(id);
        if (phieuGiamGia == null) {
            return "redirect:/admin/phieu-giam-gia";
        }
        model.addAttribute("phieuGiamGia", phieuGiamGia);
        model.addAttribute("page", "phieuGiamGia/detail");
        return "admin/main";
    }
}