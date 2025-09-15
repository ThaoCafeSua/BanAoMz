package com.example.banaomz.dto.admin.thongKe;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ThongKeThangDTO {
    private Integer month;
    private BigDecimal doanhThu;
    private Long soLuongBan;
}
