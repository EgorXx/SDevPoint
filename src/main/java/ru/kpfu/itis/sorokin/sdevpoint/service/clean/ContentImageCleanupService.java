package ru.kpfu.itis.sorokin.sdevpoint.service.clean;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItemImage;
import ru.kpfu.itis.sorokin.sdevpoint.entity.StorageDeletionTask;
import ru.kpfu.itis.sorokin.sdevpoint.markdown.MarkdownImageReferenceExtractor;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemImageRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.StorageDeletionTaskRepository;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ContentImageCleanupService {
    private final MarkdownImageReferenceExtractor imageReferenceExtractor;
    private final ContentItemImageRepository contentItemImageRepository;
    private final StorageDeletionTaskRepository storageDeletionTaskRepository;

    @Transactional
    public void cleanupUnusedImages(Long contentItemId, Collection<String> markdownTexts) {
        Set<UUID> usedPublicIds = imageReferenceExtractor.extractPublicIds(markdownTexts);

        List<ContentItemImage> contentItemImages = contentItemImageRepository.findByContentItemId(contentItemId);

        List<ContentItemImage> unusedImages = contentItemImages.stream()
                .filter(itemImage -> !usedPublicIds.contains(itemImage.getPublicId()))
                .toList();

        log.info("Unused images have been detected, size={}", unusedImages.size());

        for (var i : unusedImages) {
            storageDeletionTaskRepository.save(
                    StorageDeletionTask.createFileDeletion(i.getStorageKey())
            );

            contentItemImageRepository.delete(i);
        }
    }

}
