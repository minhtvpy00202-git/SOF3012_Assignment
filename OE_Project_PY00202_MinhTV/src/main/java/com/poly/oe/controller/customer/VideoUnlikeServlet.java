package com.poly.oe.controller.customer;

import java.io.IOException;

import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/video/unlike")
public class VideoUnlikeServlet extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleUnlike(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleUnlike(req, resp);
    }

    private void handleUnlike(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
        if (videoId != null && !videoId.isBlank()) {
            favoriteDao.removeByUserAndVideo(user.getId(), videoId);
        }

        String referer = req.getHeader("referer");
        if (referer == null) {
            referer = req.getContextPath() + "/my-favorites";
        }
        resp.sendRedirect(referer);
    }
}
