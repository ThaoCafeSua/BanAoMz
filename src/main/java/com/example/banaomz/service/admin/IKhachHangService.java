package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.dto.admin.khachHang.KhachHangDTO;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.service.common.IBaseService;

import java.util.List;

public interface IKhachHangService extends IBaseService<KhachHang,Long> {

    List<KhachHangDTO> findAllCustomer(String value);

    KhachHangDTO createCustomer(KhachHangDTO khachHangDTO);

    KhachHangDTO updateCustomer(KhachHangDTO khachHangDTO);

    KhachHangDTO detailCustomer(Long customerId);

    DiaChiDTO addressCustomer(DiaChiDTO req);



}

