package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@WebServlet({"/home", "/index"})
public class HomeServlet extends HttpServlet {

    private VideoDao videoDao = new VideoDaoImpl();
    private FavoriteDao favoriteDao = new FavoriteDaoImpl();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = 6;

        List<Video> videos = videoDao.findPage(page, pageSize);
        long totalActive = videoDao.countActive();
        long totalPage = (long) Math.ceil(totalActive * 1.0 / pageSize);

        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user != null) {
            List<Favorite> favs = favoriteDao.findByUser(user.getId());
            Map<String, Boolean> likedMap = new HashMap<>();
            for (Favorite f : favs) {
                if (f.getVideo() != null && f.getVideo().getId() != null) {
                    likedMap.put(f.getVideo().getId(), true);
                }
            }
            req.setAttribute("likedMap", likedMap);
        }

        req.setAttribute("recentVideosSidebar", null);

        req.setAttribute("view", "/views/customer/home.jsp");

        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
