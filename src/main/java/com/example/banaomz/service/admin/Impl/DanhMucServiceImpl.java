package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.sanPham.DanhMucDTO;
import com.example.banaomz.entity.admin.DanhMuc;
import com.example.banaomz.exception.AppException;
import com.example.banaomz.exception.ErrorCode;
import com.example.banaomz.repository.admin.IDanhMucRepository;
import com.example.banaomz.service.admin.IDanhMucService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DanhMucServiceImpl extends BaseServiceImpl<DanhMuc, Long, IDanhMucRepository>
        implements IDanhMucService {

    @Autowired
    ModelMapper modelMapper;

    @Override
    public List<DanhMucDTO> findAllDanhMuc(String value) {
        List<DanhMucDTO> lst = repository.findAll(value).stream()
                .map(item -> modelMapper.map(item, DanhMucDTO.class)).toList();
        return lst;
    }

    @Override
    public DanhMucDTO createDanhMuc(DanhMucDTO dto) {
        DanhMuc entity = modelMapper.map(dto, DanhMuc.class);
        createNew(entity);
        return dto;
    }

    @Override
    public DanhMucDTO updateDanhMuc(DanhMucDTO dto) {
        DanhMuc entity = findById(dto.getId()).
                orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        modelMapper.map(dto, entity);
        update(entity);
        return dto;
    }

    @Override
    public DanhMucDTO detailDanhMuc(Long id) {
        Optional<DanhMuc> entity = findById(id);
        if (entity.isEmpty()){
            return null;
        }
        DanhMucDTO data = modelMapper.map(entity, DanhMucDTO.class);
        return data;
    }
}
