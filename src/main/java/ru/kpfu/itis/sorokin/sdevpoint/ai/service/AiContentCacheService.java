package ru.kpfu.itis.sorokin.sdevpoint.ai.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.sorokin.sdevpoint.ai.client.AiClient;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiCompletionRequest;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiMessage;
import ru.kpfu.itis.sorokin.sdevpoint.ai.dto.AiSummaryResponse;
import ru.kpfu.itis.sorokin.sdevpoint.ai.entity.AiUsageType;
import ru.kpfu.itis.sorokin.sdevpoint.ai.exception.AiProviderException;
import ru.kpfu.itis.sorokin.sdevpoint.ai.properties.AiContentProperties;
import ru.kpfu.itis.sorokin.sdevpoint.exception.AiServiceUnavailableException;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ArticleRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.CaseRepository;
import ru.kpfu.itis.sorokin.sdevpoint.repository.ContentItemRepository;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiContentCacheService {
    private final AiClient aiClient;
    private final AiTextProcessor aiTextProcessor;
    private final AiPromptService aiPromptService;
    private final AiContentProperties aiContentProperties;
    private final AiContentTextService aiContentTextService;
    private final AiUsageLimitService aiUsageLimitService;

    @Cacheable(value = "aiSummary", key = "#contentItemId")
    @Transactional(readOnly = true)
    public AiSummaryResponse getOrGenerateSummary(Long contentItemId, Long userId) {
        aiUsageLimitService.checkAndConsume(userId, AiUsageType.SUMMARY);

        String contentText = aiContentTextService.loadContentText(contentItemId);

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
}
