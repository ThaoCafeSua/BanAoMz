package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse.HoaDonChiTietResponseDTO;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.service.admin.IHoaDonService;
import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.awt.*;
import java.io.OutputStream;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@Service
public class HoaDonServiceImpl implements IHoaDonService {

    @Autowired
    private IHoaDonRepository hoaDonRepository;



    @Override
    public List<HoaDonResponseDTO> getAll() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss - dd/MM/yyyy");
        return hoaDonRepository.findAllByOrderByNgayTaoDesc()
                .stream()
                .map(hd -> new HoaDonResponseDTO(
                        hd.getId().longValue(),
                        hd.getMaHoaDon(),
                        hd.getTongTien(),
                        hd.getThanhTien(),
                        hd.getNgayTao().format(formatter),
                        hd.getTrangThai(),
                        hd.getLoaiHoaDon()
                ))
                .collect(Collectors.toList());
    }
    @Override
    public HoaDonDetailResponseDTO getDetailById(Long id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn với ID: " + id));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        List<HoaDonChiTietResponseDTO> chiTietList = hd.getHoaDonChiTietList().stream().map(ct -> {
            String tenSP = ct.getSanPhamChiTiet().getSanPham().getTenSanPham();
            String mau = ct.getSanPhamChiTiet().getMauSac().getTenMauSac();
            String size = ct.getSanPhamChiTiet().getSize().getTenSize();

            return new HoaDonChiTietResponseDTO(
                    tenSP,
                    mau,
                    size,
                    ct.getSoLuong(),
                    ct.getGiaBan(),
                    ct.getGiaBan().multiply(java.math.BigDecimal.valueOf(ct.getSoLuong()))
            );
        }).collect(Collectors.toList());

        return new HoaDonDetailResponseDTO(
                hd.getId().longValue(),
                hd.getMaHoaDon(),
                hd.getLoaiHoaDon(),
                hd.getHinhThucHoaDon(),
                hd.getPhuongThucThanhToan(),
                hd.getTrangThai(),
                hd.getMoTa(),
                hd.getKhachHang() != null ? hd.getKhachHang().getHoVaTen() : "Khách lẻ",
                hd.getNhanVien() != null ? hd.getNhanVien().getTenNhanVien() : "Không rõ",

                hd.getTenNguoiNhan(),
                hd.getSoDienThoaiNguoiNhan() ,
                hd.getDiaChiNguoiNhan(),

                hd.getTongTien(),
                hd.getTienGiam(),
                hd.getPhiVanChuyen(),
                hd.getThanhTien(),

                hd.getNgayDat() != null ? hd.getNgayDat().format(formatter) : null,
                hd.getNgayGiao() != null ? hd.getNgayGiao().format(formatter) : null,
                hd.getNgayHoanThanh() != null ? hd.getNgayHoanThanh().format(formatter) : null,

                chiTietList
        );
    }
    @Override
    public void exportHoaDonPdf(Long id, OutputStream outputStream) {
        HoaDonDetailResponseDTO hoaDon = getDetailById(id);

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            // Load font từ resource
            String fontPath = getClass().getClassLoader().getResource("fonts/LiberationSans-Regular.ttf").toURI().getPath();
            PdfFont font = PdfFontFactory.createFont(fontPath, PdfEncodings.IDENTITY_H);
            document.setFont(font);


            // Tiêu đề
            document.add(new Paragraph("HÓA ĐƠN BÁN HÀNG")
                    .setFont(font)
                    .setBold()
                    .setFontSize(18)
                    .setTextAlignment(TextAlignment.CENTER));

            document.add(new Paragraph("Mã hóa đơn: " + nonNull(hoaDon.getMaHoaDon())).setFont(font));
            document.add(new Paragraph("Khách hàng: " + nonNull(hoaDon.getTenKhachHang())).setFont(font));
            document.add(new Paragraph("Người nhận: " + nonNull(hoaDon.getTenNguoiNhan())).setFont(font));
            document.add(new Paragraph("Ngày đặt: " + nonNull(hoaDon.getNgayDat())).setFont(font));
            document.add(new Paragraph("\n"));

            // Bảng sản phẩm
            float[] columnWidths = {4, 3, 2, 2, 3};
            Table table = new Table(columnWidths).useAllAvailableWidth();

            table.addHeaderCell(new Cell().add(new Paragraph("Sản phẩm").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Màu sắc").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Size").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Số lượng").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Thành tiền").setFont(font).setBold()));

            for (HoaDonChiTietResponseDTO ct : hoaDon.getChiTietSanPhamList()) {
                table.addCell(new Cell().add(new Paragraph(nonNull(ct.getTenSanPham())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(nonNull(ct.getMauSac())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(nonNull(ct.getSize())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(ct.getSoLuong())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(formatCurrency(ct.getThanhTien())).setFont(font)));
            }


            document.add(table);
            document.add(new Paragraph("\n"));

            // Tổng kết
            document.add(new Paragraph("Tổng tiền: " + formatCurrency(hoaDon.getTongTien())).setFont(font));
            document.add(new Paragraph("Tiền giảm: " + formatCurrency(hoaDon.getTienGiam())).setFont(font));
            document.add(new Paragraph("Phí vận chuyển: " + formatCurrency(hoaDon.getPhiVanChuyen())).setFont(font));
            document.add(new Paragraph("Thành tiền: " + formatCurrency(hoaDon.getThanhTien())).setFont(font).setBold());

            document.close();

        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo PDF: " + e.getMessage());
        }
    }
    private String nonNull(Object value) {
        return value != null ? value.toString() : "Không có";
    }

    private String formatCurrency(java.math.BigDecimal value) {
        if (value == null) return "0 ₫";
        NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
        return formatter.format(value) + " ₫";
    }
}
