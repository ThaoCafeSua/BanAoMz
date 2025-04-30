package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.sanPham.ThuongHieuDTO;
import com.example.banaomz.entity.admin.ThuongHieu;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface IThuongHieuService extends IBaseService<ThuongHieu,Long> {
    List<ThuongHieuDTO> findAllThuongHieu(String value);
    ThuongHieuDTO createThuongHieu(ThuongHieuDTO dto);
    ThuongHieuDTO updateThuongHieu(ThuongHieuDTO dto);
    ThuongHieuDTO detailThuongHieu(Long id);
}
