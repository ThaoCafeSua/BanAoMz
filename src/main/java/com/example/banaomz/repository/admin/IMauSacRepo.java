package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.MauSac;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IMauSacRepo extends IBaseRepository<MauSac,Long> {
    @Query(value = "SELECT ms FROM MauSac ms WHERE ms.tenMauSac LIKE %:value% order by ms.ngayTao desc ")
    List<MauSac> findAllStaff(@Param("value") String value);
}
