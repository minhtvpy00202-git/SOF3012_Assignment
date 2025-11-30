package com.poly.oe.controller.customer;

import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.dao.impl.FavoriteDaoImpl;
import com.poly.oe.entity.Favorite;
import com.poly.oe.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/my-favorites")
public class MyFavoritesServlet extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Favorite> favorites = favoriteDao.findByUser(user.getId());
        req.setAttribute("favorites", favorites);

        req.setAttribute("view", "/views/customer/my-favorites.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }
}
