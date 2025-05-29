package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface IKhachHangRepository extends IBaseRepository<KhachHang,Long> {
    @Query("""
        SELECT kh FROM KhachHang kh 
        WHERE kh.hoVaTen LIKE %:value% 
           OR kh.soDienThoai LIKE %:value%
        ORDER BY kh.ngayTao DESC
    """)
    List<KhachHang> findAllCustomer(@Param("value") String value);

    @Query("""
        SELECT kh FROM KhachHang kh 
        JOIN FETCH kh.lstDiaChi dc 
        WHERE kh.id = :idCustomer
    """)
    Optional<KhachHang> findCustomerAddressById(@Param("idCustomer") Long idCustomer);
}
