package com.example.banaomz.dto.admin.HoaDon.Reponse;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class HoaDonResponseDTO {
    private Long id;
    private String maHoaDon;
    private BigDecimal tongTien;
    private BigDecimal thanhTien;
    private String ngayTao;
    private String trangThai;
    private String loaiHoaDon;
}
