package ru.kpfu.itis.sorokin.sdevpoint.service.clean;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.properties.CleanContentProperties;
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
    private final CleanContentProperties cleanContentProperties;

    @Transactional
    public void cleanupExpiredDrafts() {
        Instant now = Instant.now();

        Instant emptyDraftDeadline = now.minus(cleanContentProperties.limitEmptyDraft());
        Instant savedDraftDeadline = now.minus(cleanContentProperties.limitSavedDraft());

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
