package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Reaction;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ReactionType;

import java.util.Optional;

@Repository
public interface ReactionRepository extends JpaRepository<Reaction, Long> {
    Optional<Reaction> findByContentItemIdAndUserId(Long contentItemId, Long userId);

    long countByContentItemIdAndReactionType(Long contentItemId, ReactionType reactionType);
}
