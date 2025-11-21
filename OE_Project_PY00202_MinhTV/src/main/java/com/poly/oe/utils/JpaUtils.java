package com.poly.oe.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtils {

    private static EntityManagerFactory factory;

    static {
        try {
            // TÊN NÀY PHẢI GIỐNG y chang trong persistence.xml
            factory = Persistence.createEntityManagerFactory("OE_AssignmentPU");
        } catch (Exception e) {
            e.printStackTrace();      // rất quan trọng để biết lỗi cấu hình
        }
    }

    public static EntityManager getEntityManager() {
        if (factory == null) {
            throw new IllegalStateException("EntityManagerFactory chưa được khởi tạo. Kiểm tra lại persistence.xml hoặc tên persistence-unit.");
        }
        return factory.createEntityManager();
    }
}
