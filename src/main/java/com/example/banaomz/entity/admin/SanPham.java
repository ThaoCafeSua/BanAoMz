package com.example.banaomz.entity.admin;

import com.example.banaomz.entity.common.BaseEntity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.util.Set;

@Entity
@Table(name = "san_pham")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Getter
@Setter
public class SanPham extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_xuat_xu")
    private XuatXu xuatXu;

    @ManyToOne
    @JoinColumn(name = "id_danh_muc")
    private DanhMuc danhMuc;

    @ManyToOne
    @JoinColumn(name = "id_thuong_hieu")
    private ThuongHieu thuongHieu;

    @Column( name = "ma_san_pham")
    private String maSanPham;

    @Column(name = "ten_san_pham")
    private String tenSanPham;

    @Column(name = "trang_thai")
    private String trangThai;

    @Column(name = "so_luong_da_ban")
    private String slDaBan;

    @Column(name = "url_anh")
    private String urlAnh;


    @OneToMany(mappedBy = "sanPham")
    @JsonIgnore
    private Set<SanPhamChiTiet> lstChiTietSanPham;
}
