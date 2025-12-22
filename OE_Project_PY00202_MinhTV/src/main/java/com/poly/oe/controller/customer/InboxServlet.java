package com.poly.oe.controller.customer;

import java.io.IOException;
import java.util.List;

import com.poly.oe.dao.UserMessageDAO;
import com.poly.oe.entity.User;
import com.poly.oe.entity.UserMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/inbox"})
public class InboxServlet extends HttpServlet {

    private final UserMessageDAO userMessageDAO = new UserMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        var session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("currentUser") : null;
        if (current == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        List<UserMessage> list = userMessageDAO.findByUser(current.getId());
        req.setAttribute("messages", list);
        req.setAttribute("view", "/views/customer/inbox.jsp");
        req.getRequestDispatcher("/views/layout/customer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        var session = req.getSession(false);
        User current = session != null ? (User) session.getAttribute("currentUser") : null;
        if (current == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String action = req.getParameter("action");
        String idStr = req.getParameter("id");
        Integer id = null;
        try { id = Integer.valueOf(idStr); } catch (Exception ignored) {}

        if ("markRead".equals(action) && id != null) {
            userMessageDAO.markAsRead(id);
        } else if ("delete".equals(action) && id != null) {
            userMessageDAO.delete(id);
        }
        resp.sendRedirect(req.getContextPath() + "/inbox");
    }
}
