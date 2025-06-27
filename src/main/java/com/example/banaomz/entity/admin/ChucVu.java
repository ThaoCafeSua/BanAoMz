package com.example.banaomz.entity.admin;

import com.example.banaomz.entity.common.BaseEntity;
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
@Table(name = "chuc_vu")
public class ChucVu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ten_chuc_vu")
    private String tenChucVu;

    @OneToMany(mappedBy = "chucVu")
    @JsonIgnore
    private Set<NhanVien> nhanVien;

}
