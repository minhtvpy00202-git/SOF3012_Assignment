package com.poly.oe.controller.customer;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/account/edit-profile")
public class EditProfileServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("view", "/views/account/edit-profile.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User current = (User) session.getAttribute("currentUser");

        String fullname = req.getParameter("fullname");
        String email    = req.getParameter("email");

        String message;
        try {
            if (current == null) {
                message = "Bạn chưa đăng nhập.";
            } else {
                current.setFullname(fullname);
                current.setEmail(email);
                userDao.update(current);
                session.setAttribute("currentUser", current);
                message = "Cập nhật tài khoản thành công.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi: " + e.getMessage();
        }

        req.setAttribute("message", message);
        req.setAttribute("view", "/views/account/edit-profile.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
