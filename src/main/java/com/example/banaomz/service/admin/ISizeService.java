package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import com.example.banaomz.entity.admin.Size;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface ISizeService extends IBaseService<Size, Long> {
    List<SizeDTO> findAllSize(String value);
    SizeDTO createSize(SizeDTO dto);
    SizeDTO updateSize(SizeDTO dto);
    SizeDTO detailSize(Long id);
}
