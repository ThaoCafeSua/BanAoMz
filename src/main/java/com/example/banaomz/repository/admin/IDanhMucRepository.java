package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.DanhMuc;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IDanhMucRepository extends IBaseRepository< DanhMuc,Long> {
    @Query("""
    SELECT dm FROM DanhMuc dm 
    WHERE dm.tenDanhMuc LIKE %:value% 
      AND (:status IS NULL OR :status = '' OR dm.trangThai = :status)
""")
    List<DanhMuc> findAll(@Param("value") String value, @Param("status") String status);

}
