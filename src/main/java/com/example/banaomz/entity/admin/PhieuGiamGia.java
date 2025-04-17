package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "phieu_giam_gia")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Getter
@Setter
public class PhieuGiamGia {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_phieu_giam_gia")
    private String maPhieuGiamGia;

    @Column(name = "ten_phieu_giam_gia")
    private String tenPhieuGiamGia;

    @Column(name = "gia_tri_giam")
    private BigDecimal giaTriGiam;

    @Column(name = "dieu_kien_ap_dung")
    private String dieuKienApDung;

    @Column(name = "ngay_bat_dau")
    private LocalDateTime ngayBatDau;

    @Column(name = "ngay_ket_thuc")
    private LocalDateTime ngayKetThuc;

    @Column(name = "so_luong")
    private Integer soLuong;

    @Column(name = "mo_ta")
    private String moTa;

    @Column(name = "trang_thai")
    private String trangThai;
}
