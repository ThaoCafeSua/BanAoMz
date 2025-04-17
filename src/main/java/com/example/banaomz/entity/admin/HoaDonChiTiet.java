package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.math.BigDecimal;

@Entity
@Table(name = "hoa_don_chi_tiet")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Getter
@Setter
public class HoaDonChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_hoa_don")
    private HoaDon hoaDon;

    @ManyToOne
    @JoinColumn(name = "id_san_pham_chi_tiet")
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "gia_ban")
    private BigDecimal giaBan;

    @Column(name = "gia_goc")
    private BigDecimal giaGoc;

    @Column(name = "gia_giam")
    private BigDecimal giaGiam;

    @Column(name = "so_luong")
    private Integer soLuong;

    @Column(name = "mo_ta")
    private String moTa;
}
