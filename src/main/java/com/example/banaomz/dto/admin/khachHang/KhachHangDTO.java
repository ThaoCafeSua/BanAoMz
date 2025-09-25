package com.example.banaomz.dto.admin.khachHang;

import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import jakarta.validation.constraints.Past;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

@Getter
@Setter
public class KhachHangDTO {
    private Long id;
    private String hoVaTen;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Past(message = "Ngày sinh không được ở tương lai")
    private Date ngaySinh;
    private String gioiTinh;
    private String email;
    private String soDienThoai;
    private String matKhau;
    private List<DiaChiDTO> lstDiaChi;
}
