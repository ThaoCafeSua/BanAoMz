package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.HoaDon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IHoaDonRepository extends JpaRepository<HoaDon, Long> {
    List<HoaDon> findAllByOrderByNgayTaoDesc();
    List<HoaDon> findByTrangThaiAndLoaiHoaDon(String trangThai, String loaiHoaDon);

}
