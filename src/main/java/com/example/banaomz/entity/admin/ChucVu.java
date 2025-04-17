package com.example.banaomz.entity.admin;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Table(name = "chuc_vu")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@DynamicUpdate
public class ChucVu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ten_chuc_vu")
    private String tenChucVu;
}
