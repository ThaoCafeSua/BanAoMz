package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.DiaChi;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IDiaChiRepository extends IBaseRepository<DiaChi,Long> {
    @Query("""
        SELECT dc FROM DiaChi dc 
        WHERE dc.khachHang.id = :idCustomer 
        ORDER BY dc.ngayTao DESC
    """)
    List<DiaChi> findDiaChiByCustomer(@Param("idCustomer") Long idCustomer);
}
