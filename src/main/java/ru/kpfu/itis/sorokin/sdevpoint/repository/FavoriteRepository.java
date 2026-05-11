package ru.kpfu.itis.sorokin.sdevpoint.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Favorite;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {

    @Query(value = """
        SELECT f
        FROM Favorite f
        JOIN FETCH f.contentItem ci
        JOIN FETCH ci.owner
        WHERE f.user.id = :userId
    """,
    countQuery = """
        SELECT COUNT(f)
        FROM Favorite f
        WHERE f.user.id = :userId
    """)
    Page<Favorite> findByUserId(@Param("userId") Long userId, Pageable pageable);

    Optional<Favorite> findByUserIdAndContentItemId(Long userId, Long contentId);

    @Query("""
        SELECT f.contentItem.id
        FROM Favorite f
        WHERE f.user.id = :userId
            AND f.contentItem.id IN :contentIds
    """)
    Set<Long> findFavoriteContentIds(@Param("userId") Long userId, @Param("contentIds") Collection<Long> contentIds);
}
