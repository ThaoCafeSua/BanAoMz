package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.LichSuHoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ILichSuHoaDonRepository extends JpaRepository<LichSuHoaDon, Long> {
}
