package ru.kpfu.itis.sorokin.sdevpoint.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ContentLimitProperties;
import ru.kpfu.itis.sorokin.sdevpoint.properties.ImageUploadProperties;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemImageRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

@Service
@RequiredArgsConstructor
public class ContentLimitService {

    private final ContentItemImageRepository contentItemImageRepository;
    private final ContentItemRepository contentItemRepository;
    private final ContentLimitProperties contentLimitProperties;
    private final ImageUploadProperties imageUploadProperties;

    public void checkCountContentLimit(Long userId) {
        long countContents = contentItemRepository.countByOwnerId(userId);

        if (countContents >= contentLimitProperties.maxContentItemsPerUser()) {
            throw new BadRequestException("Превышен лимит количества контента");
        }
    }
}
