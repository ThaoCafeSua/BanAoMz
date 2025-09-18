package com.example.banaomz.dto.ghn;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class FeeResultDTO {
    private Long total;
    private Long serviceFee;
    private Long insuranceFee;
    private Long codFee;

    private Integer serviceId;
    private Integer serviceTypeId;

    private String note;
}
