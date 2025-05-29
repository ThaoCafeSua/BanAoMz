package com.example.banaomz.controller.admin.customer;

import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.dto.admin.khachHang.KhachHangDTO;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.enums.Gender;
import com.example.banaomz.service.admin.IDiaChiService;
import com.example.banaomz.service.admin.IKhachHangService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin/customer")
public class CustomerController {

    @Autowired
    private IKhachHangService customerService;

    @Autowired
    private IDiaChiService diaChiService;;

    @GetMapping()
    public String index(Model model) {
        Map<String, Gender> gender = new LinkedHashMap<>();
        gender.put(Gender.Male.toString(), Gender.Male);
        gender.put(Gender.Female.toString(), Gender.Female);
        model.addAttribute("gender", gender);
        model.addAttribute("page", "customer/index");
        return "admin/main";
    }
    @GetMapping("/create")
    public String formCreate(Model model) {
        Map<String, String> gender = new LinkedHashMap<>();
        gender.put(Gender.Male.toString(), Gender.Male.getLabel());
        gender.put(Gender.Female.toString(), Gender.Female.getLabel());
        model.addAttribute("gender", gender);
        KhachHang kh = KhachHang.builder().gioiTinh(Gender.Male.toString()).build();
        model.addAttribute("customer",kh);
        model.addAttribute("btnText","Thêm Khách Hàng");
        model.addAttribute("action", "/admin/customer/create");
        model.addAttribute("page", "customer/form");
        return "admin/main";
    }

    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        Optional<KhachHang> otp = customerService.findById(id);
        if (otp.isEmpty()){
            return "redirect:/admin/customer";
        }
        Map<String, String> gender = new LinkedHashMap<>();
        gender.put(Gender.Male.toString(), Gender.Male.getLabel());
        gender.put(Gender.Female.toString(), Gender.Female.getLabel());
        model.addAttribute("gender", gender);
        model.addAttribute("customer", otp.get());
        model.addAttribute("btnText","Cập Nhật");
        model.addAttribute("action", "/admin/customer/update");
        model.addAttribute("page", "customer/form");
        return "admin/main";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("customerId", id);
        model.addAttribute("page", "customer/detail");
        return "admin/main";
    }

    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<?> detailApi(@RequestBody Long id) {
        KhachHangDTO khachHang = customerService.detailCustomer(id);
        return new ResponseEntity<>(ResponseObject.builder()
                .data(khachHang).build(), HttpStatus.OK);
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getCustomer(@RequestParam String search) {
        List<KhachHangDTO> lst = customerService.findAllCustomer(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }

    @PostMapping("/create")
    public String create(@ModelAttribute KhachHangDTO req) {
        customerService.createCustomer(req);
        return "redirect:/admin/customer";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute KhachHangDTO req) {
        customerService.updateCustomer(req);
        return "redirect:/admin/customer";
    }


    @PostMapping("/address")
    @ResponseBody
    public ResponseEntity<?> addressCustomer(@RequestBody DiaChiDTO req) {
        customerService.addressCustomer(req);
        return new ResponseEntity<>(ResponseObject.builder().data(req).build(), HttpStatus.OK);

    }

}
