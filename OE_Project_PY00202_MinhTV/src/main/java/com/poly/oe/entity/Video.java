package com.poly.oe.entity;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "Videos")
public class Video {

    @Id
    @Column(name = "Id")
    private String id;

    @Column(name = "Title", nullable = false)
    private String title;

    @Column(name = "Poster")
    private String poster;

    @Column(name = "Views", nullable = false)
    private int views;

    @Column(name = "Description")
    private String description;

    @Column(name = "Active", nullable = false)
    private boolean active;

    @Column(name = "Href")       // ← THÊM DÒNG NÀY
    private String href;

    @Column(name = "IsDelete", nullable = false)
    private boolean isDelete;
}
