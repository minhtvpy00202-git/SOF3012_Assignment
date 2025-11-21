package com.poly.oe.dao;

import com.poly.oe.entity.User;
import java.util.List;

public interface UserDao {

    User findById(String username);

    List<User> findAll();

    User create(User entity);

    User update(User entity);

    void remove(String username);
    User findByIdAndPassword(String id, String password);

    List<User> findPage(int page, int size);

    long countAll();


}
