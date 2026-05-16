package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentRejectionComment;

import java.util.Optional;

@Repository
public interface ContentRejectionCommentRepository extends JpaRepository<ContentRejectionComment, Long> {
    void deleteByContentItemId(Long contentItemId);

    Optional<ContentRejectionComment> findByContentItemId(Long contentItemId);
}
