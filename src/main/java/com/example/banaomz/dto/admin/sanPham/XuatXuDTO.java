package com.example.banaomz.dto.admin.sanPham;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class XuatXuDTO {
    private Long id;
    @NotNull(message = "Tên xuất xứ không được để trống")
    @Size(min = 1, max = 50, message = "Tên xuất xứ phải từ 1 đến 50 ký tự")
    private String tenXuatXu;
    @NotNull(message = "Trạng thái không được để trống")
    private String trangThai;
}
