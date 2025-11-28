package com.poly.oe.controller.admin;

import com.poly.oe.entity.Favorite;
import com.poly.oe.entity.Share;
import com.poly.oe.entity.Video;
import com.poly.oe.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        EntityManager em = JpaUtils.getEntityManager();
        try {
            // 1) Thống kê số người yêu thích từng tiểu phẩm
            // Trả về: videoTitle, favoriteCount, latestDate, oldestDate
            String jpqlFavReport = "SELECT v.title, COUNT(f), MAX(f.likeDate), MIN(f.likeDate) " +
                    "FROM Favorite f JOIN f.video v " +
                    "GROUP BY v.id, v.title " +
                    "ORDER BY COUNT(f) DESC";
            TypedQuery<Object[]> qFavReport = em.createQuery(jpqlFavReport, Object[].class);
            List<Object[]> favoriteReports = qFavReport.getResultList();
            req.setAttribute("favoriteReports", favoriteReports);

            // 2) Danh sách video để cho select lọc Favorite (có thể lấy tất cả video hoặc chỉ video có favorite)
            // Lấy tất cả video (hoặc thay bằng query DISTINCT từ Favorite nếu muốn)
            String jpqlAllVideos = "SELECT v FROM Video v ORDER BY v.title";
            TypedQuery<Video> qVideos = em.createQuery(jpqlAllVideos, Video.class);
            List<Video> videos = qVideos.getResultList();
            req.setAttribute("videos", videos);

            // 3) Nếu có param videoId => lọc Favorite Users theo video
            String videoIdParam = req.getParameter("videoId");
            if (videoIdParam != null && !videoIdParam.trim().isEmpty()) {
                String jpqlFavUsers = "SELECT f FROM Favorite f JOIN FETCH f.user WHERE f.video.id = :vid ORDER BY f.likeDate DESC";
                TypedQuery<Favorite> qFavUsers = em.createQuery(jpqlFavUsers, Favorite.class);
                qFavUsers.setParameter("vid", videoIdParam);
                List<Favorite> favoriteUsers = qFavUsers.getResultList();
                req.setAttribute("favoriteUsers", favoriteUsers);
            } else {
                // mặc định không có dữ liệu (JSP sẽ hiển thị rỗng)
                req.setAttribute("favoriteUsers", null);
            }

            // 4) Danh sách video để cho select lọc Share (có thể lấy tất cả video)
            // (có thể tái sử dụng videos, nhưng để rõ ràng mình set thêm attribute videosShare)
            req.setAttribute("videosShare", videos);

            // 5) Nếu có param shareVideoId => lấy share reports cho video đó
            String shareVideoIdParam = req.getParameter("shareVideoId");
            if (shareVideoIdParam != null && !shareVideoIdParam.trim().isEmpty()) {
                String jpqlShares = "SELECT s FROM Share s JOIN FETCH s.user WHERE s.video.id = :vid ORDER BY s.shareDate DESC";
                TypedQuery<Share> qShares = em.createQuery(jpqlShares, Share.class);
                qShares.setParameter("vid", shareVideoIdParam);
                List<Share> shareReports = qShares.getResultList();
                req.setAttribute("shareReports", shareReports);
            } else {
                req.setAttribute("shareReports", null);
            }

            // view để hiển thị
            req.setAttribute("view", "/views/admin/reports.jsp");
            req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);

        } finally {
            em.close();
        }
    }
}
