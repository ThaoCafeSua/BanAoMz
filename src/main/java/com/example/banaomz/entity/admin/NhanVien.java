package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.util.Date;

@Entity
@Table(name = "nhan_vien")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Getter
@Setter
public class NhanVien  {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_chuc_vu")
    private ChucVu chucVu;

    @Column(name = "ten_nhan_vien")
    private String tenNhanVien;

    @Column(name = "sdt")
    private String sdt;

    @Column(name = "dia_chi")
    private String diaChi;

    @Column(name = "email")
    private String email;

    @Column(name = "ngay_sinh")
    @Temporal(TemporalType.DATE)
    private Date ngaySinh;

    @Column(name = "gioi_tinh")
    private String gioiTinh;

    @Column(name = "mat_khau")
    private String matKhau;
}
