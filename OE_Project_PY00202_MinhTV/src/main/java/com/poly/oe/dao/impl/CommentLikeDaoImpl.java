package com.poly.oe.dao.impl;

import com.poly.oe.dao.CommentLikeDao;
import com.poly.oe.entity.CommentLike;
import com.poly.oe.entity.CommentLikeId;
import com.poly.oe.utils.JpaUtils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class CommentLikeDaoImpl implements CommentLikeDao {

    @Override
    public CommentLike create(CommentLike like) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            // Attach associations to current persistence context to avoid detached entity errors
            like.setUser(em.getReference(com.poly.oe.entity.User.class, like.getUser().getId()));
            like.setComment(em.getReference(com.poly.oe.entity.Comment.class, like.getComment().getId()));
            like.setId(new CommentLikeId(like.getUser().getId(), like.getComment().getId()));
            em.persist(like);
            em.getTransaction().commit();
            return like;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(CommentLikeId id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            CommentLike like = em.find(CommentLike.class, id);
            if (like != null) {
                em.remove(like);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean exists(String userId, Long commentId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(cl) FROM CommentLike cl WHERE cl.user.id = :uid AND cl.comment.id = :cid",
                    Long.class
            );
            q.setParameter("uid", userId);
            q.setParameter("cid", commentId);
            Long count = q.getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public long countLikes(Long commentId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(cl) FROM CommentLike cl WHERE cl.comment.id = :cid AND cl.isLike = TRUE",
                    Long.class
            );
            q.setParameter("cid", commentId);
            Long count = q.getSingleResult();
            return count != null ? count : 0;
        } finally {
            em.close();
        }
    }
}
