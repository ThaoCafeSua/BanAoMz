package com.example.banaomz.controller.admin.nhanVien;

import com.example.banaomz.dto.admin.nhanVien.NhanVienDTO;
import com.example.banaomz.dto.admin.ResponseObject;
import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.enums.Gender;
import com.example.banaomz.service.admin.IChucVuService;
import com.example.banaomz.service.admin.INhanVienService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/admin/employee")
public class nhanVienController {

    private final IChucVuService chucVuService;
    private final INhanVienService nhanVienService;

    public nhanVienController(IChucVuService chucVuService, INhanVienService nhanVienService) {
        this.chucVuService = chucVuService;
        this.nhanVienService = nhanVienService;
    }

    @GetMapping()
    public String index(Model model) {
        Map<String, Gender> gender = new LinkedHashMap<>();
        gender.put(Gender.Male.toString(), Gender.Male);
        gender.put(Gender.Female.toString(), Gender.Female);
        model.addAttribute("gender", gender);
        model.addAttribute("page", "employee/index");
        return "admin/main";
    }

    @GetMapping("/create")
    public String formCreate(Model model) {
        model.addAttribute("positions", chucVuService.getAll());
        Map<String, String> gender = new LinkedHashMap<>();
        gender.put(Gender.Male.toString(), Gender.Male.getLabel());
        gender.put(Gender.Female.toString(), Gender.Female.getLabel());
        model.addAttribute("gender", gender);
        NhanVien nv = NhanVien.builder().gioiTinh(Gender.Male.toString()).build();
        model.addAttribute("employee", nv);
        model.addAttribute("btnText", "Thêm Nhân Viên");
        model.addAttribute("action", "/admin/employee/create");
        model.addAttribute("page", "employee/form");
        return "admin/main";
    }

    @GetMapping("/update/{id}")
    public String formUpdate(@PathVariable Long id, Model model) {
        model.addAttribute("positions", chucVuService.getAll());
        Optional<NhanVien> otp = nhanVienService.findById(id);
        if (otp.isEmpty()) return "redirect:/admin/employee";
        Map<String, String> gender = new LinkedHashMap<>();
        gender.put(Gender.Male.toString(), Gender.Male.getLabel());
        gender.put(Gender.Female.toString(), Gender.Female.getLabel());
        model.addAttribute("gender", gender);
        model.addAttribute("employee", otp.get());
        model.addAttribute("btnText", "Cập Nhật");
        model.addAttribute("action", "/admin/employee/update");
        model.addAttribute("page", "employee/form");
        return "admin/main";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("employeeId", id);
        model.addAttribute("page", "employee/detail");
        return "admin/main";
    }

    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<?> detailApi(@RequestBody Long id) {
        NhanVienDTO nv = nhanVienService.detailCustomer(id);
        return new ResponseEntity<>(ResponseObject.builder().data(nv).build(), HttpStatus.OK);
    }

    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> getNhanVien(@RequestParam String search) {
        List<NhanVienDTO> lst = nhanVienService.findAllCustomer(search);
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute("employee") NhanVienDTO req,
                         BindingResult br, HttpSession session) {
        // chặn thủ công (phòng trường hợp có lệch múi giờ/format)
        if (req.getNgaySinh() != null && req.getNgaySinh().toInstant()
                .isAfter(java.time.Instant.now())) {
            br.rejectValue("ngaySinh", "dob.future", "Ngày sinh không được lớn hơn hôm nay");
        }
        if (br.hasErrors()) {
            session.setAttribute("error",
                    br.getFieldError("ngaySinh") != null
                            ? br.getFieldError("ngaySinh").getDefaultMessage()
                            : "Dữ liệu không hợp lệ");
            return "redirect:/admin/employee/create";
        }
        nhanVienService.createCustomer(req);
        session.setAttribute("success", "Thêm nhân viên thành công!");
        return "redirect:/admin/employee";
    }

    @PostMapping("/update")
    public String update(@Valid @ModelAttribute("employee") NhanVienDTO req,
                         BindingResult br, HttpSession session) {
        if (req.getNgaySinh() != null && req.getNgaySinh().toInstant()
                .isAfter(java.time.Instant.now())) {
            br.rejectValue("ngaySinh", "dob.future", "Ngày sinh không được lớn hơn hôm nay");
        }
        if (br.hasErrors()) {
            session.setAttribute("error",
                    br.getFieldError("ngaySinh") != null
                            ? br.getFieldError("ngaySinh").getDefaultMessage()
                            : "Dữ liệu không hợp lệ");
            return "redirect:/admin/employee/update/" + req.getId();
        }
        nhanVienService.updateCustomer(req);
        session.setAttribute("success", "Cập nhật nhân viên thành công!");
        return "redirect:/admin/employee";
    }

}
