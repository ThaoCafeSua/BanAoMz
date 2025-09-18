package com.example.banaomz.controller.client.khachhang;

import com.example.banaomz.entity.admin.DiaChi;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.repository.admin.IDiaChiRepository;
import com.example.banaomz.service.admin.IKhachHangService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/khachhang/api")
public class KhachHangApiController {

    private final IKhachHangService khachHangService;
    private final IDiaChiRepository diaChiRepository;

    public KhachHangApiController(IKhachHangService khachHangService,
                                  IDiaChiRepository diaChiRepository) {
        this.khachHangService = khachHangService;
        this.diaChiRepository = diaChiRepository;
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(HttpSession session) {
        Object rawId = session.getAttribute("KH_ID");
        if (rawId == null) {
            return ResponseEntity.ok(Map.of("loggedIn", false));
        }

        Long id;
        try {
            id = (rawId instanceof Long) ? (Long) rawId : Long.valueOf(String.valueOf(rawId));
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("loggedIn", false));
        }

        Optional<KhachHang> khOpt = khachHangService.findById(id);
        if (khOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("loggedIn", false));
        }

        KhachHang kh = khOpt.get();
        Map<String, Object> body = new HashMap<>();
        body.put("loggedIn", true);
        body.put("id", kh.getId());
        body.put("hoVaTen", kh.getHoVaTen());
        body.put("soDienThoai", kh.getSoDienThoai());
        body.put("email", kh.getEmail());

        diaChiRepository.findDefaultByKhachHangId(kh.getId())
                .or(() -> diaChiRepository.findPreferredByKhachHangId(kh.getId()))
                .ifPresent(dc -> {
                    body.put("diaChiChiTiet", dc.getDiaChiChiTiet());
                    body.put("tinh", dc.getTinh());
                    body.put("huyen", dc.getHuyen());
                    body.put("xa", dc.getXa());
                });

        return ResponseEntity.ok(body);
    }
}
