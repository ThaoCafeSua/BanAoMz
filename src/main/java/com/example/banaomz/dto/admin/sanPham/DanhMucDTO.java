package com.example.banaomz.dto.admin.sanPham;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DanhMucDTO {
    private Long id;
    @NotNull(message = "Tên danh mục không được để trống")
    @Size(min = 1, max = 50, message = "Tên danh mục phải từ 1 đến 50 ký tự")
    private String tenDanhMuc;
}
