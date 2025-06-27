package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.ChucVu;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IChucVuRepository extends JpaRepository<ChucVu, Long>{
}
