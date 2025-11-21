package com.poly.oe.controller;

import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/video/detail")
public class DetailServlet extends HttpServlet {

    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");
        if (id == null || id.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // 1. Lấy video
        Video video = videoDao.findById(id);
        if (video == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Video không tồn tại");
            return;
        }

        // 2. Tăng view
        video.setViews(video.getViews() + 1);
        videoDao.update(video);

        // 3. Lưu cookie "đã xem"
        saveViewedVideoToCookie(id, req, resp);

        // 4. Lấy danh sách video đã xem gần đây
        List<Video> recentVideos = getRecentVideosFromCookie(req);

        req.setAttribute("video", video);
        req.setAttribute("recentVideos", recentVideos);

        // dùng cùng list cho sidebar tạm thời
        req.setAttribute("recentVideosSidebar", recentVideos);

        // trang nội dung chính
        req.setAttribute("view", "/views/customer/detail.jsp");

        // forward layout
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
                        value = id + "#" + value;   // dùng # thay cho ,
                    }
                }
            }
        }

        // giới hạn tối đa 5 id
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
                String[] ids = ck.getValue().split("#");  // tách theo #
                for (String id : ids) {
                    if (!id.isBlank()) {
                        Video v = videoDao.findById(id);
                        if (v != null) list.add(v);
                    }
                }
            }
        }
        return list;
    }

}
