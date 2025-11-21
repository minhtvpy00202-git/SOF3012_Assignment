package com.poly.oe.dao;

import com.poly.oe.entity.Video;
import java.util.List;

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
}
