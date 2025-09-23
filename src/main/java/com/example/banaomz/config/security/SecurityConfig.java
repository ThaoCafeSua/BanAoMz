package com.example.banaomz.config.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class SecurityConfig {

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10);
    }

    @SuppressWarnings("SpringJavaInjectionPointsAutowiringInspection")
    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // chỉ bỏ qua CSRF cho GHN (AJAX backend–to–backend)
                .csrf(csrf -> csrf.ignoringRequestMatchers(
                        "/api/ghn/**",
                        "/admin/customer/detail",
                        "/admin/customer/update",
                        "/admin/phieu-giam-gia/update",
                        "/admin/employee/detail",
                        "/admin/employee/update",
                        "/admin/banHang/thanh-toan",
                        "/admin/product/detail",
                        "/admin/product/update",
                        "/admin/size/update",
                        "/admin/color/update",
                        "/admin/origin/update",
                        "/admin/brand/update",
                        "/admin/category/update",// chỉ endpoint này
                        "/admin/customer/address",
                        "auth/forgot-password",
                        "/auth/forgot-password",
                        "khachhang/dangnhap",
                        "/khachhang/update",
                        "/khachhang/forgot-password"

                        ))

                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/css/**","/js/**","/images/**").permitAll()
                        .requestMatchers("/khachhang/**", "/auth/**").permitAll()
                        .requestMatchers("/cart/**").permitAll()
                        .requestMatchers("/api/ghn/**").permitAll()
                        .anyRequest().permitAll()
                )

                .httpBasic(AbstractHttpConfigurer::disable)
                .formLogin(AbstractHttpConfigurer::disable)
                .logout(AbstractHttpConfigurer::disable);

        return http.build();
    }
}