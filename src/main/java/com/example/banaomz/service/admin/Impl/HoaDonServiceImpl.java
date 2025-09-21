package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonDetailResponseDTO;
import com.example.banaomz.dto.admin.HoaDon.Reponse.HoaDonResponseDTO;
import com.example.banaomz.dto.admin.HoaDonChiTiet.Reponse.HoaDonChiTietResponseDTO;
import com.example.banaomz.entity.admin.HoaDon;
import com.example.banaomz.entity.admin.HoaDonChiTiet;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.repository.admin.IHoaDonChiTietRepository;
import com.example.banaomz.repository.admin.IHoaDonRepository;
import com.example.banaomz.repository.admin.ISanPhamChiTietRepository;
import com.example.banaomz.repository.admin.ISanPhamRepository;
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
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor

public class HoaDonServiceImpl implements IHoaDonService {

    // ===== Trạng thái cho COD (KH nhận hàng rồi mới thanh toán) =====
    private static final String CHO_XAC_NHAN = "CHO_XAC_NHAN";
    private static final String CHO_CHUAN_BI_HANG = "CHO_CHUAN_BI_HANG";
    private static final String DANG_GIAO = "DANG_GIAO";
    private static final String GIAO_THAT_BAI = "GIAO_THAT_BAI";
    private static final String HOAN_HANG = "HOAN_HANG";
    private static final String DA_HOAN_HANG = "DA_HOAN_HANG";
    private static final String HOAN_THANH = "HOAN_THANH";
    private static final String HUY = "HUY";

    /**
     * Nhóm trạng thái được tính là "đã bán" (đã xuất kho & cộng soLuongDaBan)
     */
    private static final Set<String> COUNTED_AS_SOLD = Set.of(
            CHO_XAC_NHAN, CHO_CHUAN_BI_HANG, DANG_GIAO, HOAN_THANH
    );

    private final IHoaDonRepository hoaDonRepository;
    private final IHoaDonChiTietRepository hoaDonChiTietRepo;
    private final ISanPhamChiTietRepository sanPhamChiTietRepo;
    private final ISanPhamRepository sanPhamRepo;


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

    @Override
    public List<HoaDonDetailResponseDTO> getOrdersByCustomerId(Long customerId) {
        List<HoaDon> hoaDonList = hoaDonRepository.findByKhachHangId(customerId);
        return hoaDonList.stream()
                .map(h -> new HoaDonDetailResponseDTO(
                        h.getId(),
                        h.getMaHoaDon(),
                        h.getNgayDat(),
                        h.getTrangThai(),
                        h.getKhachHang().getHoVaTen(),
                        h.getTenNguoiNhan(),
                        h.getSoDienThoaiNguoiNhan(),
                        h.getDiaChiNguoiNhan(),
                        h.getTongTien(),
                        h.getTienGiam(),
                        h.getPhiVanChuyen(),
                        h.getThanhTien(),
                        h.getLoaiHoaDon(),
                        h.getPhuongThucThanhToan()
                ))
                .toList();
    }

