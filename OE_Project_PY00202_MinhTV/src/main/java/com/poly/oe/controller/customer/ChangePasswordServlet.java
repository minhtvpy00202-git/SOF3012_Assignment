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

@WebServlet("/account/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("view", "/views/account/change-password.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User current = (User) session.getAttribute("currentUser");

        String username = req.getParameter("username");
        String currentPw = req.getParameter("currentPassword");
        String newPw = req.getParameter("newPassword");
        String confirm = req.getParameter("confirm");

        String message;
        try {
            if (current == null || !current.getId().equals(username)) {
                message = "Sai username hoặc chưa đăng nhập.";
            } else if (!current.getPassword().equals(currentPw)) {
                message = "Mật khẩu hiện tại không đúng.";
            } else if (newPw == null || !newPw.equals(confirm)) {
                message = "Xác nhận mật khẩu mới không khớp.";
            } else {
                current.setPassword(newPw);
                userDao.update(current);
                session.setAttribute("currentUser", current);
                message = "Đổi mật khẩu thành công.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi: " + e.getMessage();
        }

        req.setAttribute("message", message);
        req.setAttribute("view", "/views/account/change-password.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
