package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.NhanVien;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface INhanVienRepository extends IBaseRepository<NhanVien, Long> {
    @Query("SELECT nv FROM NhanVien nv WHERE nv.tenNhanVien LIKE %:keyword% OR nv.soDienThoai LIKE %:keyword%")
    List<NhanVien> findAllNhanVien(@Param("keyword") String keyword);

    @Query("""
        SELECT nv FROM NhanVien nv 
        WHERE nv.tenNhanVien LIKE %:value% 
           OR nv.soDienThoai LIKE %:value%
        ORDER BY nv.ngayTao DESC
    """)
    List<NhanVien> findAllCustomer(@Param("value") String value);

    @Query("""
        SELECT nv FROM NhanVien nv 
        JOIN FETCH nv.diaChi dc 
        WHERE nv.id = :idCustomer
    """)
    Optional<NhanVien> findCustomerAddressById(@Param("idCustomer") Long idCustomer);

    NhanVien findByEmail(String email);
    boolean existsBySoDienThoai(String soDienThoai);
}
