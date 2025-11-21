package com.poly.oe.dao.impl;

import com.poly.oe.dao.UserDao;
import com.poly.oe.entity.User;
import com.poly.oe.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDaoImpl implements UserDao {

    @Override
    public User findById(String username) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(User.class, username);
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u", User.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public User create(User e) {
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
    public User update(User e) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            e = em.merge(e);
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
    public void remove(String username) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            User e = em.find(User.class, username);
            if (e != null) em.remove(e);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public User findByIdAndPassword(String id, String password) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.id = :id AND u.password = :pw";
            TypedQuery<User> q = em.createQuery(jpql, User.class);
            q.setParameter("id", id);
            q.setParameter("pw", password);
            try {
                return q.getSingleResult();
            } catch (NoResultException ex) {
                return null;
            }
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findPage(int page, int size) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            if (page < 1) page = 1;
            if (size < 1) size = 10;

            String jpql = "SELECT u FROM User u ORDER BY u.id";
            TypedQuery<User> query = em.createQuery(jpql, User.class);

            int first = (page - 1) * size;
            query.setFirstResult(first);
            query.setMaxResults(size);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count != null ? count : 0L;
        } finally {
            em.close();
        }
    }

}
