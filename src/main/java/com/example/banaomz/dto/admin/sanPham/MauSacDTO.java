package com.example.banaomz.dto.admin.sanPham;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MauSacDTO {
    private Long id;
    @NotNull(message = "Tên màu sắc không được để trống")
    @Size(min = 1, max = 50, message = "Tên màu sắc phải từ 1 đến 50 ký tự")
    private String tenMauSac;
}
