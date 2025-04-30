package com.example.banaomz.repository.admin;


import com.example.banaomz.entity.admin.Size;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ISizeRepo extends IBaseRepository<Size,Long> {
    @Query(value = "SELECT sz FROM Size sz WHERE sz.tenSize LIKE %:value% order by sz.ngayTao desc ")
    List<Size> findAllStaff(@Param("value") String value);
}
