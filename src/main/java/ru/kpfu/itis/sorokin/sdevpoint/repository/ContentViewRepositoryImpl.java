package ru.kpfu.itis.sorokin.sdevpoint.repository;

import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ContentViewRepositoryImpl implements ContentViewRepository {
    private final EntityManager entityManager;

    @Override
    public int insertIfNotExists(Long contentItemId, Long userId) {
        String insertSql = """
                INSERT INTO content_view (content_item_id, user_id)
                VALUES (:contentItemId, :userId)
                ON CONFLICT DO NOTHING
                """;

        return entityManager.createNativeQuery(insertSql)
                .setParameter("contentItemId", contentItemId)
                .setParameter("userId", userId)
                .executeUpdate();
    }

    @Override
    public long countViewsContent(Long contentItemId) {
        String countSql = """
                SELECT COUNT(*)
                FROM content_view cv
                WHERE cv.content_item_id = :contentItemId
                """;

        return (Long) entityManager.createNativeQuery(countSql)
                .setParameter("contentItemId", contentItemId)
                .getSingleResult();
    }
}
