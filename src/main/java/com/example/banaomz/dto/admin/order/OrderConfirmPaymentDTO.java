package com.example.banaomz.dto.admin.order;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderConfirmPaymentDTO {

    private String codeBill;
    private String codePayment;
    private String paymentAmount;
    private String type;
    private String description;
}
