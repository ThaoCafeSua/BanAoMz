package com.example.banaomz.service.client;

import com.example.banaomz.entity.client.IMauSacOption;
import com.example.banaomz.entity.client.IProductItemClient;
import com.example.banaomz.entity.client.ISizeOption;
import com.example.banaomz.entity.client.IVariantCombo;
import com.example.banaomz.service.common.IBaseService;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDTO;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.client.IVariantItem;

import java.util.List;
import java.util.Optional;

public interface ISanPhamClientService extends IBaseService<SanPham, Long> {

    List<IProductItemClient> getSanPhamMoiNhat(String search, String status);

    List<IProductItemClient> getTop10SanPhamBanChay();

    IProductItemClient getSanPhamById(Long id);

    List<IMauSacOption> getMauSacBySanPhamId(Long id);

    List<ISizeOption> getSizesBySanPhamId(Long id);

    List<IVariantCombo> getVariantCombos(Long id);

    List<IVariantItem> getVariantItems(Long spId);

    Optional<Long> resolveSpctId(Long spId, Long mauId, Long sizeId);

}