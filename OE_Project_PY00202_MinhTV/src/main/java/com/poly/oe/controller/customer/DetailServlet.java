package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.poly.oe.dao.CommentDao;
import com.poly.oe.dao.CommentLikeDao;
import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.CommentDaoImpl;
import com.poly.oe.dao.impl.CommentLikeDaoImpl;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Comment;
import com.poly.oe.entity.User;
import com.poly.oe.entity.Video;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/video/detail")
public class DetailServlet extends HttpServlet {

    private final VideoDao videoDao = new VideoDaoImpl();
    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();
    private final CommentDao commentDao = new CommentDaoImpl();
    private final CommentLikeDao commentLikeDao = new CommentLikeDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");
        if (id == null || id.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Video video = videoDao.findById(id);
        if (video == null || video.isDelete()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Video không tồn tại");
            return;
        }

        video.setViews(video.getViews() + 1);
        videoDao.update(video);

        saveViewedVideoToCookie(id, req, resp);

        List<Video> recentVideos = getRecentVideosFromCookie(req);

        req.setAttribute("video", video);
        req.setAttribute("recentVideos", recentVideos);
        req.setAttribute("recentVideosSidebar", recentVideos);

        // Bình luận
        List<Comment> comments = commentDao.findRootComments(video.getId(), 0, 50);
        for (Comment c : comments) {
            List<Comment> replies = commentDao.findReplies(c.getId());
            c.setReplies(replies);
        }
        req.setAttribute("comments", comments);

        // Like count và trạng thái liked của current user
        java.util.Map<Long, Long> likeCounts = new java.util.HashMap<>();
        java.util.Map<Long, Boolean> likedByMe = new java.util.HashMap<>();
        for (Comment c : comments) {
            long cnt = commentLikeDao.countLikes(c.getId());
            likeCounts.put(c.getId(), cnt);
            if (c.getReplies() != null) {
                for (Comment r : c.getReplies()) {
                    likeCounts.put(r.getId(), commentLikeDao.countLikes(r.getId()));
                }
            }
        }
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("currentUser") : null;
        if (current != null) {
            for (Comment c : comments) {
                likedByMe.put(c.getId(), commentLikeDao.exists(current.getId(), c.getId()));
                if (c.getReplies() != null) {
                    for (Comment r : c.getReplies()) {
                        likedByMe.put(r.getId(), commentLikeDao.exists(current.getId(), r.getId()));
                    }
                }
            }
        }
        req.setAttribute("commentLikeCounts", likeCounts);
        req.setAttribute("commentLikedByMe", likedByMe);

        boolean videoLikedByMe = false;
        if (current != null) {
            videoLikedByMe = favoriteDao.findByUserAndVideo(current.getId(), video.getId()) != null;
        }
        req.setAttribute("videoLikedByMe", videoLikedByMe);
        req.setAttribute("view", "/views/customer/detail.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    private void saveViewedVideoToCookie(String id, HttpServletRequest req, HttpServletResponse resp) {
        String name = "viewed";
        String value = id;

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie ck : cookies) {
                if (name.equals(ck.getName())) {
                    value = ck.getValue();
                    if (!value.contains(id)) {
                        value = id + "#" + value;
                    }
                }
            }
        }

        String[] parts = value.split("#");
        StringBuilder sb = new StringBuilder();
        int count = 0;
        for (String p : parts) {
            if (!p.isBlank()) {
                if (count++ >= 5) break;
                if (sb.length() > 0) sb.append("#");
                sb.append(p);
            }
        }

        Cookie cookie = new Cookie(name, sb.toString());
        cookie.setMaxAge(60 * 60 * 24 * 7);
        cookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
        resp.addCookie(cookie);
    }

    private List<Video> getRecentVideosFromCookie(HttpServletRequest req) {
        List<Video> list = new ArrayList<>();
        Cookie[] cookies = req.getCookies();
        if (cookies == null) return list;

        String name = "viewed";
        for (Cookie ck : cookies) {
            if (name.equals(ck.getName())) {
                String[] ids = ck.getValue().split("#");
                for (String id : ids) {
                    if (!id.isBlank()) {
                        Video v = videoDao.findById(id);
                        if (v != null && !v.isDelete()) list.add(v);
                    }
                }
            }
        }
        return list;
    }
}
