package ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.dto;

import java.util.List;

public record DeepSeekChatResponse(
        List<DeepSeekChoice> choices
) {}