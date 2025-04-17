package com.example.banaomz.dto.admin.order;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderChangeStatusDTO {

    private String codeBill;
    private String status;
    private String messenger;

}
