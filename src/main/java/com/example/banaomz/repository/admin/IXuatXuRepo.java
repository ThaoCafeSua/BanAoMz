package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.XuatXu;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IXuatXuRepo extends IBaseRepository<XuatXu,Long> {
    @Query("""
        SELECT xx 
        FROM XuatXu xx 
        WHERE xx.tenXuatXu LIKE %:value% 
          AND (:status IS NULL OR :status = '' OR xx.trangThai = :status)
        ORDER BY xx.ngayTao DESC
    """)
    List<XuatXu> findAllXuatXu(
            @Param("value") String value,
            @Param("status") String status
    );

}
