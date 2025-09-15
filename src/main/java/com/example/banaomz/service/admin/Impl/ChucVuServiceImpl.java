package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.entity.admin.ChucVu;
import com.example.banaomz.repository.admin.IChucVuRepository;
import com.example.banaomz.service.admin.IChucVuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ChucVuServiceImpl implements IChucVuService {

    @Autowired
    private IChucVuRepository chucVuRepository;

    @Override
    public List<ChucVu> getAll() {
        // Lấy toàn bộ danh sách chức vụ từ DB
        return chucVuRepository.findAll();
    }

    @Override
    public Optional<ChucVu> findById(Long id) {
        // Tìm chức vụ theo id
        return chucVuRepository.findById(id);
    }
}
