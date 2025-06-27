package com.example.banaomz.service.admin;

import com.example.banaomz.entity.admin.ChucVu;

import java.util.List;
import java.util.Optional;

public interface IChucVuService {
    List<ChucVu> getAll();

    Optional<ChucVu> findById(Long id);
}
