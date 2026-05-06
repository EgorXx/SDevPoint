package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

@Service
@RequiredArgsConstructor
public class DraftDeletionService {

    private final ContentItemRepository contentItemRepository;
    private final ImageService imageService;

    @Transactional
    public void deleteExpiredDraft(Long contentItemId) {
        ContentItem draft = contentItemRepository.findByIdWithImages(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        draft.getImages().forEach(image ->
                imageService.deleteImage(image.getStorageKey())
        );

        contentItemRepository.delete(draft);
    }
}
