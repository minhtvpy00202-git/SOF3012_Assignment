package com.poly.oe.dao.impl;

import com.poly.oe.dao.ShareDao;
import com.poly.oe.entity.Share;
import com.poly.oe.utils.JpaUtils;
import jakarta.persistence.EntityManager;

public class ShareDaoImpl implements ShareDao {

    @Override
    public Share create(Share e) {
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
}
