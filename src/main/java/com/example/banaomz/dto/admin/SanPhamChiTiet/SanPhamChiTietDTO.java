package com.example.banaomz.dto.admin.SanPhamChiTiet;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class SanPhamChiTietDTO {
    private Long id;
    private String tenSanPham;
    private String tenMauSac;
    private String tenSize;
    private BigDecimal giaBan;
    private String maVach;
    private Integer soLuong;
    private String urlAnh;
}
