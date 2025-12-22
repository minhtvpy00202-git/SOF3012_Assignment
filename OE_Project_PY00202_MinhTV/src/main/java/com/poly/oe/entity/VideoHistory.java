package com.poly.oe.entity;

import java.util.Date;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(
        name = "VideoHistory",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"UserId", "VideoId"})
        }
)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VideoHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "UserId", length = 50, nullable = false)
    private String userId;

    @Column(name = "VideoId", length = 20, nullable = false)
    private String videoId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "LastViewDate", nullable = false)
    private Date lastViewDate;

    @Column(name = "ViewCount", nullable = false)
    private Integer viewCount;
}
