package com.example.banaomz.dto.admin.sanPham;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class XuatXuDTO {
    private Long id;
    @NotNull(message = "Tên xuất xứ không được để trống")  // Kiểm tra không null
    @Size(min = 1, max = 50, message = "Tên xuất xứ phải từ 1 đến 50 ký tự")
    private String tenXuatXu;
}
