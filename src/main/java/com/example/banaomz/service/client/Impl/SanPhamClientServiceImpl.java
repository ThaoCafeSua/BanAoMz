package com.example.banaomz.service.client.Impl;

import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.client.IMauSacOption;
import com.example.banaomz.entity.client.IProductItemClient;
import com.example.banaomz.entity.client.ISizeOption;
import com.example.banaomz.entity.client.IVariantCombo;
import com.example.banaomz.entity.client.IVariantItem;
import com.example.banaomz.repository.client.ISanPhamClientRepository;
import com.example.banaomz.repository.client.SanPhamChiTietClientRepository;
import com.example.banaomz.service.client.ISanPhamClientService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional(readOnly = true)
public class SanPhamClientServiceImpl
        extends BaseServiceImpl<SanPham, Long, ISanPhamClientRepository>
        implements ISanPhamClientService {

    private final SanPhamChiTietClientRepository spctRepo;

    public SanPhamClientServiceImpl(SanPhamChiTietClientRepository spctRepo) {
        this.spctRepo = spctRepo;
    }


    @Override
    public List<IProductItemClient> getSanPhamMoiNhat(String search, String status) {
        return repository.getSanPhamMoiNhat(norm(search), status);
    }

    @Override
    public List<IProductItemClient> getTop10SanPhamBanChay() {
        return repository.getTop10SanPhamBanChay();
    }

    @Override
    public IProductItemClient getSanPhamById(Long id) {
        if (id == null) return null;
        return repository.getSanPhamById(id);
    }

    @Override
    public List<IMauSacOption> getMauSacBySanPhamId(Long id) {
        if (id == null) return List.of();
        return repository.getMauSacBySanPhamId(id);
    }

    @Override
    public List<ISizeOption> getSizesBySanPhamId(Long id) {
        if (id == null) return List.of();
        return repository.getSizesBySanPhamId(id);
    }

    @Override
    public List<IVariantCombo> getVariantCombos(Long id) {
        if (id == null) return List.of();
        return repository.getVariantCombos(id);
    }

    @Override
    public List<IVariantItem> getVariantItems(Long spId) {
        if (spId == null) return List.of();
        return repository.getVariantItems(spId);
    }

    @Override
    public Optional<Long> resolveSpctId(Long spId, Long mauId, Long sizeId) {
        if (spId == null || mauId == null || sizeId == null) return Optional.empty();
        return spctRepo.findSpctId(spId, mauId, sizeId);
    }

    // ---- helpers ----
    private String norm(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}