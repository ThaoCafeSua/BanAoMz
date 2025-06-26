package com.example.banaomz.dto.admin.HoaDonChiTiet.Request;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class HoaDonChiTietRequestDTO {
    private Long idSanPhamChiTiet;
    private Integer soLuong;
    private BigDecimal giaBan;
    private BigDecimal giaGiam;
    private BigDecimal giaGoc;
}