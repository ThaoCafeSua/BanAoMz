package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.XuatXu;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IXuatXuRepo extends IBaseRepository<XuatXu,Long> {
    @Query(value = "SELECT xx FROM XuatXu xx WHERE xx.tenXuatXu LIKE %:value% order by xx.ngayTao desc ")
    List<XuatXu> findAllStaff(@Param("value") String value);
}
