package com.poly.oe.controller;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/account/registration")
public class RegistrationServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("view", "/views/account/registration.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullname = req.getParameter("fullname");
        String email    = req.getParameter("email");

        try {
            // validate rất cơ bản
            if (username == null || username.isBlank()
                    || password == null || password.isBlank()
                    || email == null || email.isBlank()) {
                req.setAttribute("message", "Vui lòng nhập đầy đủ Username, Password, Email");
            } else if (userDao.findById(username) != null) {
                req.setAttribute("message", "Username đã tồn tại");
            } else {
                User u = new User();
                u.setId(username);
                u.setPassword(password);
                u.setFullname(fullname);
                u.setEmail(email);
                u.setAdmin(false); // đăng ký mới luôn là user thường

                userDao.create(u);

                // TODO: Gửi email chào mừng (khi em cấu hình JavaMail)

                req.setAttribute("message", "Đăng ký thành công. Hãy đăng nhập!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "Lỗi: " + e.getMessage());
        }

        req.setAttribute("view", "/views/account/registration.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
