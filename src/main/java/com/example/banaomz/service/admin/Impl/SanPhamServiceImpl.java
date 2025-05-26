package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDTO;
import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDetailDTO;
import com.example.banaomz.entity.admin.*;
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
import java.util.Set;
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
        SanPham sanPham = SanPham.builder().tenSanPham(dto.getTenSanPham()).danhMuc(danhMuc)
                .maSanPham(genMaSanPham())
                .xuatXu(xuatXu).thuongHieu(thuongHieu)
                .trangThai(dto.getTrangThai())
                .urlAnh(dto.getUrlAnh())
                .build();
        SanPham sanPhamEntity = createNew(sanPham);
        List<SanPhamChiTiet> listSanPhamChiTiet = dto.getLstChiTietSanPham().stream().map(item -> {
            MauSac mauSac = mauSacService.findById(item.getMauSacId()).orElseThrow();
            Size size = sizeService.findById(item.getSizeId()).orElseThrow();
            SanPhamChiTiet entity = SanPhamChiTiet.builder()
                    .size(size)
                    .mauSac(mauSac)
                    .sanPham(sanPhamEntity)
                    .soLuong(Integer.valueOf(item.getSoLuong()))
                    .giaBan(BigDecimal.valueOf(Double.valueOf(item.getGiaBan())))
                    .build();
            return entity;
        }).toList();
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

        List<SanPhamChiTiet> listSanPhamChiTiet = dto.getLstChiTietSanPham().stream().map(item -> {
            item.setSanPhamId(dto.getId());  // Lỗi vì item là DTO, phải thay đổi
            Optional<SanPhamChiTiet> otp = sanPhamChiTietRepository.findSanPhamChiTietBySanPham(item);
            if (otp.isPresent()) {
                SanPhamChiTiet entity = otp.get();
                entity.setSoLuong(Integer.valueOf(item.getSoLuong()));
                entity.setGiaBan(BigDecimal.valueOf(Double.valueOf(item.getGiaBan())));
                return entity;
            } else {
                MauSac mauSac = mauSacService.findById(item.getMauSacId()).orElseThrow();
                Size size = sizeService.findById(item.getSizeId()).orElseThrow();
                SanPhamChiTiet entity = SanPhamChiTiet.builder()
                        .size(size)
                        .mauSac(mauSac)
                        .sanPham(sanPham) // Thay vì item.setSanPhamId(dto.getId())
                        .soLuong(Integer.valueOf(item.getSoLuong()))
                        .giaBan(BigDecimal.valueOf(Double.valueOf(item.getGiaBan())))
                        .build();
                return entity;
            }
        }).toList();

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
        long count = repository.count(); // tổng số sản phẩm đã có
        String stt = String.format("%04d", count + 1); // VD: 0001, 0002
        return "SP" + stt; // --> SP0001, SP0002...
    }



}
