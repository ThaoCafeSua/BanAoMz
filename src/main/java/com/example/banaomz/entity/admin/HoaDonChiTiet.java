package com.example.banaomz.entity.admin;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "hoa_don_chi_tiet")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HoaDonChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

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

    @Column(name = "ngay_tao")
    private LocalDateTime ngayTao;

    @Column(name = "ngay_sua")
    private LocalDateTime ngaySua;
}
