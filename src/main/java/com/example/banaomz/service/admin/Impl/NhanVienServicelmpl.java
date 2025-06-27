package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.nhanVien.NhanVienDTO;
import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.repository.admin.INhanVienRepository;
import com.example.banaomz.service.admin.IChucVuService;
import com.example.banaomz.service.admin.INhanVienService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class NhanVienServicelmpl extends BaseServiceImpl<NhanVien, Long, INhanVienRepository>
        implements INhanVienService {
        @Autowired private INhanVienRepository repository;
        @Autowired private IChucVuService chucVuService;
        @Autowired private ModelMapper modelMapper;

        public List<NhanVienDTO> findAllCustomer(String search) {
            return repository.findAllCustomer(search).stream().map(entity -> {
                NhanVienDTO dto = modelMapper.map(entity, NhanVienDTO.class);
                if (entity.getChucVu() != null) {
                    dto.setChucVuId(entity.getChucVu().getId());
                    dto.setChucVuTen(entity.getChucVu().getTenChucVu());
                }
                return dto;
            }).collect(Collectors.toList());
        }

        public NhanVienDTO createCustomer(NhanVienDTO dto) {
            NhanVien nv = modelMapper.map(dto, NhanVien.class);
            nv.setMatKhau(dto.getMatKhau());
            if (dto.getChucVuId() != null) {
                chucVuService.findById(dto.getChucVuId()).ifPresent(nv::setChucVu);
            }
            nv = repository.save(nv);
            return modelMapper.map(nv, NhanVienDTO.class);
        }

    @Override
    public NhanVienDTO updateCustomer(NhanVienDTO dto) {
        NhanVien nv = repository.findById(dto.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhân viên với ID: " + dto.getId()));

        // Cập nhật thông tin cơ bản
        nv.setTenNhanVien(dto.getTenNhanVien());
        nv.setSoDienThoai(dto.getSoDienThoai());
        nv.setDiaChi(dto.getDiaChi());
        nv.setEmail(dto.getEmail());
        nv.setGioiTinh(dto.getGioiTinh());
        nv.setNgaySinh(dto.getNgaySinh());

        // Cập nhật mật khẩu nếu có
        if (dto.getMatKhau() != null && !dto.getMatKhau().isBlank()) {
            nv.setMatKhau(dto.getMatKhau());
        }

        // ✅ Cập nhật chức vụ nếu có
        if (dto.getChucVuId() != null) {
            chucVuService.findById(dto.getChucVuId())
                    .ifPresentOrElse(
                            nv::setChucVu,
                            () -> {
                                throw new RuntimeException("Không tìm thấy chức vụ với ID: " + dto.getChucVuId());
                            }
                    );
        }
        // ✅ Cập nhật ngày sửa
        nv.setNgaySua(LocalDateTime.now());
        repository.save(nv);
        return modelMapper.map(nv, NhanVienDTO.class);
    }

    @Override
    public NhanVienDTO detailCustomer(Long id) {
        NhanVien entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhân viên"));
        NhanVienDTO dto = modelMapper.map(entity, NhanVienDTO.class);
        if (entity.getChucVu() != null) {
            dto.setChucVuId(entity.getChucVu().getId());
            dto.setChucVuTen(entity.getChucVu().getTenChucVu()); // nhớ thêm getTen()
        }

        return dto;
    }
}
