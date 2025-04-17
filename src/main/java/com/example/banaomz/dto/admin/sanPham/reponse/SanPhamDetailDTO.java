package com.example.banaomz.dto.admin.sanPham.reponse;

import com.example.banaomz.dto.admin.sanPham.DanhMucDTO;
import com.example.banaomz.dto.admin.sanPham.ThuongHieuDTO;
import com.example.banaomz.dto.admin.sanPham.XuatXuDTO;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SanPhamDetailDTO {

    private Long id;

    private String tenSanPham;

    private DanhMucDTO danhMuc;

    private ThuongHieuDTO thuongHieu;

    private XuatXuDTO xuatXu;

    private String trangThai;

    private String urlAnh;

    private List<SanPhamChiTietDTO> lstChiTietSanPham;

}
