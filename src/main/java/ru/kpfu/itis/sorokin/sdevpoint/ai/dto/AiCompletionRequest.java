package ru.kpfu.itis.sorokin.sdevpoint.ai.dto;

import java.util.List;

public record AiCompletionRequest(
        List<AiMessage> messages,
        Integer maxTokens,
        Double temperature
) {}
