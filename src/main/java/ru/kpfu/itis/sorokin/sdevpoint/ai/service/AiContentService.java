package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.AiClient;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiCompletionRequest;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiExplainTermResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiMessage;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiSummaryResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.exception.AiProviderException;
import ru.kpfu.itis.sorokin.sdevpoint.ai.properties.AiContentProperties;
import ru.kpfu.itis.sorokin.sdevpoint.entity.*;
import ru.kpfu.itis.sorokin.sdevpoint.exception.BadRequestException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.AiServiceUnavailableException;
import ru.kpfu.itis.sorokin.sdevpoint.exception.NotFoundException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ArticleRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.CaseRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiContentService {
    private final AiClient aiClient;
    private final ContentItemRepository contentItemRepository;
    private final ArticleRepository articleRepository;
    private final CaseRepository caseRepository;
    private final AiTextProcessor aiTextProcessor;
    private final AiPromptService aiPromptService;
    private final AiContentProperties aiContentProperties;

    @Transactional(readOnly = true)
    public AiSummaryResponse getSummary(Long contentItemId, Long userId) {
        String contentText = loadContentTextWithAccessCheck(contentItemId, userId);

        String limitedText = aiTextProcessor.trimToLimit(
                contentText,
                aiContentProperties.maxSummaryInputChars()
        );


        try {
            String summary = aiClient.complete(
                    new AiCompletionRequest(
                            List.of(
                                    AiMessage.system(
                                            aiPromptService.buildSummarySystemPrompt()),
                                    AiMessage.user(
                                            aiPromptService.buildSummaryUserPrompt(limitedText))
                            ), null, null));

            return new AiSummaryResponse(summary);
        } catch (AiProviderException e) {
            log.warn("Something went wrong when getting the summary: {}", e.getMessage(), e);
            throw new AiServiceUnavailableException("Не удалось получить краткое содержание контента");
        }
    }

    @Transactional(readOnly = true)
    public AiExplainTermResponse explainTerm(Long contentId, Long userId, String term) {
        validateTerm(term);

        String contentText = loadContentTextWithAccessCheck(contentId, userId);

        String limitedText = aiTextProcessor.trimToLimit(
                contentText,
                aiContentProperties.maxExplainInputChars()
        );

        try {
            String explanation = aiClient.complete(
                    new AiCompletionRequest(
                            List.of(
                                    AiMessage.system(
                                            aiPromptService.buildExplainTermSystemPrompt()),
                                    AiMessage.user(
                                            aiPromptService.buildExplainTermUserPrompt(term.trim(), limitedText))
                            ), null, null));

            return new AiExplainTermResponse(term.trim(), explanation);
        } catch (AiProviderException e) {
            log.warn("Something went wrong when getting the explain term: {}", e.getMessage(), e);
            throw new AiServiceUnavailableException("Не удалось получить объяснение термина");
        }
    }

    private void validateTerm(String term) {
        int length = term.codePointCount(0, term.length());

        if (length > aiContentProperties.maxTermLength()) {
            throw new BadRequestException("Термин слишком длинный");
        }
    }

    private String loadContentTextWithAccessCheck(Long contentItemId, Long userId) {
        ContentItem contentItem = contentItemRepository
                .findWithOwnerById(contentItemId)
                .orElseThrow(() -> new NotFoundException("Контент не найден"));

        checkAccessAiFunction(contentItem, userId);

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

    private void checkAccessAiFunction(ContentItem contentItem, Long userId) {
        if (contentItem.getContentStatus() != ContentStatus.PUBLISHED) {
            throw new NotFoundException("Контент не найден");
        }

        if (contentItem.getVisibility() == Visibility.PRIVATE && !isOwner(contentItem, userId)) {
            throw new NotFoundException("Контент не найден");
        }
    }

    private boolean isOwner(ContentItem contentItem, Long userId) {
        return contentItem.getOwner().getId().equals(userId);
    }
}
