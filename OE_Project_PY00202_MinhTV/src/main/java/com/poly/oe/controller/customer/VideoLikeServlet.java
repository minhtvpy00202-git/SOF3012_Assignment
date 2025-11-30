package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.Date;

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

@WebServlet("/video/like")
public class VideoLikeServlet extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleLike(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleLike(req, resp);
    }

    private void handleLike(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String videoId = req.getParameter("videoId");
        if (videoId == null || videoId.isBlank()) {
            videoId = req.getParameter("id");
        }
        if (videoId == null || videoId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Video video = videoDao.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Favorite f = favoriteDao.findByUserAndVideo(user.getId(), videoId);
        if (f == null) {
            f = new Favorite();
            f.setUser(user);
            f.setVideo(video);
            f.setLikeDate(new Date());
            favoriteDao.create(f);
        }

        String referer = req.getHeader("referer");
        if (referer == null) {
            referer = req.getContextPath() + "/home";
        }
        resp.sendRedirect(referer);
    }
}
