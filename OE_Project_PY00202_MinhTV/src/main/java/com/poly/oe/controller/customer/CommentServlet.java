package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.Date;

import com.poly.oe.dao.CommentDao;
import com.poly.oe.dao.CommentLikeDao;
import com.poly.oe.dao.impl.CommentDaoImpl;
import com.poly.oe.dao.impl.CommentLikeDaoImpl;
import com.poly.oe.entity.Comment;
import com.poly.oe.entity.CommentLike;
import com.poly.oe.entity.CommentLikeId;
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
            redirectBack(req, resp, videoId);
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
        commentDao.create(c);
        redirectBack(req, resp, videoId);
    }

    private void handleReply(HttpServletRequest req, HttpServletResponse resp, User current) throws IOException {
        String parentIdStr = req.getParameter("parentId");
        String content = req.getParameter("content");
        Long parentId = null;
        try { parentId = Long.valueOf(parentIdStr); } catch (Exception ignored) {}
        if (parentId == null || content == null || content.isBlank()) {
            redirectBack(req, resp, req.getParameter("videoId"));
            return;
        }
        Comment parent = commentDao.findById(parentId);
        if (parent == null) {
            redirectBack(req, resp, req.getParameter("videoId"));
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
        redirectBack(req, resp, parent.getVideoId());
    }

    private void handleLike(HttpServletRequest req, HttpServletResponse resp, User current) throws IOException {
        String commentIdStr = req.getParameter("commentId");
        Long commentId = null;
        try { commentId = Long.valueOf(commentIdStr); } catch (Exception ignored) {}
        if (commentId == null) {
            redirectBack(req, resp, req.getParameter("videoId"));
            return;
        }
        Comment c = commentDao.findById(commentId);
        if (c == null) {
            redirectBack(req, resp, req.getParameter("videoId"));
            return;
        }
        boolean exists = commentLikeDao.exists(current.getId(), commentId);
        if (exists) {
            commentLikeDao.delete(new CommentLikeId(current.getId(), commentId));
        } else {
            CommentLike like = new CommentLike(current, c, true);
            commentLikeDao.create(like);
        }

        long cnt = commentLikeDao.countLikes(commentId);
        c.setLikeCount((int) cnt);
        c.setUpdateDate(new Date());
        commentDao.update(c);
        redirectBack(req, resp, c.getVideoId());
    }

    private void redirectBack(HttpServletRequest req, HttpServletResponse resp, String videoId) throws IOException {
        String referer = req.getHeader("referer");
        if (referer == null || referer.isBlank()) {
            referer = req.getContextPath() + "/video/detail?id=" + (videoId != null ? videoId : "");
        }
        resp.sendRedirect(referer);
    }
}
