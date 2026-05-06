package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Case;

import java.util.Optional;

@Repository
public interface CaseRepository extends JpaRepository<Case, Long> {
    @Query("""
        SELECT c
        FROM Case c
        JOIN FETCH c.contentItem ci
        WHERE ci.id = :contentItemId
    """)
    Optional<Case> findByContentItemId(@Param("contentItemId") Long contentItemId);
}
