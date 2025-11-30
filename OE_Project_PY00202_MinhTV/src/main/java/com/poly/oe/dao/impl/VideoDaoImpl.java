package com.poly.oe.dao.impl;

import java.util.List;

import com.poly.oe.dao.VideoDao;
import com.poly.oe.entity.Video;
import com.poly.oe.utils.JpaUtils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class VideoDaoImpl implements VideoDao {

    @Override
    public Video findById(String id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(Video.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v";
            return em.createQuery(jpql, Video.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findPage(int page, int pageSize) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.active = TRUE AND v.isDelete = FALSE ORDER BY v.views DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countActive() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT COUNT(v) FROM Video v WHERE v.active = TRUE AND v.isDelete = FALSE";
            return em.createQuery(jpql, Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public Video create(Video entity) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
            return entity;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public Video update(Video entity) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Video merged = em.merge(entity);
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
    public void remove(String id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Video entity = em.find(Video.class, id);
            if (entity != null) {
                entity.setDelete(true);
                em.merge(entity);
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
    public List<Video> search(String keyword, int page, int pageSize) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 10;

            String kw = keyword == null ? "" : keyword.trim();
            String jpql = "SELECT v FROM Video v WHERE v.active = TRUE AND v.isDelete = FALSE AND (LOWER(v.title) LIKE LOWER(CONCAT('%', :kw, '%')) OR LOWER(v.description) LIKE LOWER(CONCAT('%', :kw, '%'))) ORDER BY v.views DESC";
            TypedQuery<Video> q = em.createQuery(jpql, Video.class);
            q.setParameter("kw", kw);
            q.setFirstResult((page - 1) * pageSize);
            q.setMaxResults(pageSize);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countSearch(String keyword) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String kw = keyword == null ? "" : keyword.trim();
            String jpql = "SELECT COUNT(v) FROM Video v WHERE v.active = TRUE AND v.isDelete = FALSE AND (LOWER(v.title) LIKE LOWER(CONCAT('%', :kw, '%')) OR LOWER(v.description) LIKE LOWER(CONCAT('%', :kw, '%')))";
            return em.createQuery(jpql, Long.class)
                    .setParameter("kw", kw)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public java.util.List<Video> findDeletedPage(int page, int pageSize) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.isDelete = TRUE ORDER BY v.views DESC";
            TypedQuery<Video> query = em.createQuery(jpql, Video.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countDeleted() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT COUNT(v) FROM Video v WHERE v.isDelete = TRUE";
            return em.createQuery(jpql, Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public void restoreMany(java.util.List<String> ids) {
        if (ids == null || ids.isEmpty()) return;
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            for (String id : ids) {
                Video v = em.find(Video.class, id);
                if (v != null) {
                    v.setDelete(false);
                    em.merge(v);
                }
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
