package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.math.BigDecimal;


@Entity
@Table(name = "lich_su_thanh_toan")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Getter
@Setter
public class LichSuThanhToan  {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_hoa_don")
    private HoaDon hoaDon;

    @Column(name = "ma_giao_dich")
    private String maGiaoDich;

    @Column(name = "loai_thanh_toan")
    private String loaiThanhToan;

    @Column(name = "so_tien_thanh_toan")
    private BigDecimal soTienThanhToan;

    @Column(name = "mo_ta")
    private String moTa;
}
