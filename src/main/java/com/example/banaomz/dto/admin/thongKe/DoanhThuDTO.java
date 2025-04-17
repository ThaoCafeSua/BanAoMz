package com.example.banaomz.dto.admin.thongKe;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class DoanhThuDTO {
    private Integer day;
    private Integer month;
    private Integer year;
    private Integer soLuongTon;
}
