package com.example.banaomz.dto.admin.PhieuGiamGia;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

@Getter
@Setter
public class PhieuGiamGiaDTO {
    private Long id;
    private String maPhieuGiamGia;
    private String tenPhieuGiamGia;
    private BigDecimal giaTriGiam;
    private BigDecimal dieuKienApDung;
    private LocalDate ngayBatDau;
    private LocalDate ngayKetThuc;
    private Integer soLuong;
    private String moTa;
    private String trangThai;
}
