package com.poly.oe.dao;

import com.poly.oe.entity.Notification;
import com.poly.oe.utils.JpaUtils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.Date;
import java.util.List;

public class NotificationDAO {

    // ➕ Tạo thông báo
    public void create(Notification noti) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            noti.setCreatedAt(new Date());
            noti.setIsRead(false);
            em.persist(noti);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // 📜 Lấy thông báo theo user
    public List<Notification> findByUser(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Notification> q = em.createQuery(
                    "SELECT n FROM Notification n WHERE n.userId = :uid ORDER BY n.createdAt DESC",
                    Notification.class
            );
            q.setParameter("uid", userId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    // 🔔 Đếm thông báo chưa đọc
    public long countUnread(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT COUNT(n) FROM Notification n WHERE n.userId = :uid AND n.isRead = false",
                            Long.class
                    ).setParameter("uid", userId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    // ✅ Đánh dấu đã đọc
    public void markAsRead(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Notification n = em.find(Notification.class, id);
            if (n != null) {
                n.setIsRead(true);
                em.merge(n);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // ❌ Xóa thông báo
    public void delete(Integer id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Notification n = em.find(Notification.class, id);
            if (n != null) {
                em.remove(n);
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
