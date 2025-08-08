package com.example.banaomz.dto.admin.GioHang;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GioHangDTO {
    private Integer  id;
    private Long idSanPhamChiTiet;
    private String tenSanPham;
    private String tenMauSac;
    private String tenSize;
    private BigDecimal giaBan;
    private Integer soLuong;
    private BigDecimal tongTien;
}
