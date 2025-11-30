package com.poly.oe.dao;

import java.util.List;

import com.poly.oe.entity.User;

public interface UserDao {

    User findById(String username);

    List<User> findAll();

    User create(User entity);

    User update(User entity);

    void remove(String username);
    User findByIdAndPassword(String id, String password);

    List<User> findPage(int page, int size);

    long countAll();

    List<User> findInactive();

    // Danh sách người dùng đã xóa (soft-delete)
    java.util.List<User> findDeletedPage(int page, int pageSize);
    long countDeleted();
    void restoreMany(java.util.List<String> ids);


}
