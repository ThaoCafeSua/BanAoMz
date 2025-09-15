package com.example.banaomz.controller.admin.ThongKe;

import com.example.banaomz.dto.admin.thongKe.DoanhThuDTO;
import com.example.banaomz.dto.admin.thongKe.ThongKeThangDTO;
import com.example.banaomz.dto.common.ApiResponse;
import com.example.banaomz.service.admin.IThongKeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class ThongKeController {

    @GetMapping({"/home", "", "/"})
    public String home(Model model) {
        model.addAttribute("page", "dashboard/index");
        return "admin/main";
    }
    @Autowired
    private IThongKeService thongKeService;

    @GetMapping("/doanh-thu")
    public ResponseEntity<ApiResponse<DoanhThuDTO>> getSummary() {
        return ResponseEntity.ok(ApiResponse.ok(thongKeService.getSummaryTodayMonthYear()));
    }

    @GetMapping("/doanh-thu-table")
    public ResponseEntity<ApiResponse<List<ThongKeThangDTO>>> getMonthlyTable(
            @RequestParam(value = "year", required = false) Integer year
    ) {
        int y = (year == null ? LocalDate.now().getYear() : year);
        return ResponseEntity.ok(ApiResponse.ok(thongKeService.getMonthlyStats(y)));
    }

    @GetMapping("/doanh-thu-khoang-ngay")
    public ResponseEntity<ApiResponse<BigDecimal>> getRevenueBetween(
            @RequestParam String startDate, // yyyy-MM-dd
            @RequestParam String endDate    // yyyy-MM-dd
    ) {
        LocalDate s = LocalDate.parse(startDate);
        LocalDate e = LocalDate.parse(endDate);
        if (e.isBefore(s)) {
            return ResponseEntity.badRequest().body(ApiResponse.fail("endDate phải >= startDate"));
        }
        LocalDateTime start = s.atStartOfDay();
        LocalDateTime end   = e.plusDays(1).atStartOfDay(); // exclusive
        return ResponseEntity.ok(ApiResponse.ok(thongKeService.getRevenueBetween(start, end)));
    }
}
