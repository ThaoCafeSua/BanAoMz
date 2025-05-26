package com.example.banaomz.controller.admin.product;



import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDetailDTO;
import com.example.banaomz.entity.admin.IProductItem;
import com.example.banaomz.service.admin.ISanPhamChiTietService;
import com.example.banaomz.service.admin.ISanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Controller
@RequestMapping("/admin/product")
public class SanPhamController {

    @Autowired
    private ISanPhamService sanPhamService;

    @Autowired
    private ISanPhamChiTietService sanPhamChiTietService;

    @GetMapping()
    public String index(Model model) {
        model.addAttribute("page", "sanPham/product/index");
        return "admin/main";
    }

    @GetMapping("/add")
    public String addSanPhamPage(Model model) {
        model.addAttribute("page", "sanPham/product/add");
        return "admin/main"; // Tên file JSP được trả về
    }

    @GetMapping("/update/{id}")
    public String updateSanPhamPage(Model model,@PathVariable String id) {
        model.addAttribute("sanPhamId", id);
        model.addAttribute("page", "sanPham/product/edit");
        return "admin/main"; // Tên file JSP được trả về
    }
    @GetMapping("/detail/{id}")
    public String detailSanPhamPage(Model model,@PathVariable String id) {
        model.addAttribute("sanPhamId", id);
        model.addAttribute("page", "sanPham/product/detail");
        return "admin/main"; // Tên file JSP được trả về
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getLstProducts(@RequestParam String search, @RequestParam String status) {
        List<IProductItem> lst = sanPhamService.getLstProductGroup(search, status);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }

    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<?> detailProducts(@RequestBody Long id) {
        SanPhamDetailDTO sanPham = sanPhamService.detailSanpham(id);
        return new ResponseEntity<>(ResponseObject.builder().data(sanPham).build(), HttpStatus.OK);
    }

    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<?> createProducts(@RequestBody SanPhamDTO dto) {
        SanPhamDTO sanPhamDTO = sanPhamService.createSanPham(dto);
        return new ResponseEntity<>(ResponseObject.builder().data(sanPhamDTO).build(), HttpStatus.OK);
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updateProducts(@RequestBody SanPhamDTO dto) {
        SanPhamDTO sanPhamDTO = sanPhamService.updateSanpham(dto);
        return new ResponseEntity<>(ResponseObject.builder().data(sanPhamDTO).build(), HttpStatus.OK);
    }

}
