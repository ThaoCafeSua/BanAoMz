package com.example.banaomz.service.admin.Impl;


import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.entity.admin.DiaChi;
import com.example.banaomz.repository.admin.IDiaChiRepository;
import com.example.banaomz.service.admin.IDiaChiService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DiaChiServiceImpl extends BaseServiceImpl<DiaChi, Long, IDiaChiRepository>
        implements IDiaChiService {
    @Autowired
    ModelMapper modelMapper;
    @Override
    public List<DiaChiDTO> getLstAddressByCustomer(Long idCustomer) {
        List<DiaChiDTO> lstDiaChi = repository.findDiaChiByCustomer(idCustomer)
                .stream().map(diaChi -> modelMapper.map(diaChi,DiaChiDTO.class)).toList();
        return lstDiaChi;
    }
}
