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
import ru.kpfu.itis.sorokin.sdevpoint.ai.entity.AiUsageType;
import ru.kpfu.itis.sorokin.sdevpoint.ai.exception.AiProviderException;
import ru.kpfu.itis.sorokin.sdevpoint.ai.properties.AiContentProperties;
import ru.kpfu.itis.sorokin.sdevpoint.exception.AiServiceUnavailableException;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AiContentService {
    private final AiClient aiClient;
    private final AiTextProcessor aiTextProcessor;
    private final AiPromptService aiPromptService;
    private final AiContentProperties aiContentProperties;
    private final AiContentAccessService aiContentAccessService;
    private final AiContentCacheService aiContentCacheService;
    private final AiContentTextService aiContentTextService;
    private final AiUsageLimitService aiUsageLimitService;

    public AiSummaryResponse getSummary(Long contentItemId, Long userId) {
        aiContentAccessService.checkAccess(contentItemId, userId);

        return aiContentCacheService.getOrGenerateSummary(contentItemId, userId);
    }

    @Transactional(readOnly = true)
    public AiExplainTermResponse explainTerm(Long contentId, Long userId, String term) {
        aiContentAccessService.checkAccess(contentId, userId);

        aiUsageLimitService.checkAndConsume(userId, AiUsageType.EXPLAIN_TERM);

        String contentText = aiContentTextService.loadContentText(contentId);

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
}
