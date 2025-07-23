package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.entity.admin.ChucVu;
import com.example.banaomz.service.admin.IChucVuService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ChucVuServiceImpl implements IChucVuService {
    @Override
    public List<ChucVu> getAll() {
        return null;
    }

    @Override
    public Optional<ChucVu> findById(Long id) {
        return Optional.empty();
    }
}
