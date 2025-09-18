package com.example.banaomz.service.admin;

import com.example.banaomz.dto.ghn.AvailableServiceDTO;
import com.example.banaomz.dto.ghn.DistrictDTO;
import com.example.banaomz.dto.ghn.FeeRequestDTO;
import com.example.banaomz.dto.ghn.FeeResultDTO;
import com.example.banaomz.dto.ghn.ProvinceDTO;
import com.example.banaomz.dto.ghn.WardDTO;

import java.util.List;

public interface IGhnShippingService {
    List<AvailableServiceDTO> getAvailableServices(Integer toDistrictId, String toWardCode);


    default List<AvailableServiceDTO> getAvailableServices(Integer toDistrictId) {
        return getAvailableServices(toDistrictId, null);
    }

    FeeResultDTO calculateFee(FeeRequestDTO req);

    List<ProvinceDTO> getProvinces();
    List<DistrictDTO> getDistricts(Integer provinceId);
    List<WardDTO>     getWards(Integer districtId);
}
