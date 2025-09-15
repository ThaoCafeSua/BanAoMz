package com.example.banaomz.dto.admin.thongKe;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MonthlyStatDTO {
    private Integer month;
    private BigDecimal doanhThu;
    private Long soLuongBan;
}
