package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Builder
@Table(name = "phieu_giam_gia")
public class PhieuGiamGia {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ma_phieu_giam_gia")
    private String maPhieuGiamGia;

    @Column(name = "ten_phieu_giam_gia")
    private String tenPhieuGiamGia;

    @Column(name = "gia_tri_giam")
    private int giaTriGiam;

    @Column(name = "dieu_kien_ap_dung")
    private int dieuKienApDung;

    @Column(name = "ngay_bat_dau")
    private LocalDateTime ngayBatDau;

    @Column(name = "ngay_ket_thuc")
    private LocalDateTime ngayKetThuc;

    @Column(name = "so_luong")
    private int soLuong;

    @Column(name = "mo_ta")
    private String moTa;

    @Column(name = "trang_thai")
    private String trangThai;

    @Column(name = "ngay_tao")
    private LocalDateTime ngayTao;

    @Column(name = "ngay_sua")
    private LocalDateTime ngaySua;
}
