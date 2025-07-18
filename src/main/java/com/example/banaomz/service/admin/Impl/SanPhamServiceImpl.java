package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDetailDTO;
import com.example.banaomz.entity.admin.*;
import com.example.banaomz.enums.Status;
import com.example.banaomz.repository.admin.ISanPhamChiTietRepository;
import com.example.banaomz.repository.admin.ISanPhamRepository;
import com.example.banaomz.service.admin.*;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SanPhamServiceImpl extends BaseServiceImpl<SanPham, Long, ISanPhamRepository>
        implements ISanPhamService {

    @Autowired
    IDanhMucService danhMucService;
    @Autowired
    IXuatXuService xuatXuService;
    @Autowired
    IThuongHieuService thuongHieuService;

    @Autowired
    IMauSacService mauSacService;

    @Autowired
    ISizeService sizeService;
    @Autowired
    ISanPhamChiTietRepository sanPhamChiTietRepository;

    @Autowired
    ModelMapper modelMapper;

    @Override
    public List<IProductItem> getLstProductGroup(String search, String status) {
        return repository.getLstProductGroup(search, status);
    }

    @Override
    public SanPhamDTO createSanPham(SanPhamDTO dto) {
        ThuongHieu thuongHieu = thuongHieuService.findById(dto.getThuongHieu()).orElseThrow();
        DanhMuc danhMuc = danhMucService.findById(dto.getDanhMuc()).orElseThrow();
        XuatXu xuatXu = xuatXuService.findById(dto.getXuatXu()).orElseThrow();
        SanPham sanPham = SanPham.builder()
                .tenSanPham(dto.getTenSanPham())
                .danhMuc(danhMuc)
                .maSanPham(genMaSanPham())
                .xuatXu(xuatXu)
                .thuongHieu(thuongHieu)
                .trangThai(dto.getTrangThai())
                .urlAnh(dto.getUrlAnh())
                .build();
        SanPham sanPhamEntity = createNew(sanPham);

        List<SanPhamChiTiet> listSanPhamChiTiet = dto.getLstChiTietSanPham().stream()
                .map(item -> {
                    MauSac mauSac = mauSacService.findById(item.getMauSacId()).orElseThrow();
                    Size size = sizeService.findById(item.getSizeId()).orElseThrow();
                    int qty = Integer.parseInt(item.getSoLuong());
                    BigDecimal price = BigDecimal.valueOf(Double.parseDouble(item.getGiaBan()));
                    SanPhamChiTiet entity = SanPhamChiTiet.builder()
                            .size(size)
                            .mauSac(mauSac)
                            .sanPham(sanPhamEntity)
                            .soLuong(qty)
                            .giaBan(price)
                            .trangThai(qty == 0 ? Status.NGUNG_HOAT_DONG.name() : Status.HOAT_DONG.name())
                            .build();
                    return entity;
                })
                .collect(Collectors.toList());
        sanPhamChiTietRepository.saveAll(listSanPhamChiTiet);
        return dto;
    }

    @Override
    public SanPhamDTO updateSanpham(SanPhamDTO dto) {
        SanPham sanPham = findById(dto.getId()).orElseThrow();
        ThuongHieu thuongHieu = thuongHieuService.findById(dto.getThuongHieu()).orElseThrow();
        DanhMuc danhMuc = danhMucService.findById(dto.getDanhMuc()).orElseThrow();
        XuatXu xuatXu = xuatXuService.findById(dto.getXuatXu()).orElseThrow();
        sanPham.setTenSanPham(dto.getTenSanPham());
        sanPham.setDanhMuc(danhMuc);
        sanPham.setXuatXu(xuatXu);
        sanPham.setThuongHieu(thuongHieu);
        sanPham.setTrangThai(dto.getTrangThai());
        sanPham.setUrlAnh(dto.getUrlAnh());

        List<SanPhamChiTiet> listSanPhamChiTiet = dto.getLstChiTietSanPham().stream()
                .map(item -> {
                    int qty = Integer.parseInt(item.getSoLuong());
                    BigDecimal price = BigDecimal.valueOf(Double.parseDouble(item.getGiaBan()));
                    Optional<SanPhamChiTiet> otp = sanPhamChiTietRepository
                            .findSanPhamChiTietBySanPham(
                                    dto.getId(),
                                    item.getSizeId(),
                                    item.getMauSacId()
                            );
                    if (otp.isPresent()) {
                        SanPhamChiTiet entity = otp.get();
                        entity.setSoLuong(qty);
                        entity.setGiaBan(price);
                        entity.setTrangThai(item.getTrangThai());
                        return entity;
                    } else {
                        MauSac mauSac = mauSacService.findById(item.getMauSacId()).orElseThrow();
                        Size size = sizeService.findById(item.getSizeId()).orElseThrow();
                        return SanPhamChiTiet.builder()
                                .size(size)
                                .mauSac(mauSac)
                                .sanPham(sanPham)
                                .soLuong(qty)
                                .giaBan(price)
                                .trangThai(qty == 0 ? Status.NGUNG_HOAT_DONG.name() : Status.HOAT_DONG.name())
                                .build();
                    }
                })
                .collect(Collectors.toList());

        sanPhamChiTietRepository.saveAll(listSanPhamChiTiet);
        update(sanPham);
        return dto;
    }

    @Override
    public SanPhamDetailDTO detailSanpham(Long sanPhamId) {
        SanPham sanPham = findById(sanPhamId).orElseThrow();
        SanPhamDetailDTO data = modelMapper.map(sanPham, SanPhamDetailDTO.class);
        return data;
    }

    private String genMaSanPham() {
        long count = repository.count();
        String stt = String.format("%02d", count + 1);
        return "SP" + stt;
    }
}
