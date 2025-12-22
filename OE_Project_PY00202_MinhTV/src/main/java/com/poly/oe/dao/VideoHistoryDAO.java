package com.poly.oe.dao;

import java.util.Date;
import java.util.List;

import com.poly.oe.entity.VideoHistory;
import com.poly.oe.utils.JpaUtils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

public class VideoHistoryDAO {

    // 🔍 Tìm lịch sử theo user + video
    public VideoHistory findByUserAndVideo(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<VideoHistory> q = em.createQuery(
                    "SELECT h FROM VideoHistory h WHERE h.userId = :uid AND h.videoId = :vid",
                    VideoHistory.class
            );
            q.setParameter("uid", userId);
            q.setParameter("vid", videoId);
            return q.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    // ➕ Ghi lịch sử xem
    public void recordView(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();

            TypedQuery<VideoHistory> q = em.createQuery(
                    "SELECT h FROM VideoHistory h WHERE h.userId = :uid AND h.videoId = :vid",
                    VideoHistory.class
            );
            q.setParameter("uid", userId);
            q.setParameter("vid", videoId);

            VideoHistory history;
            try {
                history = q.getSingleResult();
                history.setLastViewDate(new Date());
                history.setViewCount(history.getViewCount() + 1);
                em.merge(history);
            } catch (Exception e) {
                history = VideoHistory.builder()
                        .userId(userId)
                        .videoId(videoId)
                        .lastViewDate(new Date())
                        .viewCount(1)
                        .build();
                em.persist(history);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }


    // 📜 Lấy lịch sử xem của user
    public List<VideoHistory> findByUser(String userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<VideoHistory> q = em.createQuery(
                    "SELECT h FROM VideoHistory h WHERE h.userId = :uid ORDER BY h.lastViewDate DESC",
                    VideoHistory.class
            );
            q.setParameter("uid", userId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    // ❌ Xóa 1 video khỏi lịch sử
    public void delete(String userId, String videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.createQuery(
                            "DELETE FROM VideoHistory h WHERE h.userId = :uid AND h.videoId = :vid"
                    )
                    .setParameter("uid", userId)
                    .setParameter("vid", videoId)
                    .executeUpdate();
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
