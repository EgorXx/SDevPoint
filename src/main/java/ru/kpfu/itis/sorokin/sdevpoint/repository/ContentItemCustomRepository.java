package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;

public interface ContentItemCustomRepository {
    Page<ContentItem> findByOwnerId(Long userId, Pageable pageable);
}
