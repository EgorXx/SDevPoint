package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Article;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;

import java.util.List;
import java.util.Optional;

public interface ArticleRepository extends JpaRepository<Article, Long> {
    Optional<Article> findByContentItem(ContentItem contentItem);

    @Query("""
        SELECT a
        FROM Article a
        JOIN FETCH a.contentItem ci
        WHERE ci.visibility = 'PUBLIC'
            AND ci.contentStatus = 'PUBLISHED'
            AND ci.itemType = 'ARTICLE'
    """)
    List<Article> findAllPublicPublished();

    @Query("""
        SELECT a
        FROM Article a
        JOIN FETCH a.contentItem ci
        WHERE a.id = :id
    """)
    Optional<Article> findById(@Param("id") Long id);

    @Query("""
        SELECT a
        FROM Article a
        JOIN FETCH a.contentItem ci
        WHERE ci.id = :contentId
    """)
    Optional<Article> findByContentItemId(@Param("contentId") Long contentId);
}
