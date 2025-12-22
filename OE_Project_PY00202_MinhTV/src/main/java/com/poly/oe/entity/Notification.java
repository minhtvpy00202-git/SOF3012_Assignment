package com.poly.oe.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Entity
@Table(name = "Notification")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "UserId", length = 50, nullable = false)
    private String userId;

    @Column(name = "Title", nullable = false)
    private String title;

    @Column(name = "Content", length = 1000, nullable = false)
    private String content;

    @Column(name = "IsRead", nullable = false)
    private Boolean isRead;

    @Column(name = "Type", length = 50)
    private String type;

    @Column(name = "TargetUrl", length = 255)
    private String targetUrl;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt", nullable = false)
    private Date createdAt;
}
