package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.entity.admin.ChucVu;
<<<<<<< HEAD
import com.example.banaomz.service.admin.IChucVuService;
=======
import com.example.banaomz.repository.admin.IChucVuRepository;
import com.example.banaomz.service.admin.IChucVuService;
import org.springframework.beans.factory.annotation.Autowired;
>>>>>>> eb0ab2b (nhân viên, phân quyền, đăng nhập)
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ChucVuServiceImpl implements IChucVuService {
<<<<<<< HEAD
    @Override
    public List<ChucVu> getAll() {
        return null;
=======

    @Autowired
    private IChucVuRepository chucVuRepository;

    @Override
    public List<ChucVu> getAll() {
        return chucVuRepository.findAll();
>>>>>>> eb0ab2b (nhân viên, phân quyền, đăng nhập)
    }

    @Override
    public Optional<ChucVu> findById(Long id) {
<<<<<<< HEAD
        return Optional.empty();
    }
}
=======
        return chucVuRepository.findById(id);
    }
}

>>>>>>> eb0ab2b (nhân viên, phân quyền, đăng nhập)
