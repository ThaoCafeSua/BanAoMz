package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.nhanVien.NhanVienDTO;
import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface INhanVienService extends IBaseService<NhanVien, Long> {
    List<NhanVienDTO> findAllCustomer(String search);

    NhanVienDTO createCustomer(NhanVienDTO nhanVienDTO);

    NhanVienDTO updateCustomer(NhanVienDTO nhanVienDTO);

    NhanVienDTO detailCustomer(Long customerId);



}
