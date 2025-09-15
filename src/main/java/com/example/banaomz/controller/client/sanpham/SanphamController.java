package com.example.banaomz.controller.client.sanpham;

import com.example.banaomz.entity.client.IProductItemClient;
import com.example.banaomz.ultiltes.SlugUtils;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.banaomz.service.client.ISanPhamClientService;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Controller
@RequestMapping("/sanpham")
public class SanphamController {

    @Autowired
    private ISanPhamClientService sanPhamClientService;

    @GetMapping
    public String sanPhamPage(Model model) {
        var list = sanPhamClientService.getSanPhamMoiNhat(null, "HOAT_DONG");
        model.addAttribute("listSp", list);
        model.addAttribute("page", "sanpham/index");
        return "client/main";
    }

    @GetMapping("/{id}")
    public String redirectToSlug(@PathVariable Long id) {
        var sanPham = sanPhamClientService.getSanPhamById(id);
        if (sanPham == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm");
        }
        String correctSlug = SlugUtils.toSlug(sanPham.getTenSanPham());
        return "redirect:/sanpham/" + sanPham.getId() + "/" + correctSlug;
    }

    @GetMapping("/{id}/{slug}")
    public String sanPhamDetail(@PathVariable Long id,
                                @PathVariable String slug,
                                Model model) {
        try {
            var sanPham = sanPhamClientService.getSanPhamById(id);
            if (sanPham == null) {
                model.addAttribute("error", "Không tìm thấy sản phẩm");
                model.addAttribute("page", "sanpham/index");
                return "client/main";
            }

            String correctSlug = SlugUtils.toSlug(sanPham.getTenSanPham());
            if (!slug.equals(correctSlug)) {
                return "redirect:/sanpham/" + sanPham.getId() + "/" + correctSlug;
            }

            var mauSacs = sanPhamClientService.getMauSacBySanPhamId(id);
            var sizes = sanPhamClientService.getSizesBySanPhamId(id);
            var combos = sanPhamClientService.getVariantCombos(id);

            model.addAttribute("sanPham", sanPham);
            model.addAttribute("mauSacs", mauSacs);
            model.addAttribute("sizes", sizes);
            model.addAttribute("combos", combos);
            model.addAttribute("page", "sanpham/detail");
            return "client/main";
        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            model.addAttribute("page", "sanpham/index");
            return "client/main";
        }
    }

    @GetMapping("/timkiem")
    public String timKiemSanPham(@RequestParam(value = "query", required = false) String query,
                                 Model model) {
        String q = (query == null) ? null : query.trim();
        if (q != null && q.isEmpty()) q = null;

        List<IProductItemClient> listSp = sanPhamClientService.getSanPhamMoiNhat(q, "HOAT_DONG");

        model.addAttribute("listSp", listSp);
        model.addAttribute("query", query); // để fill lại vào ô input nếu muốn
        model.addAttribute("page", "sanpham/index"); // hoặc "sanpham/timkiem" nếu bạn có file riêng
        return "client/main";
    }

    @GetMapping("/api/variants/{id}")
    @org.springframework.web.bind.annotation.ResponseBody
    public java.util.List<com.example.banaomz.entity.client.IVariantItem> variants(@PathVariable Long id) {
        return sanPhamClientService.getVariantItems(id);
    }
}
