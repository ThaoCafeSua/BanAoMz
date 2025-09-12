package com.example.banaomz.dto.admin.GioHang;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDTO {
    private Long spctId;
    private String ten;
    private String anh;
    private BigDecimal gia;
    private Integer soLuong;

    private String mau;       // NEW: tên màu
    private String size;      // NEW: tên size
    private String tenHienThi;
}
