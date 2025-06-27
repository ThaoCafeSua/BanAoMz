package com.example.banaomz.interceptor;

import com.example.banaomz.entity.admin.NhanVien;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;


@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return false;
        }

        NhanVien currentUser = (NhanVien) session.getAttribute("currentUser");
        String role = currentUser.getChucVu() != null ? currentUser.getChucVu().getTenChucVu().trim().toLowerCase() : "";
        String uri = request.getRequestURI();

        // In ra debug
        System.out.println("Role: " + role);
        System.out.println("URI: " + uri);

        // Nếu là Nhân viên và cố truy cập trang không được phép
        if ("nhân viên".equals(role)) {
            if (
                            uri.startsWith("/admin/employee/create") ||
                            uri.startsWith("/admin/employee/update") ||
                            uri.startsWith("/admin/customer/create") ||
                            uri.startsWith("/admin/customer/update") ||
                            uri.startsWith("/admin/product/add") ||
                            uri.startsWith("/admin/product/update") ||
                            uri.startsWith("/admin/size/create") ||
                            uri.startsWith("/admin/size/update") ||
                            uri.startsWith("/admin/color/create") ||
                            uri.startsWith("/admin/color/update") ||
                            uri.startsWith("/admin/origin/create") ||
                            uri.startsWith("/admin/origin/update") ||
                            uri.startsWith("/admin/brand/create") ||
                            uri.startsWith("/admin/brand/update") ||
                            uri.startsWith("/admin/category/create") ||
                            uri.startsWith("/admin/category/update"))
            {
                session.setAttribute("accessDenied", "Bạn không có quyền truy cập vào chức năng này.");
                String referer = request.getHeader("Referer");
                response.sendRedirect(referer != null ? referer : request.getContextPath() + "/admin");
                //response.sendRedirect(request.getContextPath() + "/admin");
                return false;
            }
        }

        return true;
    }
}
