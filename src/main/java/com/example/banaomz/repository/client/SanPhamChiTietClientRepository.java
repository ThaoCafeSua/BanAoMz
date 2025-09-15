package com.example.banaomz.repository.client;

import com.example.banaomz.entity.admin.SanPhamChiTiet;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface SanPhamChiTietClientRepository  extends JpaRepository<SanPhamChiTiet, Long> {
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select s from SanPhamChiTiet s where s.id = :id")
    Optional<SanPhamChiTiet> findByIdForUpdate(@Param("id") Integer id);

    @Query("""
  select s.id from SanPhamChiTiet s
  where s.sanPham.id = :spId and s.mauSac.id = :mauId and s.size.id = :sizeId
""")
    Optional<Long> findSpctId(@Param("spId") Long spId,
                              @Param("mauId") Long mauId,
                              @Param("sizeId") Long sizeId);


}
