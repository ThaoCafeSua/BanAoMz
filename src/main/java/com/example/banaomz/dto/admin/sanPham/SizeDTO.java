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
public class SizeDTO {
    private Long id;
    @NotNull(message = "Tên size không được để trống")
    @Size(min = 1, max = 50, message = "Tên size phải từ 1 đến 50 ký tự")
    private String tenSize;
}
