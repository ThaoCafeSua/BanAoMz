package com.example.banaomz.dto.ghn;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class DistrictDTO {
    @JsonProperty("DistrictID")   private Integer districtId;
    @JsonProperty("DistrictName") private String  districtName;
    @JsonProperty("ProvinceID")   private Integer provinceId;
}
