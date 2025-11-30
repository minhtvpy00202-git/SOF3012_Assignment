package com.poly.oe.dao;

import com.poly.oe.entity.CommentLike;
import com.poly.oe.entity.CommentLikeId;

public interface CommentLikeDao {
    CommentLike create(CommentLike like);
    void delete(CommentLikeId id);
    boolean exists(String userId, Long commentId);
    long countLikes(Long commentId);
}
