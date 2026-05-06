package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentStatus;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ItemType;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Repository
public interface ContentItemRepository extends JpaRepository<ContentItem, Long> {
    @Query("""
                select c
                from ContentItem c
                where c.owner.id = :userId
                  and c.itemType = :itemType
                  and c.contentStatus = 'DRAFT'
            """)
    Optional<ContentItem> findDraftByUserIdAndItemType(@Param("userId") Long userId, @Param("itemType") ItemType itemType);

    Page<ContentItem> findContentItemsByContentStatusAndItemType(ContentStatus contentStatus, ItemType itemType, Pageable pageable);

    @Query("""
        SELECT c
        FROM ContentItem c
        WHERE c.contentStatus = 'DRAFT'
            AND ((c.preview = '' AND c.createdAt <= :emptyDraftDeadline) OR c.updatedAt <= :savedDraftDeadline)
    """)
    List<ContentItem> findExpiredDrafts(Instant emptyDraftDeadline, Instant savedDraftDeadline);

    @Query("""
        SELECT c
        FROM ContentItem c
        LEFT JOIN FETCH c.images
        WHERE c.id = :id
    """)
    Optional<ContentItem> findByIdWithImages(Long id);
}
