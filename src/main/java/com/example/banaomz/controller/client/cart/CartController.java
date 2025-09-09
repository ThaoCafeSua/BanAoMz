package com.example.banaomz.controller.client.cart;

import com.example.banaomz.entity.admin.GioHang;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.entity.admin.SanPhamChiTiet;
import com.example.banaomz.repository.client.KhachHangClientRepository;
import com.example.banaomz.service.client.IGioHangClientService;
import com.example.banaomz.service.client.IHoaDonClientService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    private final IGioHangClientService gioHangService;
    private final KhachHangClientRepository khachHangClientRepository;
    private final IHoaDonClientService hoaDonService;

    public CartController(IGioHangClientService gioHangService,
                          KhachHangClientRepository khachHangClientRepository ,
                          IHoaDonClientService hoaDonService) {
        this.gioHangService = gioHangService;
        this.khachHangClientRepository = khachHangClientRepository;
        this.hoaDonService = hoaDonService;
    }

    // ✅ Trang giỏ hàng
    @GetMapping
    public String cartIndex(Model model) {
        model.addAttribute("page", "cart/index");
        return "client/main";
    }

    // ✅ API: Lấy giỏ hàng theo khách hàng
    @GetMapping("/items")
    @ResponseBody
    public ResponseEntity<?> getCart(Principal principal, HttpSession session) {
        if (principal != null) {
            // Đã đăng nhập → lấy giỏ từ DB
            KhachHang kh = getKhachHangFromPrincipal(principal);
            return ResponseEntity.ok(gioHangService.layGioHang(kh));
        } else {
            // Guest → lấy từ session
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            return ResponseEntity.ok(cart != null ? cart : List.of());
        }
    }


    // ✅ API: Thêm sản phẩm vào giỏ
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<?> addToCart(@RequestParam Long spctId,
                                       @RequestParam Integer soLuong,
                                       Principal principal,
                                       HttpSession session) {
        if (principal != null) {
            // Member → DB
            KhachHang kh = getKhachHangFromPrincipal(principal);
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setId(spctId);
            GioHang item = gioHangService.themSanPham(kh, spct, soLuong);
            return ResponseEntity.ok(item);
        } else {
            // Guest → lưu session
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart == null) cart = new ArrayList<>();

            // check tồn tại
            boolean found = false;
            for (GioHang g : cart) {
                if (g.getSanPhamChiTiet().getId().equals(spctId)) {
                    g.setSoLuong(g.getSoLuong() + soLuong);
                    found = true;
                    break;
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
                                            Principal principal,
                                            HttpSession session) {
        if (principal != null) {
            // Member
            KhachHang khachHang = getKhachHangFromPrincipal(principal);
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setId(spctId);
            GioHang item = gioHangService.capNhatSoLuong(khachHang, spct, soLuong);
            return ResponseEntity.ok(item);
        } else {
            // Guest
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart != null) {
                for (GioHang g : cart) {
                    if (g.getSanPhamChiTiet().getId().equals(spctId)) {
                        g.setSoLuong(soLuong);
                        break;
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
                                            Principal principal,
                                            HttpSession session) {
        if (principal != null) {
            // Member
            KhachHang khachHang = getKhachHangFromPrincipal(principal);
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setId(spctId);
            gioHangService.xoaSanPham(khachHang, spct);
            return ResponseEntity.ok().build();
        } else {
            // Guest
            List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
            if (cart != null) {
                cart.removeIf(g -> g.getSanPhamChiTiet().getId().equals(spctId));
                session.setAttribute("CART_GUEST", cart);
            }
            return ResponseEntity.ok().build();
        }
    }


    @PostMapping("/clear")
    @ResponseBody
    public ResponseEntity<Void> clearCart(Principal principal, HttpSession session) {
        if (principal != null) {
            KhachHang khachHang = getKhachHangFromPrincipal(principal);
            gioHangService.xoaToanBo(khachHang);
        } else {
            session.removeAttribute("CART_GUEST");
        }
        return ResponseEntity.ok().build();
    }

    private KhachHang getKhachHangFromPrincipal(Principal principal) {
        if (principal == null) {
            return null; // guest
        }

        String username = principal.getName(); // chính là email/username đã login
        return khachHangClientRepository.findByEmail(username)
                .orElseThrow(() ->
                        new RuntimeException("Không tìm thấy khách hàng với username: " + username));
    }
//    @PostMapping("/checkout")
//    @ResponseBody
//    public ResponseEntity<?> checkout(@RequestParam String hoTen,
//                                      @RequestParam String sdt,
//                                      @RequestParam String diaChi,
//                                      Principal principal,
//                                      HttpSession session) {
//        try {
//            if (principal != null) {
//                // 🟢 Member checkout
//                KhachHang kh = getKhachHangFromPrincipal(principal);
//
//                // Lấy giỏ từ DB (member thường lưu giỏ trong DB)
//                List<GioHang> cart = gioHangService.getCartByKhachHang(kh.getId());
//                if (cart == null || cart.isEmpty()) {
//                    return ResponseEntity.badRequest().body("Giỏ hàng trống");
//                }
//
//                hoaDonService.taoHoaDonMember(cart, kh, hoTen, sdt, diaChi);
//                gioHangService.clearCartByKhachHang(kh.getId()); // clear giỏ DB sau thanh toán
//
//                return ResponseEntity.ok("Đặt hàng thành công (member)");
//
//            } else {
//                // 🟡 Guest checkout
//                List<GioHang> cart = (List<GioHang>) session.getAttribute("CART_GUEST");
//                if (cart == null || cart.isEmpty()) {
//                    return ResponseEntity.badRequest().body("Giỏ hàng trống");
//                }
//
//                hoaDonService.taoHoaDonGuest(cart, hoTen, sdt, diaChi);
//                session.removeAttribute("CART_GUEST"); // clear giỏ session sau thanh toán
//
//                return ResponseEntity.ok("Đặt hàng thành công (guest)");
//            }
//
//        } catch (Exception e) {
//            return ResponseEntity.internalServerError().body("Lỗi khi checkout: " + e.getMessage());
//        }
//    }


}
