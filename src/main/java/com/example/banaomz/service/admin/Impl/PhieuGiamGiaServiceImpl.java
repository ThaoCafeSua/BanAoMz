package com.example.banaomz.service.admin.Impl;

import java.util.List;
import java.util.Optional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.banaomz.dto.admin.PhieuGiamGia.PhieuGiamGiaDTO;
import com.example.banaomz.dto.admin.sanPham.MauSacDTO;
import com.example.banaomz.entity.admin.MauSac;
import com.example.banaomz.entity.admin.PhieuGiamGia;
import com.example.banaomz.exception.AppException;
import com.example.banaomz.exception.ErrorCode;
import com.example.banaomz.repository.admin.IPhieuGiamGiaRepository;
import com.example.banaomz.service.admin.IPhieuGiamGiaService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;

@Service
public class PhieuGiamGiaServiceImpl extends BaseServiceImpl<PhieuGiamGia, Long, IPhieuGiamGiaRepository>
        implements IPhieuGiamGiaService {

    @Autowired
    ModelMapper modelMapper;

    @Override
    public List<PhieuGiamGiaDTO> findAllPhieuGiamGia(String value) {
        List<PhieuGiamGiaDTO> list = repository.findAllVoucher(value).stream()
                .map(entity -> {
                    PhieuGiamGiaDTO dto = modelMapper.map(entity, PhieuGiamGiaDTO.class);
                    if (entity.getNgayBatDau() != null) {
                        dto.setNgayBatDau(entity.getNgayBatDau().toLocalDate());
                    }
                    return dto;
                })
                .toList();
        return list;
    }

    @Override
    public PhieuGiamGiaDTO createPhieuGiamGia(PhieuGiamGiaDTO dto) {
        PhieuGiamGia entity = modelMapper.map(dto, PhieuGiamGia.class);
        entity.setNgayBatDau(dto.getNgayBatDau().atStartOfDay());
        PhieuGiamGia phieuGiamGia = createNew(entity);
        return modelMapper.map(phieuGiamGia, PhieuGiamGiaDTO.class);
    }

    @Override
    public PhieuGiamGiaDTO updatePhieuGiamGia(PhieuGiamGiaDTO dto) {
        PhieuGiamGia entity = findById(dto.getId())
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        modelMapper.map(dto, entity);
        if (dto.getNgayBatDau() != null) {
            entity.setNgayBatDau(dto.getNgayBatDau().atStartOfDay());
        }
        update(entity);
        return dto;
    }

    @Override
    public PhieuGiamGiaDTO detailPhieuGiamGia(Long id) {
        Optional<PhieuGiamGia> entity = findById(id);
        if (entity.isEmpty()) {
            return null;
        }
        PhieuGiamGiaDTO data = modelMapper.map(entity.get(), PhieuGiamGiaDTO.class);
        if (entity.get().getNgayBatDau() != null) {
            data.setNgayBatDau(entity.get().getNgayBatDau().toLocalDate());
        }
        return data;
    }
}
