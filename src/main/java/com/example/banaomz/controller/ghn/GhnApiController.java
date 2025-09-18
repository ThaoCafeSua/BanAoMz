package com.example.banaomz.controller.ghn;

import com.example.banaomz.dto.ghn.AvailableServiceDTO;
import com.example.banaomz.dto.ghn.FeeRequestDTO;
import com.example.banaomz.dto.ghn.FeeResultDTO;
import com.example.banaomz.dto.ghn.ProvinceDTO;
import com.example.banaomz.service.admin.IGhnShippingService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ghn")
@RequiredArgsConstructor
public class GhnApiController {

    private final IGhnShippingService ghn;

    // GET: giữ tương thích; có thể truyền thêm toWardCode (optional)
    @GetMapping(value = "/services", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getServices(
            @RequestParam("toDistrictId") Integer toDistrictId,
            @RequestParam(value = "toWardCode", required = false) String toWardCode) {

        if (toDistrictId == null) {
            return ResponseEntity.badRequest().body("Missing toDistrictId");
        }
        List<AvailableServiceDTO> data = ghn.getAvailableServices(toDistrictId, toWardCode);
        return ResponseEntity.ok(data);
    }

    // POST: khuyên dùng để gửi body JSON
    @PostMapping(
            value = "/services",
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> postServices(@RequestBody ServicesReq req) {
        if (req.getToDistrictId() == null) {
            return ResponseEntity.badRequest().body("Missing toDistrictId");
        }
        List<AvailableServiceDTO> data = ghn.getAvailableServices(req.getToDistrictId(), req.getToWardCode());
        return ResponseEntity.ok(data);
    }

    @PostMapping(
            value = "/fee",
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<FeeResultDTO> calcFee(@RequestBody FeeRequestDTO req) {
        return ResponseEntity.ok(ghn.calculateFee(req));
    }

    // -------- inner DTO cho POST /services (thay cho 'record') --------
    @Data
    public static class ServicesReq {
        private Integer toDistrictId;
        private String  toWardCode;
    }

    // ...
    @GetMapping(value = "/provinces", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ProvinceDTO> provinces() {
        return ghn.getProvinces();
    }

    @GetMapping(value = "/districts", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> districts(@RequestParam Integer provinceId) {
        if (provinceId == null) return ResponseEntity.badRequest().body(java.util.Map.of("message","Missing provinceId"));
        return ResponseEntity.ok(ghn.getDistricts(provinceId));
    }

    @GetMapping(value = "/wards", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> wards(@RequestParam Integer districtId) {
        if (districtId == null) return ResponseEntity.badRequest().body(java.util.Map.of("message","Missing districtId"));
        return ResponseEntity.ok(ghn.getWards(districtId));
    }

}
