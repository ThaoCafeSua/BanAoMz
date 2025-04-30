package com.example.banaomz.entity.common;

import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@MappedSuperclass
public class BaseEntity extends AbstractAuditingEntity {

}
