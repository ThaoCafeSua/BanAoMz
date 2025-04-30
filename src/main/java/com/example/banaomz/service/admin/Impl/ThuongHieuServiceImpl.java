package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.sanPham.ThuongHieuDTO;
import com.example.banaomz.entity.admin.ThuongHieu;
import com.example.banaomz.exception.AppException;
import com.example.banaomz.exception.ErrorCode;
import com.example.banaomz.repository.admin.IThuongHieuRepo;
import com.example.banaomz.service.admin.IThuongHieuService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class ThuongHieuServiceImpl extends BaseServiceImpl<ThuongHieu, Long, IThuongHieuRepo>
        implements IThuongHieuService {

    @Autowired
    private ModelMapper modelMapper;

    @Override
    public List<ThuongHieuDTO> findAllThuongHieu(String value) {
        return repository.findAllThuongHieu(value).stream()
                .map(item -> modelMapper.map(item, ThuongHieuDTO.class))
                .toList();
    }

    @Override
    @Transactional
    public ThuongHieuDTO createThuongHieu(ThuongHieuDTO dto) {
        // Map DTO thành thực thể
        ThuongHieu entity = modelMapper.map(dto, ThuongHieu.class);
        ThuongHieu thuongHieu = createNew(entity);
        return modelMapper.map(thuongHieu, ThuongHieuDTO.class);
    }
    @Override
    public ThuongHieuDTO updateThuongHieu(ThuongHieuDTO dto) {
        // Tìm thực thể ThuongHieu theo ID từ DTO, nếu không có thì ném ngoại lệ
        ThuongHieu entity = findById(dto.getId())
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        // Ánh xạ dữ liệu từ DTO sang thực thể đã tìm thấy
        modelMapper.map(dto, entity);

        // Cập nhật thực thể trong cơ sở dữ liệu
        update(entity);

        // Trả về DTO đã được cập nhật
        return modelMapper.map(entity, ThuongHieuDTO.class);
    }
    @Override
    public ThuongHieuDTO detailThuongHieu(Long id) {
        Optional<ThuongHieu> entity = findById(id);
        if (entity.isEmpty()){
            return null;
        }
        // Ánh xạ thực thể sang DTO
        ThuongHieuDTO data = modelMapper.map(entity, ThuongHieuDTO.class);
        return data;
    }



}
