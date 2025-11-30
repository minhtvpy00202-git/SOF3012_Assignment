package com.poly.oe.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "CommentLikes")
public class CommentLike {

    @EmbeddedId
    private CommentLikeId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    @JoinColumn(name = "UserId", referencedColumnName = "Id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("commentId")
    @JoinColumn(name = "CommentId", referencedColumnName = "Id")
    private Comment comment;

    @Column(name = "IsLike", nullable = false)
    private Boolean isLike = true;

    @Column(name = "CreateDate", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createDate = new Date();

    public CommentLike() {}

    public CommentLike(User user, Comment comment, Boolean isLike) {
        this.user = user;
        this.comment = comment;
        this.isLike = isLike != null ? isLike : true;
        this.id = new CommentLikeId(user.getId(), comment.getId());
    }

    // getters / setters
    public CommentLikeId getId() { return id; }
    public void setId(CommentLikeId id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Comment getComment() { return comment; }
    public void setComment(Comment comment) { this.comment = comment; }

    public Boolean getIsLike() { return isLike; }
    public void setIsLike(Boolean isLike) { this.isLike = isLike; }

    public Date getCreateDate() { return createDate; }
    public void setCreateDate(Date createDate) { this.createDate = createDate; }
}
