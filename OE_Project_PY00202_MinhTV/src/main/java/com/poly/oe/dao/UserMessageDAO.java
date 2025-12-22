package com.poly.oe.dao;

import com.poly.oe.entity.UserMessage;
import com.poly.oe.utils.JpaUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class UserMessageDAO {

    // 📩 Gửi thư (Admin)
    public void create(UserMessage msg) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(msg);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    // 📬 Lấy inbox của user
    public List<UserMessage> findByUser(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<UserMessage> q = em.createQuery(
                    "SELECT m FROM UserMessage m WHERE m.userId = :uid ORDER BY m.createdDate DESC",
                    UserMessage.class
            );
            q.setParameter("uid", userId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    // 🔍 Xem chi tiết 1 thư
    public UserMessage findById(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(UserMessage.class, id);
        } finally {
            em.close();
        }
    }

    // ✅ Đánh dấu đã đọc
    public void markAsRead(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            UserMessage msg = em.find(UserMessage.class, id);
            if (msg != null) {
                msg.setIsRead(true);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    // 🔔 Đếm thư chưa đọc (badge)
    public long countUnread(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT COUNT(m) FROM UserMessage m WHERE m.userId = :uid AND m.isRead = false",
                            Long.class
                    ).setParameter("uid", userId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    // ❌ Xóa 1 thư
    public void delete(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            UserMessage msg = em.find(UserMessage.class, id);
            if (msg != null) {
                em.remove(msg);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
