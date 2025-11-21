package com.poly.oe.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // TODO: sau này thêm các list/report:
        //  - danh sách video + số người like
        //  - danh sách user like 1 video
        //  - danh sách người share video...

        req.setAttribute("view", "/views/admin/reports.jsp");
        req.getRequestDispatcher("/views/layout/admin.jsp").forward(req, resp);
    }
}
