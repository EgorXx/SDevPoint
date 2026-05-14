package ru.kpfu.itis.sorokin.sdevpoint.service.clean;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTask;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.StorageDeletionTaskRepository;

@Service
@RequiredArgsConstructor
public class DraftDeletionService {
    private final ContentItemRepository contentItemRepository;
    private final StorageDeletionTaskRepository storageDeletionTaskRepository;

    @Transactional
    public void deleteExpiredDraft(Long contentItemId) {
        ContentItem draft = contentItemRepository.findByIdWithImages(contentItemId)
                .orElseThrow(() -> new NotFoundException("Content not found"));

        StorageDeletionTask deletionTask = StorageDeletionTask
                .createContentDirectoryDeletion(contentItemId);

        contentItemRepository.delete(draft);
        storageDeletionTaskRepository.save(deletionTask);
    }
}
