package com.example.banaomz.dto.admin.thongKe;

import lombok.*;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DoanhThuDTO {
    private BigDecimal day;
    private BigDecimal month;
    private BigDecimal year;
    private Integer  soLuongTon;
}
