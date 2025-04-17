package com.example.banaomz.dto.admin.sales;

import com.example.banaomz.entity.admin.MauSac;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.admin.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SanPhamSalesDTO {
    private int id;
    private MauSac mauSac;
    private Size size;
    private SanPham sanPham;
    private String urlAnh;
    private Integer soLuong;
    private String maVach;
    private Double giaBan;
    private Boolean trangThai;
}
