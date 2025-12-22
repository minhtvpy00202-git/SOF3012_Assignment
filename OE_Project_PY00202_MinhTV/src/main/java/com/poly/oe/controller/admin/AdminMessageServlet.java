package com.poly.oe.controller.admin;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.UserMessageDAO;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.entity.User;
import com.poly.oe.entity.UserMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/messages")
public class AdminMessageServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();
    private final UserMessageDAO userMessageDAO = new UserMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = parseInt(req.getParameter("page"), 1);
        int size = 20;
        List<User> users = userDao.findPage(page, size);
        long total = userDao.countAll();
        long totalPage = (long) Math.ceil(total * 1.0 / size);

        req.setAttribute("users", users);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);
        req.setAttribute("view", "/views/admin/user-messages.jsp");
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        boolean sendAll = req.getParameter("sendAll") != null;
        String[] ids = req.getParameterValues("userIds");

        String message;
        try {
            if (title == null || title.isBlank() || content == null || content.isBlank()) {
                throw new RuntimeException("Thiếu tiêu đề hoặc nội dung.");
            }
            int sent = 0;
            if (sendAll) {
                int size = 100;
                long total = userDao.countAll();
                long totalPage = (long) Math.ceil(total * 1.0 / size);
                for (int p = 1; p <= totalPage; p++) {
                    List<User> batch = userDao.findPage(p, size);
                    for (User u : batch) {
                        UserMessage um = UserMessage.builder()
                                .userId(u.getId())
                                .title(title.trim())
                                .content(content.trim())
                                .isRead(false)
                                .createdDate(new Date())
                                .build();
                        userMessageDAO.create(um);
                        sent++;
                    }
                }
            } else {
                if (ids == null || ids.length == 0) {
                    throw new RuntimeException("Chưa chọn người nhận.");
                }
                for (String id : ids) {
                    if (id == null || id.isBlank()) continue;
                    UserMessage um = UserMessage.builder()
                            .userId(id)
                            .title(title.trim())
                            .content(content.trim())
                            .isRead(false)
                            .createdDate(new Date())
                            .build();
                    userMessageDAO.create(um);
                    sent++;
                }
            }
            message = "Đã gửi " + sent + " thông báo.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi: " + e.getMessage();
        }

        req.setAttribute("message", message);
        doGet(req, resp);
    }

    private int parseInt(String val, int def) {
        try { return (val == null || val.isBlank()) ? def : Integer.parseInt(val); }
        catch (Exception e) { return def; }
    }
}
