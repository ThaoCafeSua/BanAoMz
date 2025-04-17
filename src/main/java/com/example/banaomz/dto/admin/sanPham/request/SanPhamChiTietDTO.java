package com.example.banaomz.dto.admin.sanPham.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SanPhamChiTietDTO {
    private Long sanPhamId;
    private Long sizeId;
    private Long mauSacId;
    private String soLuong;
    private String giaBan;
}
