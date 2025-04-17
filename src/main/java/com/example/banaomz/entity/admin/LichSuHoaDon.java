package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;


@Entity
@Table(name = "lich_su_hoa_don")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Getter
@Setter
public class LichSuHoaDon  {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_hoa_don")
    private HoaDon hoaDon;

    @Column(name = "loai")
    private String loai;

    @Column(name = "mo_ta")
    private String moTa;

}
