package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.GioHang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IGioHangRepository extends JpaRepository<GioHang, Long> {
}
