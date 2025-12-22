package com.poly.oe.controller.customer;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import com.poly.oe.dao.NotificationDAO;
import com.poly.oe.dao.UserMessageDAO;
import com.poly.oe.entity.Notification;
import com.poly.oe.entity.User;
import com.poly.oe.entity.UserMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/notifications-feed", "/notifications-feed/mark-all"})
public class NotificationFeedServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final UserMessageDAO userMessageDAO = new UserMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        var session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("currentUser") : null;
        if (current == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        List<Item> items = new ArrayList<>();
        for (Notification n : notificationDAO.findByUser(current.getId())) {
            Item it = new Item();
            it.kind = "notification";
            it.id = n.getId();
            it.title = n.getTitle();
            it.content = n.getContent();
            it.isRead = Boolean.TRUE.equals(n.getIsRead());
            it.targetUrl = n.getTargetUrl();
            it.createdAt = n.getCreatedAt();
            items.add(it);
        }
        for (UserMessage m : userMessageDAO.findByUser(current.getId())) {
            Item it = new Item();
            it.kind = "message";
            it.id = m.getId();
            it.title = m.getTitle();
            it.content = m.getContent();
            it.isRead = Boolean.TRUE.equals(m.getIsRead());
            it.targetUrl = req.getContextPath() + "/inbox";
            it.createdAt = m.getCreatedDate();
            items.add(it);
        }

        items.sort(Comparator.comparing((Item i) -> i.createdAt == null ? new Date(0) : i.createdAt).reversed());

        long unreadCount = items.stream().filter(i -> !i.isRead).count();

        resp.setContentType("application/json");
        StringBuilder sb = new StringBuilder();
        sb.append("{\"unread\":").append(unreadCount).append(",\"items\":[");
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
        for (int i = 0; i < items.size(); i++) {
            Item it = items.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
                    .append("\"kind\":\"").append(it.kind).append("\",")
                    .append("\"id\":").append(it.id).append(",")
                    .append("\"title\":\"").append(escape(it.title)).append("\",")
                    .append("\"content\":\"").append(escape(it.content)).append("\",")
                    .append("\"isRead\":").append(it.isRead).append(",")
                    .append("\"targetUrl\":\"").append(escape(it.targetUrl)).append("\",")
                    .append("\"createdAt\":\"").append(it.createdAt != null ? fmt.format(it.createdAt) : "").append("\"")
                    .append("}");
        }
        sb.append("]}");
        resp.getWriter().write(sb.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        var session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("currentUser") : null;
        if (current == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        if ("/notifications-feed/mark-all".equals(path)) {
            // mark all notification + messages as read
            try {
                for (Notification n : notificationDAO.findByUser(current.getId())) {
                    if (!Boolean.TRUE.equals(n.getIsRead())) {
                        notificationDAO.markAsRead(n.getId());
                    }
                }
                for (UserMessage m : userMessageDAO.findByUser(current.getId())) {
                    if (!Boolean.TRUE.equals(m.getIsRead())) {
                        userMessageDAO.markAsRead(m.getId());
                    }
                }
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } catch (Exception e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private static class Item {
        String kind;
        Integer id;
        String title;
        String content;
        boolean isRead;
        String targetUrl;
        Date createdAt;
    }
}
