package com.example.banaomz.dto.admin.sanPham.reponse;

import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SanPhamChiTietDTO {

    private Long id;

    private SizeDTO size;

    private MauSacDTO mauSac;

    private Integer soLuong;

    private Integer giaBan;
}
