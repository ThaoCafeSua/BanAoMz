package com.example.banaomz.service.admin;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import java.io.OutputStream;

import java.util.List;

public interface IHoaDonService {
    List<HoaDonResponseDTO> getAll();
    HoaDonDetailResponseDTO getDetailById(Long id);
    void exportHoaDonPdf(Long id, OutputStream outputStream);
    HoaDonDetailResponseDTO updateTrangThai(Long id, String trangThaiMoi);
    List<HoaDonDetailResponseDTO> getOrdersByCustomerId(Long customerId);
    void huyDonHang(Long id);


}