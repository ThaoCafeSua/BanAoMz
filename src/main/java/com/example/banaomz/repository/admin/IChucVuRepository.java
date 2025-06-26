package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.ChucVu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IChucVuRepository extends JpaRepository<ChucVu, Long> {
}

