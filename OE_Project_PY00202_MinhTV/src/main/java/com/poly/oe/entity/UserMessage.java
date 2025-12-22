package com.poly.oe.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Entity
@Table(name = "UserMessage")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "UserId", length = 50, nullable = false)
    private String userId;

    @Column(name = "Title", nullable = false)
    private String title;

    @Lob
    @Column(name = "Content", nullable = false)
    private String content;

    @Column(name = "IsRead", nullable = false)
    private Boolean isRead;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedDate", nullable = false)
    private Date createdDate;
}
