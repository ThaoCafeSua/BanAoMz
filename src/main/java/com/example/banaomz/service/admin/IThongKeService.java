package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.thongKe.DoanhThuDTO;

import java.util.List;

public interface IThongKeService {
    List<DoanhThuDTO> getDoanhThuTheoNgayThang(Integer year, Integer month);
}
