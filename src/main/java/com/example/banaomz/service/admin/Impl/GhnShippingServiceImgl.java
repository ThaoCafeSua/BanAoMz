package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.config.ghn.GhnProperties;
import com.example.banaomz.dto.ghn.AvailableServiceDTO;
import com.example.banaomz.dto.ghn.DistrictDTO;
import com.example.banaomz.dto.ghn.FeeRequestDTO;
import com.example.banaomz.dto.ghn.FeeResultDTO;
import com.example.banaomz.dto.ghn.GhnFeeResponse;
import com.example.banaomz.dto.ghn.GhnResponse;
import com.example.banaomz.dto.ghn.ProvinceDTO;
import com.example.banaomz.dto.ghn.WardDTO;
import com.example.banaomz.service.admin.IGhnShippingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.Duration;
import java.util.*;

/**
 * NOTE:
 * - Interface IGhnShippingService nên có:
 *      List<AvailableServiceDTO> getAvailableServices(Integer toDistrictId, String toWardCode);
 *      default List<AvailableServiceDTO> getAvailableServices(Integer toDistrictId) { return getAvailableServices(toDistrictId, null); }
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class GhnShippingServiceImgl implements IGhnShippingService {

    @Qualifier("ghnWebClient")
    private final WebClient ghnWebClient;

    private final GhnProperties props;

    private Duration timeout() {
        return Duration.ofMillis(Math.max(1000, props.getTimeoutMs()));
    }

    /** BẢN ĐẦY ĐỦ: truyền wardCode sẽ chuẩn hơn (GHN có thể dựa vào ward để chọn service_type) */
    @Override
    public List<AvailableServiceDTO> getAvailableServices(Integer toDistrictId, String toWardCode) {
        if (props.getShopId() == null || props.getFromDistrictId() == null) {
            throw new IllegalStateException("Thiếu cấu hình GHN: shopId/fromDistrictId.");
        }
        if (toDistrictId == null) {
            throw new IllegalArgumentException("Thiếu toDistrictId.");
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("shop_id",          props.getShopId());
        // Gửi chuẩn *_id; kèm biến thể không _id để tương thích một số tài liệu/môi trường
        body.put("from_district_id", props.getFromDistrictId());
        body.put("from_district",    props.getFromDistrictId());
        body.put("to_district_id",   toDistrictId);
        body.put("to_district",      toDistrictId);
        if (toWardCode != null && !toWardCode.isBlank()) {
            body.put("to_ward_code", toWardCode);
        }

        GhnResponse<List<AvailableServiceDTO>> res = ghnWebClient.post()
                .uri("/v2/shipping-order/available-services")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<GhnResponse<List<AvailableServiceDTO>>>() {})
                .block(timeout());

        return (res != null && res.getData() != null) ? res.getData() : Collections.emptyList();
    }

    /** BẢN TƯƠNG THÍCH CŨ (không có wardCode) */
    @Override
    public List<AvailableServiceDTO> getAvailableServices(Integer toDistrictId) {
        return getAvailableServices(toDistrictId, null);
    }

    @Override
    public FeeResultDTO calculateFee(FeeRequestDTO req) {
        if (props.getFromDistrictId() == null) {
            throw new IllegalStateException("Thiếu ghn.from-district-id (kho/người gửi).");
        }
        if (req.getToDistrictId() == null || req.getToWardCode() == null || req.getToWardCode().isBlank()) {
            throw new IllegalArgumentException("Thiếu toDistrictId/toWardCode.");
        }

        Integer serviceId     = req.getServiceId();
        Integer serviceTypeId = req.getServiceTypeId();

        // Nếu FE chưa chọn -> tự lấy dịch vụ đầu tiên khả dụng
        if (serviceId == null) {
            List<AvailableServiceDTO> services = getAvailableServices(req.getToDistrictId(), req.getToWardCode());
            if (services.isEmpty()) throw new IllegalStateException("Không có dịch vụ GHN khả dụng cho địa chỉ đích.");
            AvailableServiceDTO first = services.get(0);
            serviceId     = first.getServiceId();
            serviceTypeId = first.getServiceTypeId();
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("from_district_id", props.getFromDistrictId());
        // from_ward_code: KHÔNG bắt buộc; có thì gửi để phí chính xác hơn
        if (props.getFromWardCode() != null && !props.getFromWardCode().isBlank()) {
            body.put("from_ward_code", props.getFromWardCode());
        }

        body.put("to_district_id",   req.getToDistrictId());
        body.put("to_ward_code",     req.getToWardCode());

        body.put("service_id",       serviceId);
        if (serviceTypeId != null) {
            body.put("service_type_id", serviceTypeId);
        }

        body.put("weight", defaultInt(req.getWeight(), 200));
        body.put("length", defaultInt(req.getLength(), 10));
        body.put("width",  defaultInt(req.getWidth(), 10));
        body.put("height", defaultInt(req.getHeight(), 5));

        if (req.getInsuranceValue() != null) {
            body.put("insurance_value", req.getInsuranceValue());
        }
        if (req.getCoupon() != null && !req.getCoupon().isBlank()) {
            body.put("coupon", req.getCoupon());
        }

        GhnResponse<GhnFeeResponse> res = ghnWebClient.post()
                .uri("/v2/shipping-order/fee")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(body)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<GhnResponse<GhnFeeResponse>>() {})
                .block(timeout());

        if (res == null || res.getData() == null) {
            throw new IllegalStateException("Không lấy được phí từ GHN.");
        }

        GhnFeeResponse d = res.getData();
        return FeeResultDTO.builder()
                .total(nl(d.getTotal()))
                .serviceFee(nl(d.getServiceFee()))
                .insuranceFee(nl(d.getInsuranceFee()))
                .codFee(nl(d.getCodFee()))
                .serviceId(d.getServiceId() != null ? d.getServiceId() : serviceId)
                .serviceTypeId(d.getServiceTypeId() != null ? d.getServiceTypeId() : serviceTypeId)
                .build();
    }

    private int  defaultInt(Integer v, int def) { return v == null ? def : v; }
    private Long nl(Long v) { return v == null ? 0L : v; }

    // imports: ParameterizedTypeReference, MediaType, List, Collections, Map, LinkedHashMap...

    @Override
    public List<ProvinceDTO> getProvinces() {
        GhnResponse<List<ProvinceDTO>> res = ghnWebClient.get()
                .uri("/master-data/province")
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<GhnResponse<List<ProvinceDTO>>>() {})
                .block(timeout());
        return (res!=null && res.getData()!=null) ? res.getData() : Collections.emptyList();
    }

    @Override
    public List<DistrictDTO> getDistricts(Integer provinceId) {
        GhnResponse<List<DistrictDTO>> res = ghnWebClient.get()
                .uri(uriBuilder -> uriBuilder.path("/master-data/district")
                        .queryParam("province_id", provinceId).build())
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<GhnResponse<List<DistrictDTO>>>() {})
                .block(timeout());
        return (res!=null && res.getData()!=null) ? res.getData() : Collections.emptyList();
    }

    @Override
    public List<WardDTO> getWards(Integer districtId) {
        GhnResponse<List<WardDTO>> res = ghnWebClient.get()
                .uri(uriBuilder -> uriBuilder.path("/master-data/ward")
                        .queryParam("district_id", districtId).build())
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<GhnResponse<List<WardDTO>>>() {})
                .block(timeout());
        return (res!=null && res.getData()!=null) ? res.getData() : Collections.emptyList();
    }

}
