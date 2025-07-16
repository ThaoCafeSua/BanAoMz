package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.MauSac;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IMauSacRepo extends IBaseRepository<MauSac,Long> {
    @Query("""
        SELECT ms FROM MauSac ms
        WHERE ms.tenMauSac LIKE %:value%
          AND (:status IS NULL OR :status = '' OR ms.trangThai = :status)
        ORDER BY ms.ngayTao DESC
    """)
    List<MauSac> findAllMauSac(@Param("value") String value, @Param("status") String status);

}
