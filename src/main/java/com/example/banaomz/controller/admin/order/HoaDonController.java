package com.example.banaomz.controller.admin.order;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.service.admin.IHoaDonService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/admin/hoaDon")
public class HoaDonController {

    @Autowired
    private IHoaDonRepository hoaDonRepository;
    @Autowired
    private IHoaDonService hoaDonService;

    @GetMapping
    public String hienThiDanhSachHoaDon(Model model) {
        List<HoaDonResponseDTO> danhSach = hoaDonService.getAll();
        model.addAttribute("hoaDonList", danhSach);
        model.addAttribute("page", "order/hoaDon"); // trỏ tới: /WEB-INF/views/admin/hoaDon/danhSach.jsp
        return "/admin/header";
    }

    @GetMapping("/chiTiet/{id}")
    public String hienThiChiTiet(@PathVariable("id") Long id, Model model) {
        HoaDonDetailResponseDTO chiTiet = hoaDonService.getDetailById(id);
        model.addAttribute("hoaDonDetail", chiTiet);
        model.addAttribute("page", "order/hoaDonChiTiet");  // JSP hiển thị chi tiết
        return "/admin/header";
    }
    @GetMapping("/xuat-pdf/{id}")
    public void exportHoaDonPdf(@PathVariable("id") Long id, HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=hoa_don_" + id + ".pdf");

        hoaDonService.exportHoaDonPdf(id, response.getOutputStream());

        response.getOutputStream().flush();
    }
}
