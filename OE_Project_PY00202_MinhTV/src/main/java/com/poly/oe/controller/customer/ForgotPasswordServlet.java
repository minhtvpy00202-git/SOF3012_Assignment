package com.poly.oe.controller.customer;

import java.io.IOException;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.entity.User;
import com.poly.oe.utils.MailUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/account/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("hideSearch", true);
        req.setAttribute("view", "/views/account/forgot-password.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String email    = req.getParameter("email");

        String message;
        try {
            User u = userDao.findById(username);
            if (u == null) {
                message = "Tài khoản không tồn tại!";
            } else if (u.getEmail() == null || !u.getEmail().equalsIgnoreCase(email)) {
                message = "Email không khớp với tài khoản!";
            } else {
                String subject = "Khôi phục mật khẩu - OE Project";
                String content = "<h3>Xin chào " + u.getFullname() + ",</h3>"
                               + "<p>Bạn vừa yêu cầu lấy lại mật khẩu tại hệ thống OE Project.</p>"
                               + "<p>Mật khẩu của bạn là: <b style='color:red; font-size:1.2em'>" + u.getPassword() + "</b></p>"
                               + "<p>Vui lòng đăng nhập và đổi mật khẩu để bảo mật tài khoản.</p>"
                               + "<p>Trân trọng,<br>Admin Team</p>";
                
                MailUtils.sendHtmlMail(email, subject, content);
                message = "Mật khẩu đã được gửi đến email: " + email;
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi: " + e.getMessage();
        }

        req.setAttribute("message", message);
        req.setAttribute("hideSearch", true);
        req.setAttribute("view", "/views/account/forgot-password.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
