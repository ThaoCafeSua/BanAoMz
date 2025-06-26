package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.PhieuGiamGia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IPhieuGiamGiaRepository extends JpaRepository<PhieuGiamGia, Long> {
}

