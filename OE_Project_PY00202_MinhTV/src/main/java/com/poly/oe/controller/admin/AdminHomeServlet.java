package com.poly.oe.controller.admin;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/home")
public class AdminHomeServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Thống kê tổng
            long videoCount = videoDao.countActive(); // hoặc findAll().size() nếu muốn tính cả inactive
            long userCount = userDao.findAll().size();

            // Lấy vài video nổi bật (trang 1, 5 bản ghi)
            int page = 1;
            int pageSize = 5;
            List<Video> topVideos = videoDao.findPage(page, pageSize);

            req.setAttribute("videoCount", videoCount);
            req.setAttribute("userCount", userCount);
            req.setAttribute("topVideos", topVideos);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải dữ liệu dashboard: " + e.getMessage());
        }

        // Trang nội dung chính của admin
        req.setAttribute("view", "/views/admin/home.jsp");
        // Forward qua layout admin
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }
}
