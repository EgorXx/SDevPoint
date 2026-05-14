package ru.kpfu.itis.sorokin.sdevpoint.service.clean;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

import java.time.Duration;
import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DraftCleanupService {
    private final ContentItemRepository contentItemRepository;
    private final DraftDeletionService draftDeletionService;

    private static final Duration LIMIT_EMPTY_DRAFT = Duration.ofMinutes(1);
    private static final Duration LIMIT_SAVED_DRAFT = Duration.ofMinutes(2);

    @Transactional
    public void cleanupExpiredDrafts() {
        Instant now = Instant.now();

        Instant emptyDraftDeadline = now.minus(LIMIT_EMPTY_DRAFT);
        Instant savedDraftDeadline = now.minus(LIMIT_SAVED_DRAFT);

        List<ContentItem> expiredDrafts = contentItemRepository.findExpiredDrafts(
                emptyDraftDeadline,
                savedDraftDeadline
        );

        log.info("Drafts for deletion have been detected, size={}", expiredDrafts.size());

        for (ContentItem contentItem : expiredDrafts) {
            try {
                draftDeletionService.deleteExpiredDraft(contentItem.getId());
            } catch (Exception e) {
                log.error("An error occurred deleting contentItemId={}", contentItem.getId(), e);
            }
        }

    }
}
