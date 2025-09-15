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
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
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
                          KhachHangClientRepository khachHangClientRepository ,
                          IHoaDonClientService hoaDonService,
                          SanPhamChiTietClientRepository spctRepository) {
        this.gioHangService = gioHangService;
        this.khachHangClientRepository = khachHangClientRepository;
        this.hoaDonService = hoaDonService;
        this.spctRepository = spctRepository;
    }

    // ✅ Trang giỏ hàng
    @GetMapping
    public String cartIndex(Model model) {
        model.addAttribute("page", "cart/index");
        return "client/main";
    }

    @GetMapping("/items")
    @ResponseBody
    public List<CartItemDTO> getCart(HttpSession session) {
        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            // member -> từ DB
            List<GioHang> dbCart = gioHangService.layGioHang(kh);
            return toDTO(dbCart);
        } else {
            // guest -> từ session
            @SuppressWarnings("unchecked")
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            return toDTO(cart);
        }
    }


    // 🔒 Hàm map sang DTO (không phải handler)
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

            // Lấy tên màu/size – đổi getter nếu entity khác tên
            String mau  = (spct != null && spct.getMauSac() != null) ? spct.getMauSac().getTenMauSac() : null;
            String size = (spct != null && spct.getSize()    != null) ? spct.getSize().getTenSize()    : null;

            String tenHienThi = tenSp
                    + (mau  != null ? " - " + mau  : "")
                    + (size != null ? " / " + size : "");

            out.add(new CartItemDTO(id, tenSp, anh, gia, soLuong, mau, size, tenHienThi));
        }
        return out;
    }

    // ✅ API: Thêm sản phẩm vào giỏ
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<?> addToCart(@RequestParam Long spctId,
                                       @RequestParam Integer soLuong,
                                       HttpSession session) {

        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            // member -> DB
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setId(spctId);
            GioHang item = gioHangService.themSanPham(kh, spct, soLuong);
            return ResponseEntity.ok(item);
        } else {
            // guest -> session
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart == null) cart = new ArrayList<>();

            boolean found = false;
            for (GioHang g : cart) {
                if (g.getSanPhamChiTiet() != null &&
                        Objects.equals(g.getSanPhamChiTiet().getId(), spctId)) {
                    g.setSoLuong(g.getSoLuong() + soLuong);
                    found = true; break;
                }
            }
            if (!found) {
                GioHang g = new GioHang();
                SanPhamChiTiet spct = new SanPhamChiTiet();
                spct.setId(spctId);
                g.setSanPhamChiTiet(spct);
                g.setSoLuong(soLuong);
                cart.add(g);
            }
            session.setAttribute("CART_GUEST", cart);
            return ResponseEntity.ok(cart);
        }
    }



    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updateQuantity(@RequestParam Long spctId,
                                            @RequestParam Integer soLuong,
                                            HttpSession session) {
        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setId(spctId);
            GioHang item = gioHangService.capNhatSoLuong(kh, spct, soLuong);
            return ResponseEntity.ok(item);
        } else {
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart != null) {
                for (GioHang g : cart) {
                    if (g.getSanPhamChiTiet() != null &&
                            Objects.equals(g.getSanPhamChiTiet().getId(), spctId)) {
                        g.setSoLuong(soLuong); break;
                    }
                }
                session.setAttribute("CART_GUEST", cart);
            }
            return ResponseEntity.ok(cart);
        }
    }


    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<?> removeFromCart(@RequestParam Long spctId,
                                            HttpSession session) {
        KhachHang kh = getKhachHangFromSession(session);
        if (kh != null) {
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setId(spctId);
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


    private KhachHang getKhachHangFromSession(HttpSession session) {
        Object v = session.getAttribute("KH_ID");
        if (v == null) return null;

        Long khId = null;
        if (v instanceof Long) khId = (Long) v;
        else if (v instanceof Integer) khId = ((Integer) v).longValue();

        if (khId == null) return null;
        return khachHangClientRepository.findById(khId).orElse(null);
    }
    @PostMapping("/checkout")
    @ResponseBody
    public ResponseEntity<?> checkout(@RequestParam String hoTen,
                                      @RequestParam String sdt,
                                      @RequestParam String diaChi,
                                      HttpSession session) {
        try {
            KhachHang kh = getKhachHangFromSession(session);
            if (kh != null) {
                // 🟢 Member
                List<GioHang> cart = gioHangService.getCartByKhachHang(kh.getId().intValue());
                if (cart == null || cart.isEmpty()) {
                    return ResponseEntity.badRequest().body("Giỏ hàng trống");
                }
                hoaDonService.taoHoaDonMember(cart, kh, hoTen, sdt, diaChi);
                gioHangService.clearCartByKhachHang(kh.getId().intValue());
                return ResponseEntity.ok("Đặt hàng thành công (member)");
            } else {
                // 🟡 Guest
                List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
                if (cart == null || cart.isEmpty()) {
                    return ResponseEntity.badRequest().body("Giỏ hàng trống");
                }
                hoaDonService.taoHoaDonGuest(cart, hoTen, sdt, diaChi);
                session.removeAttribute("CART_GUEST");
                return ResponseEntity.ok("Đặt hàng thành công (guest)");
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi khi checkout: " + e.getMessage());
        }
    }

    @GetMapping("/whoami")
    @ResponseBody
    public java.util.Map<String,Object> whoAmI(HttpSession session) {
        var m = new java.util.LinkedHashMap<String,Object>();
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


}
