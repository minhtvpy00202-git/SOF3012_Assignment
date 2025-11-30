package com.poly.oe.controller.admin;

import com.poly.oe.dao.VideoDao;
import com.poly.oe.dao.impl.VideoDaoImpl;
import com.poly.oe.entity.Video;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.commons.beanutils.BeanUtils;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/videos")
@MultipartConfig
public class AdminVideoServlet extends HttpServlet {

    private final VideoDao videoDao = new VideoDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String id = req.getParameter("id");
        String tab = req.getParameter("tab");

        // 1. Chuẩn bị form: chế độ tạo mới hoặc edit
        if ("edit".equals(action) && id != null && !id.isBlank()) {
            // đang EDIT
            prepareEditForm(req, id);
        } else {
            // form tạo mới + tự sinh VIDxxx
            prepareCreateForm(req);
        }

        // 2. Load danh sách video theo tab
        if ("deleted".equals(tab)) {
            loadDeletedVideoList(req);
        } else {
            loadVideoList(req);
        }

        req.setAttribute("view", "/views/admin/videos.jsp");
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("create".equals(action)) {

                // ===== TẠO MỚI =====
                Video v = new Video();
                BeanUtils.populate(v, req.getParameterMap());

                // Đảm bảo đọc đúng View Count từ form
                v.setViews(parseInt(req.getParameter("views"), 0));

                // Upload poster nếu có
                handlePosterUpload(req, v);

                videoDao.create(v);
                req.setAttribute("message", "Đã thêm video");

                // Sau khi tạo xong -> chuyển sang chế độ EDIT của video vừa tạo
                prepareEditForm(req, v.getId());

            } else if ("update".equals(action)) {

                // ===== CẬP NHẬT =====
                String id = req.getParameter("id");
                Video v = videoDao.findById(id);   // lấy bản gốc để giữ poster cũ nếu không chọn file

                if (v == null) {
                    throw new RuntimeException("Không tìm thấy video để cập nhật");
                }

                BeanUtils.populate(v, req.getParameterMap());

                // Đảm bảo cập nhật lại View Count
                v.setViews(parseInt(req.getParameter("views"), v.getViews()));

                // nếu không chọn file -> giữ poster cũ
                handlePosterUpload(req, v);

                videoDao.update(v);
                req.setAttribute("message", "Đã cập nhật video");
                // vẫn ở chế độ edit video này
                prepareEditForm(req, v.getId());

            } else if ("delete".equals(action)) {

                // ===== XÓA =====
                String id = req.getParameter("id");
                videoDao.remove(id);
                req.setAttribute("message", "Đã xóa video");
                // Sau khi xóa -> quay về form tạo mới
                prepareCreateForm(req);

            } else if ("restore".equals(action)) {
                // ===== KHÔI PHỤC VIDEO =====
                String[] ids = req.getParameterValues("ids");
                java.util.List<String> list = new java.util.ArrayList<>();
                if (ids != null) {
                    for (String s : ids) {
                        if (s != null && !s.isBlank()) list.add(s);
                    }
                }
                videoDao.restoreMany(list);
                req.setAttribute("message", "Đã khôi phục " + list.size() + " video");
                // quay về tab deleted
                req.setAttribute("activeTab", "deleted");
                loadDeletedVideoList(req);

            } else if ("reset".equals(action)) {

                // ===== RESET FORM -> tạo mới ID =====
                prepareCreateForm(req);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            // lỗi thì vẫn giữ form hiện tại, không đụng tới editing flag nếu đã set
        }

        // Luôn load lại danh sách theo tab
        String tab = req.getParameter("tab");
        if ("deleted".equals(tab) || "restore".equals(action)) {
            loadDeletedVideoList(req);
        } else {
            loadVideoList(req);
        }
        req.setAttribute("view", "/views/admin/videos.jsp");
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }

    // =================== HÀM PHỤ ===================

    private void loadVideoList(HttpServletRequest req) {
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = 10;

        List<Video> list = videoDao.findPage(page, pageSize);
        long total = videoDao.countActive();
        long totalPage = (long) Math.ceil(total * 1.0 / pageSize);

        req.setAttribute("videos", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPage", totalPage);
    }

    private void loadDeletedVideoList(HttpServletRequest req) {
        int page = parseInt(req.getParameter("page"), 1);
        int pageSize = 10;
        java.util.List<Video> list = videoDao.findDeletedPage(page, pageSize);
        long total = videoDao.countDeleted();
        long totalPage = (long) Math.ceil(total * 1.0 / pageSize);

        req.setAttribute("deletedVideos", list);
        req.setAttribute("deletedCurrentPage", page);
        req.setAttribute("deletedTotalPage", totalPage);
    }

    /** Chuẩn bị form ở chế độ tạo mới: sinh Video ID mới, views = 0, active = true */
    private void prepareCreateForm(HttpServletRequest req) {
        Video form = new Video();
        form.setId(generateNextVideoId());
        form.setViews(0);
        form.setActive(true);

        req.setAttribute("form", form);
        req.setAttribute("editing", false);   // để JSP biết đang ở mode Create (Create bật, Update/Delete tắt)
    }

    /** Chuẩn bị form ở chế độ edit 1 video */
    private void prepareEditForm(HttpServletRequest req, String id) {
        Video video = videoDao.findById(id);
        req.setAttribute("form", video);
        req.setAttribute("editing", true);    // đang ở mode Edit (Create tắt, Update/Delete bật)
    }

    /** Sinh ID mới kiểu VID001, VID002,... dựa trên ID lớn nhất hiện có */
    private String generateNextVideoId() {
        List<Video> all = videoDao.findAll();
        int max = 0;

        for (Video v : all) {
            String vid = v.getId();
            if (vid != null && vid.startsWith("VID")) {
                try {
                    int num = Integer.parseInt(vid.substring(3));
                    if (num > max) max = num;
                } catch (NumberFormatException ignored) {
                }
            }
        }
        int next = max + 1;
        return String.format("VID%03d", next);   // VID001, VID002,...
    }

    /** Xử lý upload poster và gán vào entity */
    private void handlePosterUpload(HttpServletRequest req, Video v)
            throws IOException, ServletException {

        Part part = req.getPart("posterFile");
        if (part == null || part.getSize() == 0) {
            // Không chọn file mới: giữ nguyên poster hiện có
            return;
        }

        // Thư mục /posters nằm trong webapp
        String postersDirPath = req.getServletContext().getRealPath("/posters");
        File postersDir = new File(postersDirPath);
        if (!postersDir.exists()) {
            postersDir.mkdirs();
        }

        // Tên file: [videoId].jpg
        String fileName = v.getId() + ".jpg";
        File destFile = new File(postersDir, fileName);

        part.write(destFile.getAbsolutePath());

        // Lưu đường dẫn tương đối vào DB => "posters/VID001.jpg"
        v.setPoster("posters/" + fileName);
    }

    private int parseInt(String value, int defaultVal) {
        try {
            return (value == null || value.isBlank()) ? defaultVal : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
