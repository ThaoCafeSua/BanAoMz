package com.example.banaomz.repository.client;

import com.example.banaomz.entity.admin.KhachHang;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface KhachHangClientRepository extends JpaRepository<KhachHang, Long> {
    Optional<KhachHang> findByEmail(String email);
}
