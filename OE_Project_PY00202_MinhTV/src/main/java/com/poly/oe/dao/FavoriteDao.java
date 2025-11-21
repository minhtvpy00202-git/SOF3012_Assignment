package com.poly.oe.dao;

import com.poly.oe.entity.Favorite;

import java.util.List;

public interface FavoriteDao {

    Favorite findById(Integer id);

    List<Favorite> findByUser(String userId);

    Favorite findByUserAndVideo(String userId, String videoId);

    Favorite create(Favorite e);

    void remove(Integer id);

    void removeByUserAndVideo(String userId, String videoId);
}
