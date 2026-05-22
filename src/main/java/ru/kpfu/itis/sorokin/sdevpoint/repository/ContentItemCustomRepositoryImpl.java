package ru.kpfu.itis.sorokin.sdevpoint.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Root;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class ContentItemCustomRepositoryImpl implements ContentItemCustomRepository {
    private final EntityManager entityManager;

    @Override
    public Page<ContentItem> findByOwnerId(Long userId, Pageable pageable) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();

        CriteriaQuery<ContentItem> contentQuery = cb.createQuery(ContentItem.class);
        Root<ContentItem> root = contentQuery.from(ContentItem.class);

        root.fetch("owner", JoinType.INNER);

        contentQuery.select(root)
                .where(cb.equal(root.get("owner").get("id"), userId))
                .orderBy(cb.desc(root.get("createdAt")));

        List<ContentItem> items = entityManager.createQuery(contentQuery)
                .setFirstResult((int) pageable.getOffset())
                .setMaxResults(pageable.getPageSize())
                .getResultList();

        CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
        Root<ContentItem> countRoot = countQuery.from(ContentItem.class);

        countQuery.select(cb.count(countRoot))
                .where(cb.equal(countRoot.get("owner").get("id"), userId));

        Long total = entityManager.createQuery(countQuery)
                .getSingleResult();

        return new PageImpl<>(items, pageable, total);
    }
}
