package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Article;
import ru.kpfu.itis.sorokin.sdevpoint.entity.Case;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ContentItem;
import ru.kpfu.itis.sorokin.sdevpoint.entity.ItemType;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ArticleRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.CaseRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

@Service
@RequiredArgsConstructor
public class AiContentTextService {
    private final ContentItemRepository contentItemRepository;
    private final ArticleRepository articleRepository;
    private final CaseRepository caseRepository;

    public String loadContentText(Long contentItemId) {
        ContentItem contentItem = contentItemRepository
                .findById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        String contentText;

        if (contentItem.getItemType() == ItemType.ARTICLE) {
            contentText = articleRepository
                    .findByContentItemId(contentItemId)
                    .map(Article::getText)
                    .orElseThrow(() -> new NotFoundException("Контент не найден"));
        } else {
            contentText = caseRepository
                    .findByContentItemId(contentItemId)
                    .map(Case::getDescription)
                    .orElseThrow(() -> new NotFoundException("Контент не найден"));
        }
        return contentText;
    }
}
