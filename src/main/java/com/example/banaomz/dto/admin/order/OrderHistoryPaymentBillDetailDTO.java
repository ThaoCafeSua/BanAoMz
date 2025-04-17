package com.example.banaomz.dto.admin.order;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class OrderHistoryPaymentBillDetailDTO {
    private Long id;

    private String maGiaoDich;

    private String loaiThanhToan;

    private BigDecimal soTienThanhToan;

    private String moTa;
}
