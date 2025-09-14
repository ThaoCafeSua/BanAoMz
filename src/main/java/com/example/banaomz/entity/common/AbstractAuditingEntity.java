package com.example.banaomz.entity.common;

import com.example.banaomz.entity.admin.NhanVien;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.EntityListeners;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.io.Serializable;
import java.time.LocalDateTime;

@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
@JsonIgnoreProperties(value = { "ngayTao", "ngaySua" }, allowGetters = true)
public abstract class AbstractAuditingEntity implements Serializable {

    @CreatedDate
    @Column(name = "ngay_tao", updatable = false, nullable = false)
    private LocalDateTime ngayTao;

    @LastModifiedDate
    @Column(name = "ngay_sua")
    private LocalDateTime ngaySua;
}
