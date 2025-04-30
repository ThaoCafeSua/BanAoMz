package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.DanhMucDTO;
import com.example.banaomz.entity.admin.DanhMuc;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface IDanhMucService extends IBaseService<DanhMuc, Long> {
    List<DanhMucDTO> findAllDanhMuc(String value);
    DanhMucDTO createDanhMuc(DanhMucDTO dto);
    DanhMucDTO updateDanhMuc(DanhMucDTO dto);
    DanhMucDTO detailDanhMuc(Long id);
}
