package com.example.banaomz.service.common.impl;

import com.example.banaomz.entity.common.BaseEntity;
import com.example.banaomz.repository.common.IBaseRepository;
import com.example.banaomz.service.common.IBaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

public class BaseServiceImpl<E extends BaseEntity, ID extends Serializable, R extends IBaseRepository<E, ID>>
        implements IBaseService<E, ID> {

    protected R repository;

    @Autowired
    public void setRepository(R repository) {
        this.repository = repository;
    }

    @Override
    public E createNew(E entity) {
        return repository.save(entity);
    }

    @Override
    public E update(E entity) {
        return repository.save(entity);
    }

    @Override
    public Optional<E> findById(ID id) {
        return repository.findById(id);
    }

    @Override
    public List<E> findAllLst() {
        return repository.findAll();
    }

    @Override
    public Boolean existsById(ID id) {
        return repository.existsById(id);
    }

    @Override
    public Page<E> findAll(Specification<E> spec, Pageable page) {
        return repository.findAll(spec, page);
    }

}
