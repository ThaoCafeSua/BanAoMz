package com.example.banaomz.repository.common;

import com.example.banaomz.entity.common.BaseEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.NoRepositoryBean;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

@NoRepositoryBean
public interface IBaseRepository<T extends BaseEntity, ID extends Serializable>
        extends JpaRepository<T, ID>, JpaSpecificationExecutor<T> {

    @Query("select e from #{#entityName} e where e.id = ?1")
    Optional<T> findById(ID id);

    @Query("select e from #{#entityName} e ORDER BY e.ngayTao DESC")
    List<T> findAll();
}