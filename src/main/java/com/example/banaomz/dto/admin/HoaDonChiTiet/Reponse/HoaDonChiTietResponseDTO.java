package com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HoaDonChiTietResponseDTO {
    private String tenSanPham;
    private String mauSac;
    private String size;
    private Integer soLuong;
    private BigDecimal giaBan;
    private BigDecimal thanhTien;
}
