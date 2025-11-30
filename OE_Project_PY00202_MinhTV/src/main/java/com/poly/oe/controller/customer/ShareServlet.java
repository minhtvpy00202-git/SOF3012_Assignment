package com.poly.oe.controller.customer;

import com.poly.oe.dao.ShareDao;
import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.ShareDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Share;
import com.poly.oe.entity.User;
import com.poly.oe.entity.Video;
import com.poly.oe.utils.MailUtils;

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

                String[] arr = emails.split("[,;]");
                int successCount = 0;

                String base = req.getScheme() + "://" + req.getServerName()
                        + (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort())
                        + req.getContextPath();

                for (String e : arr) {
                    String mail = e.trim();
                    if (mail.isEmpty()) continue;

                    try {
                        String link = base + "/video/detail?id=" + v.getId();
                        String subject = "OE - Trích đoạn: " + v.getTitle();
                        String html =
                                "<p>Xin chào,</p>" +
                                        "<p>" + current.getFullname() + " vừa chia sẻ một tiểu phẩm tới bạn.</p>" +
                                        "<p>Tiêu đề: <strong>" + v.getTitle() + "</strong></p>" +
                                        "<p>Xem tại: <a href='" + link + "'>" + link + "</a></p>" +
                                        "<p>Trân trọng,<br>OE Online Entertainment</p>";

                        MailUtils.sendHtmlMail(mail, subject, html);

                        Share s = new Share();
                        s.setUser(current);
                        s.setVideo(v);
                        s.setEmail(mail);
                        s.setShareDate(new Date());
                        shareDao.create(s);

                        successCount++;

                    } catch (Exception mailEx) {
                        System.err.println("Lỗi gửi email tới: " + mail);
                        mailEx.printStackTrace();
                    }
                }

                message = "Đã gửi link thành công cho " + successCount + " email.";
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
