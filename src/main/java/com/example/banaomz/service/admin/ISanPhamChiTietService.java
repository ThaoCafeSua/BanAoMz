package com.example.banaomz.service.admin;

import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface ISanPhamChiTietService extends IBaseService<SanPhamChiTiet,Long> {
    List<SanPhamChiTiet> findLstSanPhamChiTiet(String search);

}
