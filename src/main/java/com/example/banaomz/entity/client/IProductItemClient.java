package com.example.banaomz.entity.client;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public interface IProductItemClient {
    Long getId();

    String getMaSanPham();

    String getTenSanPham();

    String getThuongHieu();

    String getXuatXu();

    String getDanhMuc();

    Integer getSoLuong();

    String getUrlAnh();

    String getTrangThai();

    LocalDateTime getNgayTao();

    BigDecimal getGiaBan();

    String getSoLuongDaBan();

}
