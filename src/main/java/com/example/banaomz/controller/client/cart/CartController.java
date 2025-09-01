package com.example.banaomz.controller.client.cart;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping()
public class CartController {

    @GetMapping("/cart")
    public String cartIndex(Model model) {
        model.addAttribute("page", "cart/index");
        return "client/main";
    }
}
