package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.service.admin.IHoaDonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class HoaDonServiceImpl implements IHoaDonService {

    @Autowired
    private IHoaDonRepository hoaDonRepository;

    @Override
    public List<HoaDonResponseDTO> getAll() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return hoaDonRepository.findAllByOrderByNgayTaoDesc()
                .stream()
                .map(hd -> new HoaDonResponseDTO(
                        hd.getId().longValue(),
                        hd.getMaHoaDon(),
                        hd.getTongTien(),
                        hd.getThanhTien(),
                        hd.getNgayTao().format(formatter),
                        hd.getTrangThai(),
                        hd.getLoaiHoaDon()
                ))
                .collect(Collectors.toList());
    }
}
