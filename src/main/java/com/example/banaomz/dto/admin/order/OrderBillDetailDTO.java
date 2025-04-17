package com.example.banaomz.dto.admin.order;

import com.example.banaomz.entity.admin.SanPhamChiTiet;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class OrderBillDetailDTO {
    private Long id;

    private SanPhamChiTiet sanPhamChiTiet;

    private BigDecimal giaBan;

    private BigDecimal giaGoc;

    private BigDecimal giaGiam;

    private Integer soLuong;

    private String moTa;
}
