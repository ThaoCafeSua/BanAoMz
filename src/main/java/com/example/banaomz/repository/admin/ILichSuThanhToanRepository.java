package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.LichSuThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ILichSuThanhToanRepository extends JpaRepository<LichSuThanhToan, Long> {
}
