package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItemImage;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ContentItemImageRepository extends JpaRepository<ContentItemImage, Long> {
    @EntityGraph(attributePaths = "contentItem")
    Optional<ContentItemImage> findByPublicId(UUID publicId);

    List<ContentItemImage> findByContentItemId(Long contentItemId);

    Optional<ContentItemImage> findByContentItemIdAndPublicId(Long contentItemId, UUID publicId);

    @Query("""
        SELECT COALESCE(SUM(ci.size), 0)
        FROM ContentItemImage ci
        WHERE ci.contentItem.id = :contentItemId
    """)
    long sumSizeByContentItemId(@Param("contentItemId") Long contentItemId);

    @Query("""
    SELECT COALESCE(SUM(i.size), 0)
    FROM ContentItemImage i
    WHERE i.contentItem.owner.id = :userId
""")
    long sumSizeByOwnerId(@Param("userId") Long userId);
}
