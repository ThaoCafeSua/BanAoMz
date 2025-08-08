package com.example.banaomz.service.admin;

import java.util.List;

import com.example.banaomz.dto.admin.PhieuGiamGia.PhieuGiamGiaDTO;
import com.example.banaomz.entity.admin.PhieuGiamGia;
import com.example.banaomz.service.common.IBaseService;

public interface IPhieuGiamGiaService extends IBaseService<PhieuGiamGia, Long> {
    List<PhieuGiamGiaDTO> findAllPhieuGiamGia(String value);

    PhieuGiamGiaDTO createPhieuGiamGia(PhieuGiamGiaDTO phieuGiamGiaDTO);

    PhieuGiamGiaDTO updatePhieuGiamGia(PhieuGiamGiaDTO phieuGiamGiaDTO);

    PhieuGiamGiaDTO detailPhieuGiamGia(Long id);
}
