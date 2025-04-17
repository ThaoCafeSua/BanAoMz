package com.example.banaomz.dto.admin.order;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderHistoryBillDetailDTO {
    private Long id;
    private String loai;
    private String moTa;
    private String ngayTao;
    private String nguoiTao;
}
