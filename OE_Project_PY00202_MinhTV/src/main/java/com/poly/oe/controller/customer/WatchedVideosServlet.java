package com.poly.oe.controller.customer;

import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.VideoHistoryDAO;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Favorite;
import com.poly.oe.entity.User;
import com.poly.oe.entity.Video;
import com.poly.oe.entity.VideoHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/watched-videos")
public class WatchedVideosServlet extends HttpServlet {

    private final VideoHistoryDAO historyDao = new VideoHistoryDAO();
    private final VideoDao videoDao = new VideoDaoImpl();
    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();

    private static final int MAX_HISTORY = 20;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 1️⃣ Lấy lịch sử xem
        List<VideoHistory> histories = historyDao.findByUser(user.getId());

        List<Video> videos = new ArrayList<>();
        int count = 0;

        for (VideoHistory h : histories) {
            Video v = videoDao.findById(h.getVideoId());
            if (v != null && !v.isDelete()) {
                videos.add(v);
                if (++count >= MAX_HISTORY) break;
            }
        }

        // 2️⃣ Map video đã like
        List<Favorite> favs = favoriteDao.findByUser(user.getId());
        Map<String, Boolean> likedMap = new HashMap<>();
        for (Favorite f : favs) {
            if (f.getVideo() != null) {
                likedMap.put(f.getVideo().getId(), true);
            }
        }

        req.setAttribute("videos", videos);
        req.setAttribute("likedMap", likedMap);
        req.setAttribute("view", "/views/customer/watched.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}


