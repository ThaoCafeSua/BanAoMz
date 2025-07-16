package com.example.banaomz.dto.admin.nhanVien;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
public class NhanVienDTO {
    private Long id;

    // Thông tin chức vụ
    private Long chucVuId;         // Dùng để gửi lên server
    private String chucVuTen;      // Dùng để hiển thị tên chức vụ

    private String tenNhanVien;
    private String soDienThoai;
    private String diaChi;
    private String email;
    @DateTimeFormat(pattern = "yyyy-MM-dd") // ✅ dòng cần thêm
    private Date ngaySinh;         // Giữ nguyên nếu form dùng type="date"
    private String gioiTinh;
    private String matKhau;
    @DateTimeFormat(pattern = "yyyy-MM-dd") // ✅ dòng cần thêm
    private LocalDateTime ngayTao;
    @DateTimeFormat(pattern = "yyyy-MM-dd") // ✅ dòng cần thêm
    private LocalDateTime ngaySua;
}
