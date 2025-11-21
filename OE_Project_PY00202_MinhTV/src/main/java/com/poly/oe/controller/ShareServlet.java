package com.poly.oe.controller;

import com.poly.oe.dao.ShareDao;
import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.ShareDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Share;
import com.poly.oe.entity.User;
import com.poly.oe.entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;

@WebServlet("/video/share")
public class ShareServlet extends HttpServlet {

    private final ShareDao shareDao = new ShareDaoImpl();
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String videoId = req.getParameter("videoId");
        if (videoId == null || videoId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Video v = videoDao.findById(videoId);
        if (v == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        req.setAttribute("video", v);
        req.setAttribute("view", "/views/customer/share.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String videoId = req.getParameter("videoId");
        String emails = req.getParameter("emails");

        Video v = videoDao.findById(videoId);
        if (v == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String message;
        try {
            if (emails == null || emails.isBlank()) {
                message = "Vui lòng nhập ít nhất một email.";
            } else {
                // Tách email theo , hoặc ;
                String[] arr = emails.split("[,;]");
                int count = 0;
                for (String e : arr) {
                    String mail = e.trim();
                    if (!mail.isEmpty()) {
                        Share s = new Share();
                        s.setUser(current);
                        s.setVideo(v);
                        s.setEmail(mail);
                        s.setShareDate(new Date());
                        shareDao.create(s);
                        count++;

                        // TODO: gửi mail thật bằng JavaMail nếu cấu hình
                    }
                }
                message = "Đã gửi link cho " + count + " email (demo).";
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            message = "Lỗi: " + ex.getMessage();
        }

        req.setAttribute("video", v);
        req.setAttribute("message", message);
        req.setAttribute("view", "/views/customer/share.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
