package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItemImage;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ContentItemImageRepository extends JpaRepository<ContentItemImage, Long> {
    Optional<ContentItemImage> findByPublicId(UUID publicId);

    List<ContentItemImage> findByContentItemId(Long contentItemId);

    Optional<ContentItemImage> findByContentItemIdAndPublicId(Long contentItemId, UUID publicId);
}
