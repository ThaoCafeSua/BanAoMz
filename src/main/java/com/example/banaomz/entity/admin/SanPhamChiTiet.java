package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Entity
@Builder
@Table(name = "san_pham_chi_tiet")
public class SanPhamChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_mau_sac")
    private MauSac mauSac;

    @ManyToOne
    @JoinColumn(name = "id_size")
    private Size size;

    @ManyToOne
    @JoinColumn(name = "id_san_pham")
    private SanPham sanPham;

    @Column(name = "url_anh")
    private String urlAnh;

    @Column(name = "so_luong")
    private Integer soLuong;

    @Column(name = "ma_vach")
    private String maVach;

    @Column(name = "gia_ban")
    private BigDecimal giaBan;

    @Column(name = "trang_thai")
    private String trangThai;
}
