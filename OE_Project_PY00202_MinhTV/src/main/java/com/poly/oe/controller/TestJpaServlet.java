package com.poly.oe.controller;

import com.poly.oe.entity.Video;
import com.poly.oe.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/test-jpa")
public class TestJpaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v";
            List<Video> list = em.createQuery(jpql, Video.class).getResultList();

            resp.setContentType("text/plain; charset=UTF-8");
            for (Video v : list) {
                resp.getWriter().println(v.getId() + " - " + v.getTitle());
            }
        } finally {
            em.close();
        }
    }
}

