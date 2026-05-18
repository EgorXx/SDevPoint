package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

@Service
@RequiredArgsConstructor
public class AiContentAccessService {
    private final ContentItemRepository contentItemRepository;

    public void checkAccess(Long contentItemId, Long userId) {
        ContentItem contentItem = contentItemRepository
                .findWithOwnerById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        if (contentItem.getContentStatus() != ContentStatus.PUBLISHED) {
            throw new BadRequestException("Невозможно получить summary, пока контент не опубликован");
        }

        if (contentItem.getVisibility() == Visibility.PRIVATE && !isOwner(contentItem, userId)) {
            throw new NotFoundException("Контент не найден");
        }
    }

    private boolean isOwner(ContentItem contentItem, Long userId) {
        return contentItem.getOwner().getId().equals(userId);
    }
}
