package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.Date;

import com.poly.oe.dao.CommentDao;
import com.poly.oe.dao.CommentLikeDao;
import com.poly.oe.dao.NotificationDAO;
import com.poly.oe.dao.impl.CommentDaoImpl;
import com.poly.oe.dao.impl.CommentLikeDaoImpl;
import com.poly.oe.entity.Comment;
import com.poly.oe.entity.CommentLike;
import com.poly.oe.entity.CommentLikeId;
import com.poly.oe.entity.Notification;
import com.poly.oe.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/comment/add", "/comment/reply", "/comment/like"})
public class CommentServlet extends HttpServlet {

    private final CommentDao commentDao = new CommentDaoImpl();
    private final CommentLikeDao commentLikeDao = new CommentLikeDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("currentUser") : null;
        if (current == null) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"unauthorized\"}");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/comment/add".equals(path)) {
            handleAdd(req, resp, current);
        } else if ("/comment/reply".equals(path)) {
            handleReply(req, resp, current);
        } else if ("/comment/like".equals(path)) {
            handleLike(req, resp, current);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, User current) throws IOException {
        String videoId = req.getParameter("videoId");
        String content = req.getParameter("content");
        if (videoId == null || videoId.isBlank() || content == null || content.isBlank()) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"invalid_input\"}");
            } else {
                redirectBack(req, resp, videoId);
            }
            return;
        }
        Comment c = new Comment();
        c.setVideoId(videoId);
        c.setUser(current);
        c.setContent(content.trim());
        c.setCreateDate(new Date());
        c.setIsDeleted(false);
        c.setLikeCount(0);
        c.setUpdateDate(null);
        c.setParent(null);
        c = commentDao.create(c);
        if (isAjax(req)) {
            String name = current.getFullname() != null && !current.getFullname().isBlank()
                    ? current.getFullname() : current.getId();
            resp.setContentType("application/json");
            StringBuilder sb = new StringBuilder();
            sb.append("{")
              .append("\"id\":").append(c.getId()).append(",")
              .append("\"videoId\":\"").append(c.getVideoId()).append("\",")
              .append("\"content\":\"").append(escape(c.getContent())).append("\",")
              .append("\"userName\":\"").append(escape(name)).append("\",")
              .append("\"likeCount\":").append(c.getLikeCount() == null ? 0 : c.getLikeCount())
              .append("}");
            resp.getWriter().write(sb.toString());
        } else {
            redirectBack(req, resp, videoId);
        }
    }

    private void handleReply(HttpServletRequest req, HttpServletResponse resp, User current) throws IOException {
        String parentIdStr = req.getParameter("parentId");
        String content = req.getParameter("content");
        Long parentId = null;
        try { parentId = Long.valueOf(parentIdStr); } catch (Exception ignored) {}
        if (parentId == null || content == null || content.isBlank()) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"invalid_input\"}");
            } else {
                redirectBack(req, resp, req.getParameter("videoId"));
            }
            return;
        }
        Comment parent = commentDao.findById(parentId);
        if (parent == null) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"not_found\"}");
            } else {
                redirectBack(req, resp, req.getParameter("videoId"));
            }
            return;
        }
        Comment c = new Comment();
        c.setVideoId(parent.getVideoId());
        c.setUser(current);
        c.setContent(content.trim());
        c.setCreateDate(new Date());
        c.setIsDeleted(false);
        c.setLikeCount(0);
        c.setUpdateDate(null);
        c.setParent(parent);
        commentDao.create(c);

        try {
            if (parent.getUser() != null && parent.getUser().getId() != null
                    && !parent.getUser().getId().equalsIgnoreCase(current.getId())) {
                Notification noti = Notification.builder()
                        .userId(parent.getUser().getId())
                        .title("Bình luận mới 💬")
                        .content("Có người đã trả lời bình luận của bạn.")
                        .targetUrl(req.getContextPath() + "/video/detail?id=" + parent.getVideoId())
                        .type("REPLY")
                        .build();
                new NotificationDAO().create(noti);
            }
        } catch (Exception ignored) {}

        if (isAjax(req)) {
            String name = current.getFullname() != null && !current.getFullname().isBlank()
                    ? current.getFullname() : current.getId();
            resp.setContentType("application/json");
            StringBuilder sb = new StringBuilder();
            sb.append("{")
              .append("\"parentId\":").append(parent.getId()).append(",")
              .append("\"videoId\":\"").append(parent.getVideoId()).append("\",")
              .append("\"content\":\"").append(escape(c.getContent())).append("\",")
              .append("\"userName\":\"").append(escape(name)).append("\",")
              .append("\"likeCount\":0")
              .append("}");
            resp.getWriter().write(sb.toString());
        } else {
            redirectBack(req, resp, parent.getVideoId());
        }
    }

    private void handleLike(HttpServletRequest req, HttpServletResponse resp, User current) throws IOException {
        String commentIdStr = req.getParameter("commentId");
        Long commentId = null;
        try { commentId = Long.valueOf(commentIdStr); } catch (Exception ignored) {}
        if (commentId == null) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"invalid_input\"}");
            } else {
                redirectBack(req, resp, req.getParameter("videoId"));
            }
            return;
        }
        Comment c = commentDao.findById(commentId);
        if (c == null) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"error\":\"not_found\"}");
            } else {
                redirectBack(req, resp, req.getParameter("videoId"));
            }
            return;
        }
        boolean exists = commentLikeDao.exists(current.getId(), commentId);
        boolean likedNow;
        if (exists) {
            commentLikeDao.delete(new CommentLikeId(current.getId(), commentId));
            likedNow = false;
        } else {
            CommentLike like = new CommentLike(current, c, true);
            commentLikeDao.create(like);
            likedNow = true;
        }

        long cnt = commentLikeDao.countLikes(commentId);
        c.setLikeCount((int) cnt);
        c.setUpdateDate(new Date());
        commentDao.update(c);
        if (isAjax(req)) {
            resp.setContentType("application/json");
            StringBuilder sb = new StringBuilder();
            sb.append("{")
              .append("\"commentId\":").append(commentId).append(",")
              .append("\"liked\":").append(likedNow).append(",")
              .append("\"likeCount\":").append(cnt)
              .append("}");
            resp.getWriter().write(sb.toString());
        } else {
            redirectBack(req, resp, c.getVideoId());
        }
    }

    private void redirectBack(HttpServletRequest req, HttpServletResponse resp, String videoId) throws IOException {
        String referer = req.getHeader("referer");
        if (referer == null || referer.isBlank()) {
            referer = req.getContextPath() + "/video/detail?id=" + (videoId != null ? videoId : "");
        }
        resp.sendRedirect(referer);
    }

    private boolean isAjax(HttpServletRequest req) {
        String acc = req.getHeader("Accept");
        String xr = req.getHeader("X-Requested-With");
        return (acc != null && acc.contains("application/json")) || (xr != null && !xr.isBlank());
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
