package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentStatus;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ItemType;
import ru.kpfu.itis.sorokin.sdevpoint.entity.User;

import java.util.Optional;

@Repository
public interface ContentItemRepository extends JpaRepository<ContentItem, Long> {
    @Query("""
                select c
                from ContentItem c
                where c.owner.id = :userId
                  and c.itemType = 'ARTICLE'
                  and c.contentStatus = 'DRAFT'
            """)
    Optional<ContentItem> findDraftArticleByUserId(@Param("userId") Long userId);
}
