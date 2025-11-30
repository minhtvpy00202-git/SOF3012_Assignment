package com.poly.oe.dao;

import com.poly.oe.entity.Comment;
import java.util.List;

public interface CommentDao {
    Comment create(Comment c);
    Comment update(Comment c);
    void delete(Long id);
    Comment findById(Long id);
    List<Comment> findRootComments(String videoId, int offset, int limit);
    List<Comment> findReplies(Long parentId);
    long countByVideoId(String videoId);
}
