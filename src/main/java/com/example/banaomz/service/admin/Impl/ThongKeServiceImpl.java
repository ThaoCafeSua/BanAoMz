package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.thongKe.DoanhThuDTO;
import com.example.banaomz.dto.admin.thongKe.ThongKeThangDTO;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.repository.admin.ISanPhamChiTietRepository;
import com.example.banaomz.service.admin.IThongKeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class ThongKeServiceImpl implements IThongKeService {

    private static final String TRANG_THAI_TINH_DOANH_THU = "HOAN_THANH";

    @Autowired
    private IHoaDonRepository hoaDonRepo;

    @Autowired
    private ISanPhamChiTietRepository sanPhamChiTietRepo;

    private static BigDecimal nz(BigDecimal v) {
        return v == null ? BigDecimal.ZERO : v;
    }

    @Override
    public DoanhThuDTO getSummaryTodayMonthYear() {
        // Day
        LocalDate today = LocalDate.now();
        LocalDateTime dStart = today.atStartOfDay();
        LocalDateTime dEnd   = today.plusDays(1).atStartOfDay();
        BigDecimal dayRevenue = hoaDonRepo
                .sumThanhTienByTrangThaiAndNgayHoanThanhBetween(TRANG_THAI_TINH_DOANH_THU, dStart, dEnd);

        // Month
        YearMonth ym = YearMonth.now();
        LocalDateTime mStart = ym.atDay(1).atStartOfDay();
        LocalDateTime mEnd   = ym.plusMonths(1).atDay(1).atStartOfDay();
        BigDecimal monthRevenue = hoaDonRepo
                .sumThanhTienByTrangThaiAndNgayHoanThanhBetween(TRANG_THAI_TINH_DOANH_THU, mStart, mEnd);

        // Year
        LocalDateTime yStart = LocalDate.of(today.getYear(), 1, 1).atStartOfDay();
        LocalDateTime yEnd   = LocalDate.of(today.getYear() + 1, 1, 1).atStartOfDay();
        BigDecimal yearRevenue = hoaDonRepo
                .sumThanhTienByTrangThaiAndNgayHoanThanhBetween(TRANG_THAI_TINH_DOANH_THU, yStart, yEnd);

        Integer tonKho = sanPhamChiTietRepo.sumSoLuongTon();

        return DoanhThuDTO.builder()
                .day(nz(dayRevenue))
                .month(nz(monthRevenue))
                .year(nz(yearRevenue))
                .soLuongTon(tonKho == null ? 0 : tonKho)
                .build();
    }

    @Override
    public List<ThongKeThangDTO> getMonthlyStats(int year) {
        List<Object[]> rows = hoaDonRepo.findMonthlyRevenueAndQty(year, TRANG_THAI_TINH_DOANH_THU);
        Map<Integer, ThongKeThangDTO> map = new HashMap<>();

        for (Object[] r : rows) {
            Integer month = ((Number) r[0]).intValue();
            BigDecimal doanhThu = (BigDecimal) r[1];
            Long soLuong = (r[2] instanceof Number) ? ((Number) r[2]).longValue() : 0L;

            map.put(month, ThongKeThangDTO.builder()
                    .month(month)
                    .doanhThu(nz(doanhThu))
                    .soLuongBan(soLuong == null ? 0L : soLuong)
                    .build());
        }

        // Trả đủ 12 tháng (điền 0 nếu thiếu)
        List<ThongKeThangDTO> result = new ArrayList<>(12);
        for (int m = 1; m <= 12; m++) {
            result.add(map.getOrDefault(m,
                    ThongKeThangDTO.builder()
                            .month(m)
                            .doanhThu(BigDecimal.ZERO)
                            .soLuongBan(0L)
                            .build()));
        }
        return result;
    }

    @Override
    public BigDecimal getRevenueBetween(LocalDateTime start, LocalDateTime end) {
        BigDecimal sum = hoaDonRepo
                .sumThanhTienByTrangThaiAndNgayHoanThanhBetween(TRANG_THAI_TINH_DOANH_THU, start, end);
        return nz(sum);
    }
}
