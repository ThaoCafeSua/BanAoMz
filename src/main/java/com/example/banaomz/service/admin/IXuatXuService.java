package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.XuatXuDTO;
import com.example.banaomz.entity.admin.XuatXu;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface IXuatXuService extends IBaseService<XuatXu,Long> {
    List<XuatXuDTO> findAllXuatXu(String value);
    XuatXuDTO createXuatXu(XuatXuDTO dto);
    XuatXuDTO updateXuatXu(XuatXuDTO dto);
    XuatXuDTO detailXuatXu(Long id);
}
