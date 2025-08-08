package com.example.banaomz.dto.admin.sanPham.reponse;

import com.example.banaomz.entity.admin.SanPhamChiTiet;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class SanPhamTaiQuayResponse {
    private Long id;
    private String tenSanPham;
    private String urlAnh;
    private BigDecimal giaBan;
    private String trangThai;

    public SanPhamTaiQuayResponse(SanPhamChiTiet entity) {
        this.id = entity.getId();
        this.tenSanPham = entity.getSanPham().getTenSanPham();
        this.giaBan = entity.getGiaBan();
        this.trangThai = entity.getTrangThai();

        String raw = entity.getSanPham().getUrlAnh();
        System.out.println("⚠️ raw từ DB: " + raw);

        if (raw == null || raw.isBlank()) {
            this.urlAnh = "/includes/images/default.png";
        } else {
            String fileName = raw.substring(raw.lastIndexOf("/") + 1);

            String fileNameClean = fileName.replaceFirst("^[0-9]+_", "");
            this.urlAnh = "/includes/images/" + fileNameClean;
        }

        System.out.println("🖼️ ID SP: " + this.id + " | Tên: " + this.tenSanPham + " | URL ảnh: " + this.urlAnh);
    }
}
