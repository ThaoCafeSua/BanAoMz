package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.entity.admin.MauSac;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface IMauSacService extends IBaseService<MauSac,Long> {
    List<MauSacDTO> findAllMauSac(String value);
    MauSacDTO createMauSac(MauSacDTO dto);
    MauSacDTO updateMauSac(MauSacDTO dto);
    MauSacDTO detailMauSac(Long id);
}
