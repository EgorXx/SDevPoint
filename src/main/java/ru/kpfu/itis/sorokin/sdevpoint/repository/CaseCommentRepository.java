package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.CaseComment;

import java.util.Optional;

@Repository
public interface CaseCommentRepository extends JpaRepository<CaseComment, Long> {
    @Query(
            value = """
                SELECT cc
                FROM CaseComment cc
                JOIN FETCH cc.user
                WHERE cc.caseEntity.id = :caseId
            """,
            countQuery = """
                SELECT COUNT(cc)
                FROM CaseComment cc
                WHERE cc.caseEntity.id = :caseId
            """
    )
    Page<CaseComment> findByCaseEntityId(@Param("caseId") Long caseId, Pageable pageable);

    Optional<CaseComment> findByCaseEntityIdAndId(Long caseId, Long id);
}
