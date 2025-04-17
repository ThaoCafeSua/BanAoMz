package com.example.banaomz.entity.admin;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.util.Date;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Entity
@Builder
@Table(name = "khach_hang")
public class KhachHang  {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ho_va_ten")
    private String hoVaTen;

    @Column(name = "ngay_sinh")
    @Temporal(TemporalType.DATE)
    private Date ngaySinh;

    @Column(name = "gioi_tinh")
    private String gioiTinh;

    @Column(name = "email")
    private String email;

    @Column(name = "so_dien_thoai")
    private String soDienThoai;

    @Column(name = "mat_khau")
    private String matKhau;


    @OneToMany(mappedBy = "khachHang")
    @JsonIgnore
    private Set<DiaChi> lstDiaChi;

}
