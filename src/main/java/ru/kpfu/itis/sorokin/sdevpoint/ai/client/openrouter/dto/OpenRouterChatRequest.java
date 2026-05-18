package ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public record OpenRouterChatRequest(
        String model,
        List<OpenRouterMessage> messages,

        @JsonProperty("max_tokens")
        Integer maxTokens,

        Double temperature
) {}
