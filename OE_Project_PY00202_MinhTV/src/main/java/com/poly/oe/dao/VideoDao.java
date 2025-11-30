package com.poly.oe.dao;

import java.util.List;

import com.poly.oe.entity.Video;

public interface VideoDao {

    // Lấy tất cả video
    List<Video> findAll();

    // Lấy danh sách video có phân trang
    List<Video> findPage(int page, int pageSize);

    // Đếm tổng số video đang active
    long countActive();

    // Tìm video theo id
    Video findById(String id);

    // Tạo video mới
    Video create(Video entity);

    // Cập nhật video
    Video update(Video entity);

    // Xóa video
    void remove(String id);

    // Danh sách video đã xóa (soft-delete), có phân trang
    List<Video> findDeletedPage(int page, int pageSize);

    // Đếm tổng số video đã xóa
    long countDeleted();

    // Khôi phục nhiều video theo danh sách id
    void restoreMany(java.util.List<String> ids);

    // Tìm kiếm video theo từ khóa (title/description), có phân trang
    List<Video> search(String keyword, int page, int pageSize);

    // Đếm tổng số kết quả tìm kiếm
    long countSearch(String keyword);
}
