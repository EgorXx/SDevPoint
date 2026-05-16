package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Entity
@Table(name = "content_rejection_comment")
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ContentRejectionComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "content_item_id", nullable = false, unique = true)
    private ContentItem contentItem;

    @Column(name = "comment", nullable = false, columnDefinition = "text")
    private String comment;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    public static ContentRejectionComment create(ContentItem contentItem, String comment) {
        return new ContentRejectionComment(
                null,
                contentItem,
                comment,
                Instant.now()
        );
    }

    public void updateComment(String comment) {
        this.comment = comment;
        this.createdAt = Instant.now();
    }
}
