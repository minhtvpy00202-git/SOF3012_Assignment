package com.poly.oe.controller.admin;

import com.poly.oe.dao.UserDao;
import com.poly.oe.dao.impl.UserDaoImpl;
import com.poly.oe.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.val;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String id = req.getParameter("id");

        // Trạng thái form:
        // - Nếu click Edit -> load user lên form, editing = true
        // - Ngược lại -> trạng thái khởi đầu: form trống, editing = false
        if ("edit".equals(action) && id != null && !id.isBlank()) {
            prepareEditForm(req, id);
        } else {
            prepareInitialForm(req);
        }

        // Luôn load danh sách người dùng (10 / trang)
        loadUserList(req);

        req.setAttribute("view", "/views/admin/users.jsp");
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {
                // ===== TẠO MỚI USER =====
                User u = new User();
                u.setId(req.getParameter("id"));
                u.setPassword(req.getParameter("password"));
                u.setFullname(req.getParameter("fullname"));
                u.setEmail(req.getParameter("email"));
                u.setAdmin(req.getParameter("admin") != null);

                if (u.getId() == null || u.getId().isBlank()) {
                    throw new RuntimeException("Username không được để trống");
                }
                if (userDao.findById(u.getId()) != null) {
                    throw new RuntimeException("Username đã tồn tại");
                }

                userDao.create(u);
                req.setAttribute("message", "Đã tạo người dùng mới");

                // giống phần video: sau khi tạo -> về trạng thái khởi đầu (form trống)
                prepareInitialForm(req);

            } else if ("update".equals(action)) {
                // ===== CẬP NHẬT USER =====
                String id = req.getParameter("id");
                if (id == null || id.isBlank()) {
                    throw new RuntimeException("Chưa chọn người dùng để cập nhật");
                }

                User u = userDao.findById(id);
                if (u == null) {
                    throw new RuntimeException("Không tìm thấy người dùng: " + id);
                }

                u.setPassword(req.getParameter("password"));
                u.setFullname(req.getParameter("fullname"));
                u.setEmail(req.getParameter("email"));
                u.setAdmin(req.getParameter("admin") != null);

                userDao.update(u);
                req.setAttribute("message", "Đã cập nhật người dùng");

                // vẫn ở trạng thái edit user này
                prepareEditForm(req, id);

            } else if ("delete".equals(action)) {
                // ===== XÓA USER =====
                String id = req.getParameter("id");
                if (id == null || id.isBlank()) {
                    throw new RuntimeException("Chưa chọn người dùng để xóa");
                }

                userDao.remove(id);
                req.setAttribute("message", "Đã xóa người dùng: " + id);

                // quay về trạng thái khởi đầu
                prepareInitialForm(req);

            } else if ("reset".equals(action)) {
                // ===== RESET FORM =====
                prepareInitialForm(req);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());

            // Giữ lại dữ liệu form khi lỗi (ở mode create)
            User form = new User();
            form.setId(req.getParameter("id"));
            form.setPassword(req.getParameter("password"));
            form.setFullname(req.getParameter("fullname"));
            form.setEmail(req.getParameter("email"));
            form.setAdmin(req.getParameter("admin") != null);

            // Nếu đang edit mà lỗi trong update/delete thì để editing=true;
            boolean editing = "update".equals(action) || "delete".equals(action);
            req.setAttribute("form", form);
            req.setAttribute("editing", editing);
        }

        // Luôn reload lại danh sách người dùng
        loadUserList(req);
        req.setAttribute("view", "/views/admin/users.jsp");
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }

    // ================= HÀM PHỤ =================

    /** Trạng thái khởi đầu: form trống, Update/Delete disabled */
    private void prepareInitialForm(HttpServletRequest req) {
        User form = new User(); // các field null
        req.setAttribute("form", form);
        req.setAttribute("editing", false);
    }

    /** Chuẩn bị form ở chế độ edit 1 user */
    private void prepareEditForm(HttpServletRequest req, String id) {
        User u = userDao.findById(id);
        req.setAttribute("form", u);
        req.setAttribute("editing", true);
    }

    /** Load danh sách người dùng, 10 user / trang */
    private void loadUserList(HttpServletRequest req) {
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = 10;

        // Giả sử UserDao đã có 2 hàm này.
        // Nếu chưa có, bạn thêm vào: findPage(int page, int size) và countAll().
        List<User> list = userDao.findPage(page, pageSize);
        long total = userDao.countAll();
        long totalPage = (long) Math.ceil(total * 1.0 / pageSize);

        req.setAttribute("users", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);
        req.setAttribute("totalUsers", total);
    }

    private int parseInt(String val, int defaultVal) {
        try {
            return (val == null || val.isBlank()) ? defaultVal : Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
