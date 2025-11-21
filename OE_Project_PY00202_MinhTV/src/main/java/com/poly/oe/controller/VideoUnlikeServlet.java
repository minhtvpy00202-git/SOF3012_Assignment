package com.poly.oe.controller;

import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.entity.Favorite;
import com.poly.oe.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/video/unlike")
public class VideoUnlikeServlet extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        String videoId = req.getParameter("id");
        if (videoId != null && !videoId.isBlank()) {
            Favorite f = favoriteDao.findByUserAndVideo(user.getId(), videoId);
            if (f != null) {
                favoriteDao.remove(f.getId());
            }
        }

        String referer = req.getHeader("referer");
        if (referer == null) {
            referer = req.getContextPath() + "/my-favorites";
        }
        resp.sendRedirect(referer);
    }
}
