package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.enums.Status;
import com.example.banaomz.repository.admin.ISanPhamChiTietRepository;
import com.example.banaomz.service.admin.IMauSacService;
import com.example.banaomz.service.admin.ISanPhamChiTietService;
import com.example.banaomz.service.admin.ISanPhamService;
import com.example.banaomz.service.admin.ISizeService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SanPhamChiTietServiceImpl extends BaseServiceImpl<SanPhamChiTiet, Long, ISanPhamChiTietRepository>
        implements ISanPhamChiTietService {

    @Autowired
    ISanPhamService sanPhamService;

    @Autowired
    IMauSacService mauSacService;

    @Autowired
    ISizeService sizeService;

    @Override
    public List<SanPhamChiTiet> findLstSanPhamChiTiet(String search) {
        List<SanPhamChiTiet> lst = repository.findLstSanPhamChiTiet(search, Status.HOAT_DONG.toString());
        return lst;
    }


}
