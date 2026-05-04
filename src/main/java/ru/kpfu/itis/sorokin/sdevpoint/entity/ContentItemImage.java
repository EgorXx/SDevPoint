package ru.kpfu.itis.sorokin.sdevpoint.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "content_item_image")
public class ContentItemImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "content_item_id", nullable = false)
    private ContentItem contentItem;

    @Column(name = "original_name", nullable = false, length = 255)
    private String originalName;

    @Column(name = "storage_key", nullable = false, length = 256)
    private String storageKey;

    @Positive
    @Column(name = "size", nullable = false)
    private Long size;

    @Positive
    @Column(name = "height", nullable = false)
    private Integer height;

    @Positive
    @Column(name = "width", nullable = false)
    private Integer width;

    @Column(name = "content_type", nullable = false, length = 32)
    private String contentType;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "public_id", nullable = false)
    private UUID publicId;
}
