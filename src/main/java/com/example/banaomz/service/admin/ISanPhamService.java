package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDetailDTO;
import com.example.banaomz.entity.admin.IProductItem;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface ISanPhamService extends IBaseService<SanPham,Long> {
    List<IProductItem> getLstProductGroup(String search, String status);

    SanPhamDTO createSanPham(SanPhamDTO sanPhamDTO);

    SanPhamDTO updateSanpham(SanPhamDTO sanPhamDTO);

    SanPhamDetailDTO detailSanpham(Long sanPhamId);

}
