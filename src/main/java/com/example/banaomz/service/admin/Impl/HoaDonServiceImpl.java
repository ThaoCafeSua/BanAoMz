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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class HoaDonServiceImpl implements IHoaDonService {

    // ===== Trạng thái cho COD (KH nhận hàng rồi mới thanh toán) =====
    private static final String CHO_XAC_NHAN       = "CHO_XAC_NHAN";
    private static final String CHO_CHUAN_BI_HANG  = "CHO_CHUAN_BI_HANG";
    private static final String DANG_GIAO          = "DANG_GIAO";
    private static final String GIAO_THAT_BAI      = "GIAO_THAT_BAI";
    private static final String HOAN_HANG          = "HOAN_HANG";
    private static final String DA_HOAN_HANG       = "DA_HOAN_HANG";
    private static final String HOAN_THANH         = "HOAN_THANH";
    private static final String HUY                = "HUY";

    private final IHoaDonRepository hoaDonRepository;

    public HoaDonServiceImpl(IHoaDonRepository hoaDonRepository) {
        this.hoaDonRepository = hoaDonRepository;
    }

    /* =================== LIST =================== */
    @Override
    public List<HoaDonResponseDTO> getAll() {
        return hoaDonRepository.findAllByOrderByNgayTaoDesc()
                .stream()
                .map(hd -> new HoaDonResponseDTO(
                        hd.getId(),
                        hd.getMaHoaDon(),
                        hd.getNgayDat(),
                        (hd.getKhachHang() != null && hd.getKhachHang().getHoVaTen() != null)
                                ? hd.getKhachHang().getHoVaTen()
                                : hd.getTenNguoiNhan(),
                        hd.getSoDienThoaiNguoiNhan(),
                        hd.getDiaChiNguoiNhan(),
                        nvl(hd.getThanhTien()),
                        hd.getTrangThai(),
                        hd.getLoaiHoaDon(),
                        hd.getPhuongThucThanhToan()
                ))
                .collect(Collectors.toList());
    }

    /* =================== DETAIL (header) =================== */
    @Override
    public HoaDonDetailResponseDTO getDetailById(Long id) {
        return hoaDonRepository.findDetail(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn ID=" + id));
    }

    /* =================== EXPORT PDF =================== */
    @Override
    public void exportHoaDonPdf(Long id, OutputStream outputStream) {
        HoaDonDetailResponseDTO hdHeader = getDetailById(id);
        HoaDon hdEntity = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn ID=" + id));

        try {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            String fontPath = Objects.requireNonNull(
                    getClass().getClassLoader().getResource("fonts/LiberationSans-Regular.ttf")
            ).toURI().getPath();
            PdfFont font = PdfFontFactory.createFont(fontPath, PdfEncodings.IDENTITY_H);
            document.setFont(font);

            document.add(new Paragraph("HÓA ĐƠN BÁN HÀNG")
                    .setFont(font).setBold().setFontSize(18)
                    .setTextAlignment(TextAlignment.CENTER));

            document.add(new Paragraph("Mã hóa đơn: " + nonNull(hdHeader.getMaHoaDon())).setFont(font));
            document.add(new Paragraph("Khách hàng: " + nonNull(hdHeader.getKhachHangTen())).setFont(font));
            document.add(new Paragraph("Người nhận: " + nonNull(hdHeader.getTenNguoiNhan())).setFont(font));
            document.add(new Paragraph("Ngày đặt: " + nonNull(hdHeader.getNgayDat())).setFont(font));
            document.add(new Paragraph("\n"));

            float[] widths = {4, 3, 2, 2, 3};
            Table table = new Table(widths).useAllAvailableWidth();

            table.addHeaderCell(new Cell().add(new Paragraph("Sản phẩm").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Màu sắc").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Size").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Số lượng").setFont(font).setBold()));
            table.addHeaderCell(new Cell().add(new Paragraph("Thành tiền").setFont(font).setBold()));

            List<HoaDonChiTietResponseDTO> lines = hdEntity.getHoaDonChiTietList().stream()
                    .map(ct -> new HoaDonChiTietResponseDTO(
                            safe(() -> ct.getSanPhamChiTiet().getSanPham().getTenSanPham()),
                            safe(() -> ct.getSanPhamChiTiet().getMauSac().getTenMauSac()),
                            safe(() -> ct.getSanPhamChiTiet().getSize().getTenSize()),
                            Objects.requireNonNullElse(ct.getSoLuong(), 0),
                            nvl(ct.getGiaBan()),
                            nvl(ct.getGiaBan()).multiply(BigDecimal.valueOf(Objects.requireNonNullElse(ct.getSoLuong(), 0)))
                    ))
                    .collect(Collectors.toList());

            for (var ct : lines) {
                table.addCell(new Cell().add(new Paragraph(nonNull(ct.getTenSanPham())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(nonNull(ct.getMauSac())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(nonNull(ct.getSize())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(ct.getSoLuong())).setFont(font)));
                table.addCell(new Cell().add(new Paragraph(formatCurrency(ct.getThanhTien())).setFont(font)));
            }

            document.add(table);
            document.add(new Paragraph("\n"));

            document.add(new Paragraph("Tổng tiền: " + formatCurrency(hdHeader.getTongTien())).setFont(font));
            document.add(new Paragraph("Tiền giảm: " + formatCurrency(hdHeader.getTienGiam())).setFont(font));
            document.add(new Paragraph("Phí vận chuyển: " + formatCurrency(hdHeader.getPhiVanChuyen())).setFont(font));
            document.add(new Paragraph("Thành tiền: " + formatCurrency(hdHeader.getThanhTien())).setFont(font).setBold());

            document.close();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo PDF: " + e.getMessage(), e);
        }
    }

    /* ================= CẬP NHẬT TRẠNG THÁI ================= */
    @Transactional
    @Override
    public HoaDonDetailResponseDTO updateTrangThai(Long id, String trangThaiMoi) {
        var hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hoá đơn ID=" + id));

        // Nếu muốn áp dụng cho mọi loại hóa đơn, bỏ điều kiện này
        if (!"ONLINE".equalsIgnoreCase(hd.getLoaiHoaDon())) {
            throw new IllegalStateException("Chỉ cho phép đổi trạng thái với hoá đơn ONLINE");
        }

        String from = hd.getTrangThai();
        String to = (trangThaiMoi == null) ? "" : trangThaiMoi.toUpperCase();

        if (!canTransit(from, to)) {
            throw new IllegalArgumentException("Không thể chuyển trạng thái từ " + from + " -> " + to);
        }

        switch (to) {
            case CHO_XAC_NHAN:
                lockPricesAndPromotions(hd);
                break;

            case CHO_CHUAN_BI_HANG:
                reserveOrDeductStock(hd);
                break;

            case DANG_GIAO:
                createShipmentAndSetNgayGiao(hd);
                break;

            case GIAO_THAT_BAI:
                markDeliveryFailed(hd);
                break;

            case HOAN_HANG:
                startReturnToWarehouse(hd);
                break;

            case DA_HOAN_HANG:
                finishReturnAndRestock(hd); // trả kho, mở voucher, đóng vận đơn
                break;

            case HOAN_THANH:
                hd.setNgayHoanThanh(java.time.LocalDateTime.now());
                increaseSoldCount(hd);
                closeAccounting(hd);
                break;

            case HUY:
                releaseStock(hd);
                refundIfNeeded(hd);
                releaseVoucherIfAny(hd);
                break;
        }

        hd.setTrangThai(to);
        hd.setNgaySua(java.time.LocalDateTime.now());
        hoaDonRepository.save(hd);

        return getDetailById(id);
    }

    private boolean canTransit(String from, String to) {
        if (to == null) return false;
        if (from == null) return CHO_XAC_NHAN.equalsIgnoreCase(to);

        from = from.toUpperCase();
        to   = to.toUpperCase();

        switch (from) {
            case CHO_XAC_NHAN:
                return to.equals(CHO_CHUAN_BI_HANG) || to.equals(HUY);

            case CHO_CHUAN_BI_HANG:
                return to.equals(DANG_GIAO) || to.equals(HUY);

            case DANG_GIAO:
                return to.equals(HOAN_THANH) || to.equals(GIAO_THAT_BAI);

            case GIAO_THAT_BAI:
                return to.equals(DANG_GIAO) || to.equals(HOAN_HANG) || to.equals(HUY);

            case HOAN_HANG:
                return to.equals(DA_HOAN_HANG);

            case DA_HOAN_HANG:
            case HOAN_THANH:
            case HUY:
                return false;

            default:
                return false;
        }
    }

    /* ================= Helpers ================= */
    private BigDecimal nvl(BigDecimal v) { return v == null ? BigDecimal.ZERO : v; }
    private String nonNull(Object v) { return v == null ? "Không có" : v.toString(); }

    private static String safe(SupplierX<String> s) {
        try { return s.get(); } catch (Exception e) { return ""; }
    }
    @FunctionalInterface interface SupplierX<T> { T get() throws Exception; }

    private String formatCurrency(BigDecimal value) {
        NumberFormat f = NumberFormat.getInstance(new Locale("vi", "VN"));
        return f.format(value == null ? BigDecimal.ZERO : value) + " ₫";
    }

    /* ====== Stub side-effects (tuỳ hệ thống của bạn) ====== */
    private void lockPricesAndPromotions(HoaDon hd) { /* khoá giá/ưu đãi nếu cần */ }
    private void reserveOrDeductStock(HoaDon hd) { /* giữ kho hoặc trừ kho khi chuẩn bị */ }
    private void createShipmentAndSetNgayGiao(HoaDon hd) {
        if (hd.getNgayGiao() == null) hd.setNgayGiao(java.time.LocalDateTime.now());
        /* tạo vận đơn nếu cần */
    }
    private void markDeliveryFailed(HoaDon hd) { /* tăng bộ đếm fail, note lý do... */ }
    private void startReturnToWarehouse(HoaDon hd) { /* gọi API hãng vận chuyển hoàn hàng... */ }
    private void finishReturnAndRestock(HoaDon hd) {
        releaseStock(hd);          // trả kho
        releaseVoucherIfAny(hd);   // mở lại mã giảm nếu cần
        /* đóng vận đơn hoàn hàng */
    }
    private void increaseSoldCount(HoaDon hd) { /* cộng soLuongDaBan */ }
    private void closeAccounting(HoaDon hd) { /* ghi nhận doanh thu, đối soát COD */ }
    private void releaseStock(HoaDon hd) { /* trả lại kho nếu đã giữ */ }
    private void refundIfNeeded(HoaDon hd) { /* COD: thường chưa thu, nên không hoàn tiền */ }
    private void releaseVoucherIfAny(HoaDon hd) { /* mở lại mã giảm (nếu có) */ }
}
