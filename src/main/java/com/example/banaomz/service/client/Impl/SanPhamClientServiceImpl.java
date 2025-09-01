package com.example.banaomz.service.client.Impl;

import com.example.banaomz.entity.client.IMauSacOption;
import com.example.banaomz.entity.client.IProductItemClient;
import com.example.banaomz.entity.client.ISizeOption;
import com.example.banaomz.entity.client.IVariantCombo;
import com.example.banaomz.repository.client.ISanPhamClientRepository;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.service.client.ISanPhamClientService;
import org.springframework.stereotype.Service;
import com.example.banaomz.service.common.impl.BaseServiceImpl;

import java.util.List;

@Service
public class SanPhamClientServiceImpl extends BaseServiceImpl<SanPham, Long, ISanPhamClientRepository>
        implements ISanPhamClientService {

    @Override
    public List<IProductItemClient> getSanPhamMoiNhat(String search, String status) {
        return repository.getSanPhamMoiNhat(search, status);
    }

    @Override
    public List<IProductItemClient> getTop10SanPhamBanChay() {
        return repository.getTop10SanPhamBanChay();
    }

    @Override
    public IProductItemClient getSanPhamById(Long id) {
        return repository.getSanPhamById(id);
    }

    @Override
    public List<IMauSacOption> getMauSacBySanPhamId(Long id) {
        return repository.getMauSacBySanPhamId(id);
    }

    @Override
    public List<ISizeOption> getSizesBySanPhamId(Long id) {
        return repository.getSizesBySanPhamId(id);
    }

    @Override
    public List<IVariantCombo> getVariantCombos(Long id) {
        return repository.getVariantCombos(id);
    }
}