package com.example.banaomz.dto.admin.sales;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
public class PaymentInvoiceDTO {
    private Long billId;
    private BigDecimal tongTien;
    private BigDecimal phiVanChuyen;
    private BigDecimal tienGiam;
    private BigDecimal thanhTien;
    private String phuongThucThanhToan;
    private String tenNguoiNhan;
    private String soDienThoaiNguoiNhan;
    private String diaChiNguoiNhan;
    private Boolean isGiaoHang = Boolean.FALSE;
}
