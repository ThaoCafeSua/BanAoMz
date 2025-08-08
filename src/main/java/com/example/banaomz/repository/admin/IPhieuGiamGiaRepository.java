package com.example.banaomz.repository.admin;

import com.example.banaomz.dto.admin.PhieuGiamGia.PhieuGiamGiaDTO;
import com.example.banaomz.entity.admin.PhieuGiamGia;
import com.example.banaomz.repository.common.IBaseRepository;

import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface IPhieuGiamGiaRepository extends IBaseRepository<PhieuGiamGia, Long> {

    @Query("""
                SELECT p FROM PhieuGiamGia p
                WHERE p.tenPhieuGiamGia LIKE %:value%
                   OR p.maPhieuGiamGia LIKE %:value%
                ORDER BY p.ngayTao DESC
            """)
    List<PhieuGiamGia> findAllVoucher(@Param("value") String value);

}