package com.example.banaomz.dto.admin.khachHang;

import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class KhachHangDTO {
    private Long id;
    private String hoVaTen;
    private String ngaySinh;
    private String gioiTinh;
    private String email;
    private String soDienThoai;
    private List<DiaChiDTO> lstDiaChi;
}
