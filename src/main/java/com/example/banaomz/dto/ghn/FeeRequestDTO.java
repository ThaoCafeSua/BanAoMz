package com.example.banaomz.dto.ghn;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Data;


@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class FeeRequestDTO {

    @NotNull
    @JsonAlias("to_district_id")
    private Integer toDistrictId;

    @NotNull
    @JsonAlias("to_ward_code")
    private String  toWardCode;

    // Các kích thước/khối lượng: nếu null sẽ được default trong service.
    @Positive
    private Integer weight;

    @Positive
    private Integer length;

    @Positive
    private Integer width;

    @Positive
    private Integer height;

    @PositiveOrZero
    @JsonAlias("insurance_value")
    private Long    insuranceValue;

    private String  coupon;

    // FE có thể không gửi -> service sẽ tự chọn service khả dụng đầu tiên.
    @Positive
    @JsonAlias("service_id")
    private Integer serviceId;

    @Positive
    @JsonAlias("service_type_id")
    private Integer serviceTypeId;
}
