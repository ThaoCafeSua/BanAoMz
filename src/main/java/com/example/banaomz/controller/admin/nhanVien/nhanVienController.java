package com.example.banaomz.controller.admin.nhanVien;

        import com.example.banaomz.dto.admin.nhanVien.NhanVienDTO;
        import com.example.banaomz.dto.admin.ResponseObject;
        import com.example.banaomz.entity.admin.NhanVien;
        import com.example.banaomz.enums.Gender;
        import com.example.banaomz.service.admin.IChucVuService;
        import com.example.banaomz.service.admin.INhanVienService;

        import org.modelmapper.ModelMapper;
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
@RequestMapping("/admin/employee")
public class nhanVienController {
    @Autowired
        private IChucVuService chucVuService;

    @Autowired
    private INhanVienService nhanVienService;

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
        model.addAttribute("positions", chucVuService.getAll()); // <- Thêm dòng này
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
        model.addAttribute("positions", chucVuService.getAll()); // <- Thêm dòng này
        Optional<NhanVien> otp = nhanVienService.findById(id);
        if (otp.isEmpty())
            return "redirect:/admin/employee";
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
        model.addAttribute("page", "employee/detail"); // bạn đã có trang detail.jsp
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
        List<NhanVienDTO> lst = nhanVienService.findAllCustomer(search); // hoặc findAllNhanVien
        return new ResponseEntity<>(ResponseObject.builder().data(lst).build(), HttpStatus.OK);
    }

    @PostMapping("/create")
    public String create(@ModelAttribute NhanVienDTO req) {
        nhanVienService.createCustomer(req);
        return "redirect:/admin/employee";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute NhanVienDTO req) {
        nhanVienService.updateCustomer(req);
        return "redirect:/admin/employee";
    }
}
