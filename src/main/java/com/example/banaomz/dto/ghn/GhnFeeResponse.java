package com.example.banaomz.dto.ghn;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;


@Data
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class GhnFeeResponse {

    @JsonProperty("total")
    private Long total;

    @JsonProperty("service_fee")
    private Long serviceFee;

    @JsonProperty("insurance_fee")
    private Long insuranceFee;

    @JsonProperty("cod_fee")
    private Long codFee;

    private String coupon;

    @JsonProperty("service_id")
    private Integer serviceId;

    @JsonProperty("service_type_id")
    private Integer serviceTypeId;
}
