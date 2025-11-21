package com.poly.oe.dao.impl;

import com.poly.oe.dao.FavoriteDao;
import com.poly.oe.entity.Favorite;
import com.poly.oe.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;

import java.util.List;

public class FavoriteDaoImpl implements FavoriteDao {

    @Override
    public Favorite findById(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(Favorite.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Favorite> findByUser(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT f FROM Favorite f WHERE f.user.id = :uid";
            return em.createQuery(jpql, Favorite.class)
                    .setParameter("uid", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Favorite findByUserAndVideo(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT f FROM Favorite f " +
                    "WHERE f.user.id = :uid AND f.video.id = :vid";
            try {
                return em.createQuery(jpql, Favorite.class)
                        .setParameter("uid", userId)
                        .setParameter("vid", videoId)
                        .getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        } finally {
            em.close();
        }
    }

    @Override
    public Favorite create(Favorite e) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(e);
            em.getTransaction().commit();
            return e;
        } catch (Exception ex) {
            em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    public void remove(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Favorite e = em.find(Favorite.class, id);
            if (e != null) em.remove(e);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void removeByUserAndVideo(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();

            String jpql = "SELECT f FROM Favorite f " +
                    "WHERE f.user.id = :uid AND f.video.id = :vid";
            Favorite f = null;
            try {
                f = em.createQuery(jpql, Favorite.class)
                        .setParameter("uid", userId)
                        .setParameter("vid", videoId)
                        .getSingleResult();
            } catch (NoResultException ignored) {
            }

            if (f != null) {
                em.remove(f);
            }

            em.getTransaction().commit();
        } catch (Exception ex) {
            em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }
}