    @Override
    public void huyDonHang(Long id) {
        HoaDon hoaDon = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        if ("DANG_GIAO".equalsIgnoreCase(hoaDon.getTrangThai())) {
            throw new RuntimeException("Đơn hàng đang được giao không thể hủy.");
        }

        if ("HOAN_THANH".equalsIgnoreCase((hoaDon.getTrangThai()))) {
            throw new RuntimeException(("Đơn hàng đã được giao thành công."));
        }

        if ("HUY".equalsIgnoreCase((hoaDon.getTrangThai()))) {
            throw new RuntimeException(("Đơn hàng đã đc hủy."));
        }

        hoaDon.setTrangThai("HUY");
        hoaDon.setNgaySua(LocalDateTime.now());
        hoaDonRepository.save(hoaDon);
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

        // Nếu chỉ áp dụng cho ONLINE thì bật check; muốn áp dụng mọi loại thì bỏ if này
        if (!"ONLINE".equalsIgnoreCase(hd.getLoaiHoaDon())) {
            throw new IllegalStateException("Chỉ cho phép đổi trạng thái với hoá đơn ONLINE");
        }

        String from = Optional.ofNullable(hd.getTrangThai()).orElse("");
        String to   = (trangThaiMoi == null) ? "" : trangThaiMoi.toUpperCase();

        if (!canTransit(from, to)) {
            throw new IllegalArgumentException("Không thể chuyển trạng thái từ " + from + " -> " + to);
        }

        // ---- ÁP DỤNG KHO/ĐÃ BÁN THEO CHUYỂN TRẠNG THÁI (idempotent) ----
        boolean wasCounted  = COUNTED_AS_SOLD.contains(from);
        boolean willCounted = COUNTED_AS_SOLD.contains(to);

        if (!wasCounted && willCounted) {
            // Lần đầu đi vào nhóm "đã bán" -> trừ kho & + soLuongDaBan
            applyInventoryForOrder(hd, -1);
        } else if (wasCounted && !willCounted) {
            // Rời nhóm "đã bán" (HUY / DA_HOAN_HANG) -> cộng kho & − soLuongDaBan
            applyInventoryForOrder(hd, +1);
        }

        // ---- Các side-effect khác theo từng trạng thái (không đụng kho nữa) ----
        switch (to) {
            case DANG_GIAO:
                if (hd.getNgayGiao() == null) hd.setNgayGiao(LocalDateTime.now());
                break;
            case HOAN_THANH:
                hd.setNgayHoanThanh(LocalDateTime.now());
                break;
            default:
                // nothing
        }

        hd.setTrangThai(to);
        hd.setNgaySua(LocalDateTime.now());
        hoaDonRepository.save(hd);

        return getDetailById(id);
    }

    private boolean canTransit(String from, String to) {
        if (to == null || to.isEmpty()) return false;
        if (from == null || from.isEmpty()) return CHO_XAC_NHAN.equals(to);

        switch (from) {
            case CHO_XAC_NHAN:
                return to.equals(CHO_CHUAN_BI_HANG) || to.equals(DANG_GIAO) || to.equals(HUY);
            case CHO_CHUAN_BI_HANG:
                return to.equals(DANG_GIAO) || to.equals(HUY);
            case DANG_GIAO:
                return to.equals(HOAN_THANH) || to.equals(GIAO_THAT_BAI) || to.equals(HOAN_HANG);
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

    /* ================= INVENTORY CORE ================= */

    /**
     * Cộng/trừ kho & soLuongDaBan theo chiều:
     * dir = -1  -> bán: trừ kho biến thể, + soLuongDaBan
     * dir = +1  -> hoàn/huỷ: cộng kho biến thể, − soLuongDaBan
     */
    private void applyInventoryForOrder(HoaDon hd, int dir) {
        List<HoaDonChiTiet> cts = hoaDonChiTietRepo.findByHoaDonId(hd.getId().longValue());
        if (cts == null || cts.isEmpty()) return;

        Map<Long, Integer> sumBySanPham = new HashMap<>();

        for (HoaDonChiTiet ct : cts) {
            SanPhamChiTiet spct = ct.getSanPhamChiTiet();
            if (spct == null) continue;

            int qty = Optional.ofNullable(ct.getSoLuong()).orElse(0);
            int ton = Optional.ofNullable(spct.getSoLuong()).orElse(0);

            if (dir == -1 && ton < qty) {
                // Tránh âm kho
                throw new IllegalStateException("Kho không đủ cho SPCT ID=" + spct.getId());
            }

            int newTon = ton + dir * qty; // dir -1: trừ; dir +1: cộng
            if (newTon < 0) newTon = 0;
            spct.setSoLuong(newTon);
            sanPhamChiTietRepo.save(spct);

            Long idSp = spct.getSanPham().getId();
            sumBySanPham.merge(idSp, qty, Integer::sum);
        }

        for (Map.Entry<Long, Integer> e : sumBySanPham.entrySet()) {
            SanPham sp = sanPhamRepo.findById(e.getKey()).orElse(null);
            if (sp == null) continue;

            int sold = Optional.ofNullable(sp.getSoLuongDaBan()).orElse(0);
            sold += (dir == -1 ? e.getValue() : -e.getValue());
            if (sold < 0) sold = 0;
            sp.setSoLuongDaBan(sold);
            sanPhamRepo.save(sp);
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
        NumberFormat f = NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
        return f.format(value == null ? BigDecimal.ZERO : value) + " ₫";
    }
}
