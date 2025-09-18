
package com.example.banaomz.controller.client.cart;

import com.example.banaomz.dto.admin.GioHang.CartItemDTO;
import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.repository.client.KhachHangClientRepository;
import com.example.banaomz.repository.client.SanPhamChiTietClientRepository;
import com.example.banaomz.service.client.IGioHangClientService;
import com.example.banaomz.service.client.IHoaDonClientService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Controller
@RequestMapping("/cart")
public class CartController {

    private final IGioHangClientService gioHangService;
    private final KhachHangClientRepository khachHangClientRepository;
    private final IHoaDonClientService hoaDonService;
    private final SanPhamChiTietClientRepository spctRepository;

    public CartController(IGioHangClientService gioHangService,
                          KhachHangClientRepository khachHangClientRepository,
                          IHoaDonClientService hoaDonService,
                          SanPhamChiTietClientRepository spctRepository) {
        this.gioHangService = gioHangService;
        this.khachHangClientRepository = khachHangClientRepository;
        this.hoaDonService = hoaDonService;
        this.spctRepository = spctRepository;
    }

    // ========== PAGE ==========
    @GetMapping
    public String cartIndex(Model model) {
        model.addAttribute("page", "cart/index");
        return "client/main";
    }

    // ========== API ==========
    @GetMapping("/items")
    @ResponseBody
    public List<CartItemDTO> getCart(HttpSession session) {
        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            return toDTO(gioHangService.layGioHang(kh));
        } else {
            @SuppressWarnings("unchecked")
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            return toDTO(cart);
        }
    }

    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<?> addToCart(@RequestParam Long spctId,
                                       @RequestParam Integer soLuong,
                                       HttpSession session) {
        if (spctId == null || soLuong == null || soLuong <= 0) {
            return ResponseEntity.badRequest().body(Map.of("message", "Dữ liệu không hợp lệ"));
        }

        Integer stock = spctRepository.getStock(spctId);
        if (stock == null || stock <= 0) {
            return ResponseEntity.badRequest().body(Map.of("message", "Sản phẩm hết hàng"));
        }

        KhachHang kh = getKhachHangFromSession(session);
        int req = soLuong;

        if (kh != null) {
            // lấy dòng hiện tại để tính tổng (nếu service của bạn tự cộng dồn thì có thể bỏ phần này)
            List<GioHang> cart = gioHangService.getCartByKhachHang(kh.getId().intValue());
            int current = cart.stream()
                    .filter(g -> g.getSanPhamChiTiet() != null && Objects.equals(g.getSanPhamChiTiet().getId(), spctId))
                    .map(g -> Optional.ofNullable(g.getSoLuong()).orElse(0))
                    .findFirst().orElse(0);

            int applied = Math.min(current + req, stock);
            int delta   = applied - current; // số cần cộng thêm thực tế

            if (delta <= 0) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("appliedQty", applied, "maxQty", stock,
                                "message", "Chỉ còn " + stock + " sản phẩm trong kho"));
            }

            SanPhamChiTiet spct = new SanPhamChiTiet(); spct.setId(spctId);
            gioHangService.themSanPham(kh, spct, delta);

            if (applied < current + req) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("appliedQty", applied, "maxQty", stock,
                                "message", "Chỉ còn " + stock + " sản phẩm trong kho"));
            }
            return ResponseEntity.ok(Map.of("appliedQty", applied));
        } else {
            // GUEST
            @SuppressWarnings("unchecked")
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart == null) cart = new ArrayList<>();

            int current = cart.stream()
                    .filter(g -> g.getSanPhamChiTiet() != null && Objects.equals(g.getSanPhamChiTiet().getId(), spctId))
                    .map(g -> Optional.ofNullable(g.getSoLuong()).orElse(0))
                    .findFirst().orElse(0);

            int applied = Math.min(current + req, stock);
            int delta   = applied - current;

            if (delta <= 0) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("appliedQty", applied, "maxQty", stock,
                                "message", "Chỉ còn " + stock + " sản phẩm trong kho"));
            }

            boolean found = false;
            for (GioHang g : cart) {
                if (g.getSanPhamChiTiet() != null && Objects.equals(g.getSanPhamChiTiet().getId(), spctId)) {
                    g.setSoLuong(current + delta);
                    found = true; break;
                }
            }
            if (!found) {
                GioHang g = new GioHang();
                SanPhamChiTiet sp = new SanPhamChiTiet(); sp.setId(spctId);
                g.setSanPhamChiTiet(sp); g.setSoLuong(delta);
                cart.add(g);
            }
            session.setAttribute("CART_GUEST", cart);

            if (applied < current + req) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("appliedQty", applied, "maxQty", stock,
                                "message", "Chỉ còn " + stock + " sản phẩm trong kho"));
            }
            return ResponseEntity.ok(Map.of("appliedQty", applied));
        }
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updateQuantity(@RequestParam Long spctId,
                                            @RequestParam Integer soLuong,
                                            HttpSession session) {
        if (spctId == null || soLuong == null || soLuong <= 0) {
            return ResponseEntity.badRequest().body(Map.of("message", "Dữ liệu không hợp lệ"));
        }

        Integer stock = spctRepository.getStock(spctId);
        if (stock == null || stock <= 0) {
            return ResponseEntity.badRequest().body(Map.of("message", "Sản phẩm hết hàng"));
        }

        int req = soLuong;
        int applied = Math.min(req, stock);

        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            SanPhamChiTiet spct = new SanPhamChiTiet(); spct.setId(spctId);
            gioHangService.capNhatSoLuong(kh, spct, applied);
        } else {
            @SuppressWarnings("unchecked")
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart != null) {
                for (GioHang g : cart) {
                    if (g.getSanPhamChiTiet() != null &&
                            Objects.equals(g.getSanPhamChiTiet().getId(), spctId)) {
                        g.setSoLuong(applied);
                        break;
                    }
                }
                session.setAttribute("CART_GUEST", cart);
            }
        }

        if (applied < req) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("appliedQty", applied, "maxQty", stock,
                            "message", "Chỉ còn " + stock + " sản phẩm trong kho"));
        }
        return ResponseEntity.ok(Map.of("appliedQty", applied));
    }

    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<?> removeFromCart(@RequestParam Long spctId,
                                            HttpSession session) {
        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            SanPhamChiTiet spct = new SanPhamChiTiet(); spct.setId(spctId);
            gioHangService.xoaSanPham(kh, spct);
            return ResponseEntity.ok().build();
        } else {
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart != null) {
                cart.removeIf(g -> g.getSanPhamChiTiet() != null &&
                        Objects.equals(g.getSanPhamChiTiet().getId(), spctId));
                session.setAttribute("CART_GUEST", cart);
            }
            return ResponseEntity.ok().build();
        }
    }

    @PostMapping("/clear")
    @ResponseBody
    public ResponseEntity<Void> clearCart(HttpSession session) {
        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            gioHangService.xoaToanBo(kh);
        } else {
            session.removeAttribute("CART_GUEST");
        }
        return ResponseEntity.ok().build();
    }

    // ========== CHECKOUT có GHN ==========
    @PostMapping("/checkout")
    @ResponseBody
    public ResponseEntity<?> checkout(
            @RequestParam String hoTen,
            @RequestParam String sdt,
            @RequestParam String diaChi,

            // ==== GHN params (FE có thể gửi dưới dạng string, Spring sẽ convert) ====
            @RequestParam(name = "shipFee", required = false) BigDecimal shipFee,
            @RequestParam(name = "shipServiceId", required = false) Long shipServiceId,
            @RequestParam(name = "shipToDistrictId", required = false) Integer shipToDistrictId,
            @RequestParam(name = "shipToWardCode", required = false) String shipToWardCode,
            @RequestParam(name = "shipWeight", required = false) Integer shipWeight,
            @RequestParam(name = "shipLength", required = false) Integer shipLength,
            @RequestParam(name = "shipWidth", required = false) Integer shipWidth,
            @RequestParam(name = "shipHeight", required = false) Integer shipHeight,

            HttpSession session
    ) {
        try {
            // mặc định nếu FE không truyền
            if (shipFee == null)       shipFee = BigDecimal.ZERO;
            if (shipWeight == null)    shipWeight = 0;
            if (shipLength == null)    shipLength = 0;
            if (shipWidth == null)     shipWidth = 0;
            if (shipHeight == null)    shipHeight = 0;

            KhachHang kh = getKhachHangFromSession(session);
            if (kh != null) {
                // MEMBER: lấy cart từ DB
                List<GioHang> cart = gioHangService.getCartByKhachHang(kh.getId().intValue());
                if (cart == null || cart.isEmpty()) {
                    return ResponseEntity.badRequest().body("Giỏ hàng trống");
                }

                hoaDonService.taoHoaDonMember(
                        cart, kh, hoTen, sdt, diaChi,
                        shipFee, shipServiceId, shipToDistrictId, shipToWardCode,
                        shipWeight, shipLength, shipWidth, shipHeight
                );

                gioHangService.clearCartByKhachHang(kh.getId().intValue());
                return ResponseEntity.ok("Đặt hàng thành công (member)");
            } else {
                // GUEST: lấy cart từ session
                @SuppressWarnings("unchecked")
                List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
                if (cart == null || cart.isEmpty()) {
                    return ResponseEntity.badRequest().body("Giỏ hàng trống");
                }

                hoaDonService.taoHoaDonGuest(
                        cart, hoTen, sdt, diaChi,
                        shipFee, shipServiceId, shipToDistrictId, shipToWardCode,
                        shipWeight, shipLength, shipWidth, shipHeight
                );

                session.removeAttribute("CART_GUEST");
                return ResponseEntity.ok("Đặt hàng thành công (guest)");
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi khi checkout: " + e.getMessage());
        }
    }

    // ========== WHOAMI ==========
    @GetMapping("/whoami")
    @ResponseBody
    public Map<String,Object> whoAmI(HttpSession session) {
        var m = new LinkedHashMap<String,Object>();
        m.put("sessionId", session.getId());
        Object v = session.getAttribute("KH_ID");
        if (v != null) {
            Long khId = (v instanceof Long) ? (Long) v :
                    (v instanceof Integer) ? ((Integer) v).longValue() : null;
            m.put("authenticated", true);
            m.put("khId", khId);
        } else {
            m.put("authenticated", false);
        }
        return m;
    }

    // ========== Helpers ==========
    private KhachHang getKhachHangFromSession(HttpSession session) {
        Object v = session.getAttribute("KH_ID");
        if (v == null) return null;
        Long khId = (v instanceof Long) ? (Long) v :
                (v instanceof Integer) ? ((Integer) v).longValue() : null;
        if (khId == null) return null;
        return khachHangClientRepository.findById(khId).orElse(null);
    }

    private List<CartItemDTO> toDTO(List<GioHang> cart) {
        if (cart == null || cart.isEmpty()) return List.of();

        List<Long> ids = cart.stream()
                .map(g -> g.getSanPhamChiTiet() != null ? g.getSanPhamChiTiet().getId() : null)
                .filter(Objects::nonNull)
                .distinct()
                .toList();

        Map<Long, SanPhamChiTiet> spctMap = spctRepository.findAllById(ids).stream()
                .collect(Collectors.toMap(SanPhamChiTiet::getId, Function.identity()));

        List<CartItemDTO> out = new ArrayList<>(cart.size());
        for (GioHang g : cart) {
            Long id = (g.getSanPhamChiTiet() != null) ? g.getSanPhamChiTiet().getId() : null;
            SanPhamChiTiet spct = (id != null) ? spctMap.get(id) : null;

            String tenSp = (spct != null && spct.getSanPham() != null)
                    ? spct.getSanPham().getTenSanPham() : "Sản phẩm";
            String anh = (spct != null && spct.getSanPham() != null)
                    ? spct.getSanPham().getUrlAnh() : "/images/no-image.png";
            BigDecimal gia = (spct != null && spct.getGiaBan() != null)
                    ? spct.getGiaBan() : BigDecimal.ZERO;
            Integer soLuong = (g.getSoLuong() != null) ? g.getSoLuong() : 0;
            String mau  = (spct != null && spct.getMauSac() != null) ? spct.getMauSac().getTenMauSac() : null;
            String size = (spct != null && spct.getSize()    != null) ? spct.getSize().getTenSize()    : null;

            String tenHienThi = tenSp
                    + (mau  != null ? " - " + mau  : "")
                    + (size != null ? " / " + size : "");

            out.add(new CartItemDTO(id, tenSp, anh, gia, soLuong, mau, size, tenHienThi));
        }
        return out;
    }
}
