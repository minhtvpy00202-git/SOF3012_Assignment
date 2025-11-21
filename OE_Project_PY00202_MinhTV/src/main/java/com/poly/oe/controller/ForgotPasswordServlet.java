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

@WebServlet("/account/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
            if (u == null || u.getEmail() == null || !u.getEmail().equalsIgnoreCase(email)) {
                message = "Thông tin không chính xác!";
            } else {
                // TODO: gửi email chứa mật khẩu u.getPassword()
                message = "Mật khẩu đã được gửi vào email của bạn (demo).";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi: " + e.getMessage();
        }

        req.setAttribute("message", message);
        req.setAttribute("view", "/views/account/forgot-password.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
