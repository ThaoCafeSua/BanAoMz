package com.example.banaomz.service.admin.Impl;


import com.example.banaomz.dto.admin.sanPham.SizeDTO;
import com.example.banaomz.entity.admin.Size;
import com.example.banaomz.exception.AppException;
import com.example.banaomz.exception.ErrorCode;
import com.example.banaomz.repository.admin.ISizeRepo;
import com.example.banaomz.service.admin.ISizeService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class SizeServiceImpl extends BaseServiceImpl<Size, Long, ISizeRepo> implements ISizeService {
    @Autowired
    ModelMapper modelMapper;
    @Override
    public List<SizeDTO> findAllSize(String value) {
        List<SizeDTO> list = repository.findAllStaff(value).stream()
                .map(item -> modelMapper.map(item, SizeDTO.class))
                .toList();
        return list;
    }

    @Override
    public SizeDTO createSize(SizeDTO dto) {
        Size entity = modelMapper.map(dto, Size.class);
        Size khoiLuong = createNew(entity);
        return modelMapper.map(khoiLuong, SizeDTO.class);
    }

    @Override
    public SizeDTO updateSize(SizeDTO dto) {
        Size entity = findById(dto.getId()).
                orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        modelMapper.map(dto, entity);
        update(entity);
        return dto;
    }

    @Override
    public SizeDTO detailSize(Long id) {
        Optional<Size> entity = findById(id);
        if (entity.isEmpty()){
            return null;
        }
        SizeDTO data = modelMapper.map(entity.get(), SizeDTO.class);
        return data;
    }
}
