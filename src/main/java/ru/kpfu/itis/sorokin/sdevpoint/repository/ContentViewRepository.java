package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.stereotype.Repository;

public interface ContentViewRepository {
    int insertIfNotExists(Long contentItemId, Long userId);

    long countViewsContent(Long contentItemId);
}
