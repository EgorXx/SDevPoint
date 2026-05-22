package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.Hibernate;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "content_item")
public class ContentItem {
    private static final String DRAFT_TITLE_PREFIX = "__draft__";
    private static final String EMPTY_PREVIEW = "";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User owner;

    @Column(nullable = false)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(name = "item_type", nullable = false)
    private ItemType itemType;

    @Column(name = "created_at",nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at",nullable = false)
    private Instant updatedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "content_status", nullable = false)
    private ContentStatus contentStatus;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Visibility visibility;

    @Size(max = 150)
    @Column(nullable = false)
    private String preview;

    @OneToMany(
            mappedBy = "contentItem",
            fetch = FetchType.LAZY,
            cascade = CascadeType.ALL,
            orphanRemoval = true)
    private List<ContentItemImage> images;

    public static ContentItem createDraft(User user, ItemType itemType) {
        Instant now = Instant.now();

        return new ContentItem(
                null,
                user,
                generateDraftTitle(itemType),
                itemType,
                now,
                now,
                ContentStatus.DRAFT,
                Visibility.PRIVATE,
                EMPTY_PREVIEW,
                null
        );
    }

    private static String generateDraftTitle(ItemType itemType) {
        return DRAFT_TITLE_PREFIX + itemType.name().toLowerCase() + "_" + UUID.randomUUID();
    }

    public static boolean isGenerateTitle(String title) {
        if (title == null) {return false;}

        return title.startsWith(DRAFT_TITLE_PREFIX);
    }

    @Override
    public final boolean equals(Object o) {
        if (this == o) {
            return true;
        }

        if (o == null) {
            return false;
        }

        if (Hibernate.getClass(this) != Hibernate.getClass(o)) {
            return false;
        }

        ContentItem that = (ContentItem) o;

        return id != null && id.equals(that.id);
    }

    @Override
    public final int hashCode() {
        return Hibernate.getClass(this).hashCode();
    }

}
