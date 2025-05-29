package com.example.banaomz.service.admin;



import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.entity.admin.DiaChi;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface IDiaChiService extends IBaseService<DiaChi,Long> {
    List<DiaChiDTO> getLstAddressByCustomer(Long idCustomer);
}

