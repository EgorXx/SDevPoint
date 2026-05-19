package ru.kpfu.itis.sorokin.sdevpoint.ai.client.deepseek.dto;

public record DeepSeekMessage(
        String role,
        String content
) {}