package com.poly.oe.controller.customer;

import java.io.IOException;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("hideSearch", true);
        req.setAttribute("view", "/views/account/login.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        User user = userDao.findByIdAndPassword(username, password);

        if (user == null) {
            req.setAttribute("message", "Sai tên đăng nhập hoặc mật khẩu");
            req.setAttribute("hideSearch", true);
            req.setAttribute("view", "/views/account/login.jsp");
            req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("message", "Tài khoản chưa được duyệt, vui lòng chờ đến khi tài khoản được duyệt");
            req.setAttribute("hideSearch", true);
            req.setAttribute("view", "/views/account/login.jsp");
            req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("currentUser", user);

        int maxAge = (remember != null) ? 60 * 60 * 24 * 30 : 0;
        Cookie userCookie = new Cookie("username", username);
        Cookie passCookie = new Cookie("password", password);
        userCookie.setMaxAge(maxAge);
        passCookie.setMaxAge(maxAge);
        userCookie.setPath(req.getContextPath());
        passCookie.setPath(req.getContextPath());
        resp.addCookie(userCookie);
        resp.addCookie(passCookie);

        String redirectUrl = (String) session.getAttribute("redirectUrl");
        if (redirectUrl != null) {
            session.removeAttribute("redirectUrl");
            resp.sendRedirect(redirectUrl);
            return;
        }

        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/home");
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
