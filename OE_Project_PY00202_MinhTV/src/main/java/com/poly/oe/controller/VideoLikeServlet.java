package com.poly.oe.controller;

import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Favorite;
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

@WebServlet("/video/like")
public class VideoLikeServlet extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        String videoId = req.getParameter("id");
        if (videoId == null || videoId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Video video = videoDao.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Nếu chưa like thì tạo Favorite
        Favorite f = favoriteDao.findByUserAndVideo(user.getId(), videoId);
        if (f == null) {
            f = new Favorite();
            f.setUser(user);
            f.setVideo(video);
            f.setLikeDate(new Date());
            favoriteDao.create(f);
        }

        // Quay lại trang trước (home/detail/..)
        String referer = req.getHeader("referer");
        if (referer == null) {
            referer = req.getContextPath() + "/home";
        }
        resp.sendRedirect(referer);
    }
}
