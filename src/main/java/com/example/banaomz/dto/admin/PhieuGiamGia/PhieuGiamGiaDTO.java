package com.example.banaomz.dto.admin.PhieuGiamGia;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
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

    @NotBlank(message = "Mã phiếu giảm giá không được để trống")
    private String maPhieuGiamGia;

    @NotBlank(message = "Tên phiếu giảm giá không được để trống")
    private String tenPhieuGiamGia;

    @NotNull(message = "Giá trị giảm không được để trống")
    @Positive(message = "Giá trị giảm phải lớn hơn 0")
    private BigDecimal giaTriGiam;

    @NotNull(message = "Điều kiện áp dụng không được để trống")
    @Min(value = 0, message = "Điều kiện áp dụng không được âm")
    private BigDecimal dieuKienApDung;

    @NotNull(message = "Ngày bắt đầu không được để trống")
    private LocalDate ngayBatDau;

    @NotNull(message = "Ngày kết thúc không được để trống")
    private LocalDate ngayKetThuc;

    @NotNull(message = "Số lượng không được để trống")
    @Min(value = 1, message = "Số lượng phải ít nhất là 1")
    private Integer soLuong;
    private String moTa;
    private String trangThai;
}
