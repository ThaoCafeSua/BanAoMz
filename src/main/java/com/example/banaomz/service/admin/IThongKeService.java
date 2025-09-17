package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.thongKe.DoanhThuDTO;

import com.example.banaomz.dto.admin.thongKe.ThongKeThangDTO;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public interface IThongKeService {
    DoanhThuDTO getSummaryTodayMonthYear();
    List<ThongKeThangDTO> getMonthlyStats(int year);
    BigDecimal getRevenueBetween(LocalDateTime start, LocalDateTime end);

}
