package com.poly.oe.filter;

import com.poly.oe.entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter({
        "/favorites/*",
        "/my-favorites",
        "/video/like",
        "/video/unlike",
        "/video/share",
        "/share/*",
        "/account/*",
        "/admin/*"       // toàn bộ trang admin
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();

        boolean adminPath = uri.startsWith(contextPath + "/admin");

        if (user == null) {
            // lưu URL để sau login quay lại
            String fullUrl = req.getRequestURL().toString();
            if (req.getQueryString() != null) {
                fullUrl += "?" + req.getQueryString();
            }
            req.getSession(true).setAttribute("redirectUrl", fullUrl);

            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // Đã đăng nhập, nhưng truy cập /admin mà không phải admin
        if (adminPath && !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang quản trị");
            return;
        }

        chain.doFilter(request, response);
    }
}
