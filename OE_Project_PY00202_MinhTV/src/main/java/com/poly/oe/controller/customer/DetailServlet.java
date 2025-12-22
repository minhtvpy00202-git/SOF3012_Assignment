package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.poly.oe.dao.*;
import com.poly.oe.dao.impl.CommentDaoImpl;
import com.poly.oe.dao.impl.CommentLikeDaoImpl;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Comment;
import com.poly.oe.entity.User;
import com.poly.oe.entity.Video;

import com.poly.oe.entity.VideoHistory;
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
    private final VideoHistoryDAO historyDao = new VideoHistoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String videoId = req.getParameter("id");
        if (videoId == null || videoId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Video video = videoDao.findById(videoId);
        if (video == null || video.isDelete()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Video không tồn tại");
            return;
        }

        // 1️⃣ Tăng lượt xem
        video.setViews(video.getViews() + 1);
        videoDao.update(video);

        // 2️⃣ Lấy user hiện tại
        User current = getCurrentUser(req);

        // 3️⃣ Ghi lịch sử xem vào DATABASE (THEO USER)
        if (current != null) {
            historyDao.recordView(current.getId(), videoId);
        }

        // 4️⃣ Lấy danh sách video đã xem gần đây (DB)
        List<Video> recentVideos = new ArrayList<>();
        if (current != null) {
            List<VideoHistory> histories = historyDao.findByUser(current.getId());
            for (VideoHistory h : histories) {
                Video v = videoDao.findById(h.getVideoId());
                if (v != null && !v.isDelete()) {
                    recentVideos.add(v);
                }
                if (recentVideos.size() >= 5) break;
            }
        }

        req.setAttribute("video", video);
        req.setAttribute("recentVideos", recentVideos);
        req.setAttribute("recentVideosSidebar", recentVideos);

        // 5️⃣ Bình luận
        List<Comment> comments = commentDao.findRootComments(videoId, 0, 50);
        for (Comment c : comments) {
            c.setReplies(commentDao.findReplies(c.getId()));
        }
        req.setAttribute("comments", comments);

        // 6️⃣ Like comment
        var likeCounts = new java.util.HashMap<Long, Long>();
        var likedByMe = new java.util.HashMap<Long, Boolean>();

        for (Comment c : comments) {
            likeCounts.put(c.getId(), commentLikeDao.countLikes(c.getId()));
            if (current != null) {
                likedByMe.put(c.getId(), commentLikeDao.exists(current.getId(), c.getId()));
            }
            if (c.getReplies() != null) {
                for (Comment r : c.getReplies()) {
                    likeCounts.put(r.getId(), commentLikeDao.countLikes(r.getId()));
                    if (current != null) {
                        likedByMe.put(r.getId(), commentLikeDao.exists(current.getId(), r.getId()));
                    }
                }
            }
        }

        req.setAttribute("commentLikeCounts", likeCounts);
        req.setAttribute("commentLikedByMe", likedByMe);

        // 7️⃣ Like video
        boolean videoLikedByMe = current != null
                && favoriteDao.findByUserAndVideo(current.getId(), videoId) != null;

        req.setAttribute("videoLikedByMe", videoLikedByMe);

        req.setAttribute("view", "/views/customer/detail.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    private User getCurrentUser(HttpServletRequest req) {
        var session = req.getSession(false);
        return session != null ? (User) session.getAttribute("currentUser") : null;
    }
}
