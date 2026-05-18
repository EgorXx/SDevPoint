package ru.kpfu.itis.sorokin.sdevpoint.ai.client.openrouter.dto;

import java.util.List;

public record OpenRouterChatResponse(
        List<OpenRouterChoice> choices
) {}
