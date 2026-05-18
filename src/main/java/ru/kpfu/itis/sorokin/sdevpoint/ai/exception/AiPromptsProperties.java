package ru.kpfu.itis.sorokin.sdevpoint.ai.exception;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.ai.prompts")
public record AiPromptsProperties(
        String summarySystemPromptPath,
        String explainTermSystemPromptPath,
        String summaryUserPromptPath,
        String explainTermUserPromptPath
) {
}
