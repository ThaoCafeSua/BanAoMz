package com.example.banaomz.dto.admin.sanPham.reponse;

import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SanPhamTaiQuayViewModel {
    private Long id;
    private Long idSanPham;
    private String tenSanPham;
    private int soLuongTon;
    private String urlAnh;
    private BigDecimal giaBan;
    private List<MauSacDTO> listMauSac;
    private List<SizeDTO> listKichThuoc;
}
