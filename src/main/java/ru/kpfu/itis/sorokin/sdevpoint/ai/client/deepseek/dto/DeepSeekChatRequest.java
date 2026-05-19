package ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public record DeepSeekChatRequest(
        String model,
        List<DeepSeekMessage> messages,

        @JsonProperty("max_tokens")
        Integer maxTokens,

        Double temperature
) {}
