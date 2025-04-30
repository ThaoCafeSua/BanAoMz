package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.ThuongHieu;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IThuongHieuRepo extends IBaseRepository<ThuongHieu,Long> {

    @Query(value = "SELECT th FROM ThuongHieu th WHERE th.tenThuongHieu LIKE %:value% order by th.ngayTao desc ")
    List<ThuongHieu> findAllThuongHieu(@Param("value") String value);
}
