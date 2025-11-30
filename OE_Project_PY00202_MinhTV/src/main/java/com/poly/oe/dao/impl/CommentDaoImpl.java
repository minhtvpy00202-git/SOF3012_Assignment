package com.poly.oe.dao.impl;

import java.util.List;

import com.poly.oe.dao.CommentDao;
import com.poly.oe.entity.Comment;
import com.poly.oe.utils.JpaUtils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class CommentDaoImpl implements CommentDao {

    @Override
    public Comment create(Comment c) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(c);
            em.getTransaction().commit();
            return c;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public Comment update(Comment c) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Comment merged = em.merge(c);
            em.getTransaction().commit();
            return merged;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Long id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Comment c = em.find(Comment.class, id);
            if (c != null) {
                em.remove(c);
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
    public Comment findById(Long id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(Comment.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Comment> findRootComments(String videoId, int offset, int limit) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Comment> q = em.createQuery(
                    "SELECT c FROM Comment c LEFT JOIN FETCH c.user WHERE c.videoId = :id AND c.parent IS NULL AND c.isDeleted = FALSE ORDER BY c.createDate DESC",
                    Comment.class
            );
            q.setParameter("id", videoId);
            if (offset >= 0) q.setFirstResult(offset);
            if (limit > 0) q.setMaxResults(limit);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Comment> findReplies(Long parentId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Comment> q = em.createQuery(
                    "SELECT c FROM Comment c LEFT JOIN FETCH c.user WHERE c.parent.id = :pid AND c.isDeleted = FALSE ORDER BY c.createDate ASC",
                    Comment.class
            );
            q.setParameter("pid", parentId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countByVideoId(String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(c.id) FROM Comment c WHERE c.videoId = :id AND c.isDeleted = FALSE",
                    Long.class
            );
            q.setParameter("id", videoId);
            return q.getSingleResult();
        } finally {
            em.close();
        }
    }
}
