package com.poly.oe.controller.customer;

import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = req.getParameter("q");
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try { page = Integer.parseInt(pageParam);} catch (Exception ignored) {}
        }
        int pageSize = 9;

        List<Video> results = videoDao.search(q, page, pageSize);
        long total = videoDao.countSearch(q);
        long totalPage = (long) Math.ceil(total * 1.0 / pageSize);

        req.setAttribute("q", q);
        req.setAttribute("videos", results);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);
        req.setAttribute("view", "/views/customer/search.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
