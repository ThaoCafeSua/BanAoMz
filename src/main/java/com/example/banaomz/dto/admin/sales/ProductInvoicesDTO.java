package com.example.banaomz.dto.admin.sales;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductInvoicesDTO {
    private Long billId;
    private Long productId;
    private Integer quantity;
}
